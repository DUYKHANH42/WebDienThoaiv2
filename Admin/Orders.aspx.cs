using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;

namespace WebDienThoai.Admin
{
    public partial class Orders : System.Web.UI.Page
    {

        DonHangDAO dao = new DonHangDAO();
        int pageSize = 5;

        public int CurrentPage
        {
            get { return ViewState["CurrentPage"] == null ? 1 : (int)ViewState["CurrentPage"]; }
            set { ViewState["CurrentPage"] = value; }
        }

        public int TotalPages
        {
            get { return ViewState["TotalPages"] == null ? 1 : (int)ViewState["TotalPages"]; }
            set { ViewState["TotalPages"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDuLieu();

            }

        }
        void LoadPager(int currentPage, int totalPage)
        {
            CurrentPage = currentPage;
            TotalPages = totalPage;

            rpPaging.DataSource = Enumerable.Range(1, totalPage)
                .Select(x => new
                {
                    Page = x,
                    Css = x == currentPage
                    ? "size-8 flex items-center justify-center rounded-lg bg-primary text-white font-black text-xs"
                    : "size-8 flex items-center justify-center rounded-lg text-slate-600 font-bold text-xs hover:bg-white"
                });

            rpPaging.DataBind();
        }
        protected void btnView_Command(object sender, CommandEventArgs e)
        {
            int orderID = Convert.ToInt32(e.CommandArgument);
            OpenOrderModal(orderID);
        }
        protected void OpenOrderModal(int orderID)
        {
            DataTable dt = dao.GetByID(orderID);
            DataTable dtItems = dao.GetOrderItems(orderID);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];

                hfOrderID.Value = row["SoDH"].ToString();

                litMaDonHang.Text = row["MaDonHang"].ToString();
                litTenKH.Text = row["TenNguoiNhan"].ToString();
                litSDT.Text = row["DienThoaiNhan"].ToString();
                litDiaChi.Text = row["DiaChiNhan"].ToString();
                litTongTien.Text = Convert.ToDecimal(row["TriGia"]).ToString("N0") + " ₫";

                ddlOrderStatus.SelectedValue = row["MaTrangThai"].ToString();
                rptOrderItems.DataSource = dtItems;
                rptOrderItems.DataBind();
                litThanhToan.Text =
                    $"<span class='badge bg-white text-primary rounded-pill px-3 py-1 border border-primary-subtle'>" +
                    $"{row["TenTrangThai"]} ({row["PhuongThucThanhToan"]})</span>";
                ScriptManager.RegisterStartupScript(this, this.GetType(),
    "openModal",
    "var myModal = new bootstrap.Modal(document.getElementById('modalOrderManager')); myModal.show();",
    true);
            }
        }

        private void LoadDuLieu(int page = 1, int maTrangThai = 0)
        {
            if (page < 1)
                page = 1;

            string search = ViewState["search"]?.ToString();
            string phuongThuc = ViewState["phuongThuc"]?.ToString();
            string ngay = ViewState["ngay"]?.ToString();

            int totalRow;

            DataTable dt;

            if (!string.IsNullOrEmpty(search) || !string.IsNullOrEmpty(phuongThuc) || !string.IsNullOrEmpty(ngay))
            {
                dt = dao.FilterDonHang(search, phuongThuc, ngay, page, pageSize, maTrangThai, out totalRow);
            }
            else
            {
                dt = dao.GetDonHangPaging(page, pageSize, maTrangThai, out totalRow);
            }

            rptDonHang.DataSource = dt;
            rptDonHang.DataBind();

            int totalPage = (int)Math.Ceiling((double)totalRow / pageSize);

            LoadPager(page, totalPage);
        }
        protected void rpPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Page")
            {
                int page = int.Parse(e.CommandArgument.ToString());
                LoadDuLieu(page);
            }
        }
        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
                LoadDuLieu(CurrentPage - 1);
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
                LoadDuLieu(CurrentPage + 1);
        }
        protected void UpdateStatus_Click(object sender, EventArgs e)
        {
            try
            {
                int orderID = int.Parse(hfOrderID.Value);
                int newStatus = int.Parse(ddlOrderStatus.SelectedValue);

                DonHangDAO dao = new DonHangDAO();
                dao.UpdateTrangThai(orderID, newStatus);

                LoadDuLieu();

                ScriptManager.RegisterStartupScript(this, GetType(),
                "success",
                @"
       var modalEl = document.getElementById('modalOrderManager');
var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
modal.hide();

document.querySelectorAll('.modal-backdrop').forEach(function(el) {
    el.remove();
});
document.body.classList.remove('modal-open');
document.body.style = '';

        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'success',
            title: 'Cập nhật thành công!',
            showConfirmButton: false,
            timer: 1200,
            timerProgressBar: true
        });
        ",
                true);
            }
            catch (Exception ex)
            {
                // Nếu lỗi thì hiện toast lỗi và KHÔNG đóng modal
                ScriptManager.RegisterStartupScript(this, GetType(),
                "error",
                $@"
        Swal.fire({{
            toast: true,
            position: 'top-end',
            icon: 'error',
            title: 'Có lỗi xảy ra!',
            text: '{ex.Message.Replace("'", "")}',
            showConfirmButton: false,
            timer: 2000
        }});
        ",
                true);
            }
        }
        protected void btnFilter_Click(object sender, EventArgs e)
        {

            string search = txtSearch.Text.Trim();
            string phuongThuc = ddlThanhToan.SelectedValue;
            string ngay = txtNgay.Text;

            ViewState["search"] = search;
            ViewState["phuongThuc"] = phuongThuc;
            ViewState["ngay"] = ngay;

            CurrentPage = 1;

            LoadDuLieu(CurrentPage);
        }
        private void SetActiveTab(LinkButton activeBtn)
        {
            btnAll.CssClass = "nav-link";
            btnAwaiting.CssClass = "nav-link";
            btnPending.CssClass = "nav-link";
            btnShipping.CssClass = "nav-link";
            btnCompleted.CssClass = "nav-link";
            btnCancelled.CssClass = "nav-link";

            activeBtn.CssClass = "nav-link active";
        }


        protected void Filter_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string statusStr = btn.CommandArgument;
            int status;

            if (!int.TryParse(statusStr, out status))
            {
                status = 0; 
            }
            LoadDuLieu(1,status);
            SetActiveTab(btn);
        }
    }
}

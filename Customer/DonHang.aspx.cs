using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using WebDienThoai.DAO;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class DonHang : System.Web.UI.Page
    {
        LSDonHangDAO lsdao = new LSDonHangDAO();
        SanPhamDAO spDAO = new SanPhamDAO();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrders("All");
            }
        }
        private void LoadOrders(string status)
        {
            int maKH = Convert.ToInt32(Session["MaKH"]);
            if (status == "All")
                rptOrders.DataSource = lsdao.GetByMaKh(maKH);
            else
                rptOrders.DataSource = lsdao.GetByMaKhAndStatus(maKH, int.Parse(status));

            rptOrders.DataBind();
        }

        protected void FilterOrders(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string status = btn.CommandArgument;

            LoadOrders(status);
            SetActiveTab(btn);
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

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            if (Session["MaKH"] == null)
                return;

            int maKH = Convert.ToInt32(Session["MaKH"]);
            int maSP = Convert.ToInt32(hfReviewMaSP.Value);
            int soSao = Convert.ToInt32(hfRating.Value);
            string noiDung = txtReviewContent.Text.Trim();
            DanhGia dg = new DanhGia
            {
                maSP = maSP,
                maKH = maKH,
                SoSao = soSao,
                NoiDung = noiDung,
                ngayDG = DateTime.Now
            };
            DanhGiaDAO dao = new DanhGiaDAO();
            bool result = dao.Insert(dg);
            if (result)
            {
                LinkButton btn = (LinkButton)sender;
                string status = btn.CommandArgument;
                updOrders.Update();
                ScriptManager.RegisterStartupScript(this, this.GetType(),
        "success",
        @"Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'success',
            title: 'Gửi đánh giá thành công!',
            showConfirmButton: false,
            timer: 1500,
            timerProgressBar: true
        }).then(() => {
            var modal = bootstrap.Modal.getInstance(document.getElementById('modalReview'));
            if(modal) modal.hide();
            window.location.href = window.location.pathname;
        });",
        true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                    "error",
                    @"Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'error',
            title: 'Không thể gửi đánh giá!',
            showConfirmButton: false,
            timer: 1500
        });",
                    true);
            }
        }

        protected void btnReorder_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string[] data = btn.CommandArgument.Split('|');

            int maSP = Convert.ToInt32(data[0]);
            int maMau = Convert.ToInt32(data[1]);
            int soLuong = Convert.ToInt32(data[2]);

            List<CartItem> cart = Session["Cart"] as List<CartItem>;
            if (cart == null)
                cart = new List<CartItem>();
            var sp = spDAO.GetSPByID(maSP);
            var mau = new MauSac().GetByMaMau(maMau);

            if (sp == null || mau == null)
                return;

            var existingItem = cart
                .FirstOrDefault(x => x.SanPham.MaSP == maSP && x.MauSac.MaMau == maMau);

            if (existingItem != null)
            {
                existingItem.SoLuong += soLuong;
            }
            else
            {
                cart.Add(new CartItem
                {
                    SanPham = sp,
                    MaSP = sp.MaSP,
                    TenSP = sp.TenSP,
                    HinhAnh = sp.AnhSP,
                    DonGia = sp.DonGia,
                    MauSac = mau,
                    SoLuong =soLuong
                });
            }
            Session["Cart"] = cart;

            Response.Redirect("~/Customer/CartList.aspx");

        }
    }
}
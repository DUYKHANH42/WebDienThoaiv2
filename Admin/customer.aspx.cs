using System;
using System.Collections.Generic;
using System.Drawing.Printing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;

namespace WebDienThoai.Admin
{
    public partial class customer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadKhachHang(1);
            }
        }
        int pageSize = 1;

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

        private void LoadKhachHang(int page)
        {
            KhachHangDAO dao = new KhachHangDAO();

            int totalRow;

            var list = dao.GetKhachHangPaging(page, pageSize, out totalRow);

            rpKhachHang.DataSource = list;
            rpKhachHang.DataBind();

            int totalPage = (int)Math.Ceiling((double)totalRow / pageSize);

            LoadPager(page, totalPage);
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
                                           }
                                           );


            rpPaging.DataBind();
        }
        protected void rpPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Page")
            {
                int page = int.Parse(e.CommandArgument.ToString());
                LoadKhachHang(page);
            }
        }
        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
                LoadKhachHang(CurrentPage - 1);
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
                LoadKhachHang(CurrentPage + 1);
        }
        protected void rpKhachHang_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int maKH = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "viewKH")
            {
                // xem chi tiết
            }

            if (e.CommandName == "lockKH")
            {
                // khóa tài khoản
            }
        }
        void FilterKhachHang(int page)
        {
            KhachHangDAO dao = new KhachHangDAO();
            int totalRow;

            string search = txtSearch.Text.Trim();
            string trangThai = ddlTrangThai.SelectedValue;
            string ngay = txtNgay.Text;

            var list = dao.FilterKhachHangPaging(page, pageSize, search, trangThai, ngay, out totalRow);

            rpKhachHang.DataSource = list;
            rpKhachHang.DataBind();

            int totalPage = (int)Math.Ceiling((double)totalRow / pageSize);

            LoadPager(page, totalPage);
        }
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            string search = txtSearch.Text.Trim();
            string trangThai = ddlTrangThai.SelectedValue;
            string ngay = txtNgay.Text;

            if (string.IsNullOrEmpty(search) && string.IsNullOrEmpty(trangThai) && string.IsNullOrEmpty(ngay))
            {
                LoadKhachHang(1);
                return;
            }

            FilterKhachHang(1);
        }
        protected void btnReset_Click(object sender, EventArgs e)
        {
            // clear filter
            txtSearch.Text = "";
            ddlTrangThai.SelectedIndex = 0;
            txtNgay.Text = "";

            // load lại danh sách
            LoadKhachHang(1);
        }

        protected void chkTrangThai_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            RepeaterItem item = (RepeaterItem)chk.NamingContainer;

            HiddenField hdMaKH = (HiddenField)item.FindControl("hdMaKH");

            int maKH = Convert.ToInt32(hdMaKH.Value);

            bool trangThai = chk.Checked;

            TaiKhoanDAO dao = new TaiKhoanDAO();
            dao.UpdateTrangThai(maKH, trangThai);
            LoadKhachHang(CurrentPage);
        }
    }
}
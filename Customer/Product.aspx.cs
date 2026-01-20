using System;
using System.Collections.Generic;
using System.Linq;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class Product : System.Web.UI.Page
    {
        SanPham sp = new SanPham();
        List<SanPham> dsSP = new List<SanPham>();
        protected void Page_Load(object sender, EventArgs e)
        {
            int mansx = 0;
            int.TryParse(Request.Params["mansx"], out mansx);

            if (!IsPostBack)
            {
                PageSize = Session["PageSize"] != null ? (int)Session["PageSize"] : 4;
                ddlSort.SelectedValue = Session["SortValue"] != null ? Session["SortValue"].ToString() : "asc";
                ddlGia.SelectedValue = Session["GiaValue"] != null ? Session["GiaValue"].ToString() : "0";

                string sessionKey = $"dsSP_{mansx}";
                if (Session[sessionKey] == null)
                {
                    PageSize = 4;
                }

                LoadData(mansx);
        }
        }
        private void LoadData(int mansx)
        {
            string sessionKey = $"dsSP_{mansx}";

            if (Session[sessionKey] != null)
            {
                dsSP = (List<SanPham>)Session[sessionKey];
            }
            else
            {
                dsSP = mansx > 0 ? sp.GetSpByMaNSX(mansx) : sp.GetSanPhamNoiBat();
                Session[sessionKey] = dsSP;
            }

            switch (ddlGia.SelectedValue)
            {
                case "1": dsSP = dsSP.Where(x => x.DonGia < 5_000_000).ToList(); break;
                case "2": dsSP = dsSP.Where(x => x.DonGia >= 5_000_000 && x.DonGia <= 10_000_000).ToList(); break;
                case "3": dsSP = dsSP.Where(x => x.DonGia > 10_000_000 && x.DonGia <= 20_000_000).ToList(); break;
                case "4": dsSP = dsSP.Where(x => x.DonGia > 20_000_000).ToList(); break;
            }

            dsSP = ddlSort.SelectedValue == "asc"
                ? dsSP.OrderBy(x => x.DonGia).ToList()
                : dsSP.OrderByDescending(x => x.DonGia).ToList();

            var dsHienThi = dsSP.Take(PageSize).ToList();
            rptDanhMuc.DataSource = dsHienThi;
            rptDanhMuc.DataBind();
            btnHienThiThem.Visible = dsSP.Count > PageSize;

            Session["PageSize"] = PageSize;
            Session["SortValue"] = ddlSort.SelectedValue;
            Session["GiaValue"] = ddlGia.SelectedValue;
        }
        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            int mansx = 0;
            int.TryParse(Request.Params["mansx"], out mansx);
            LoadData(mansx);
            PageSize = 4;
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            int mansx = 0;
            int.TryParse(Request.Params["mansx"], out mansx);
            PageSize = 4;
            LoadData(mansx);

        }
        private int PageSize
        {
            get { return ViewState["PageSize"] == null ? 4 : (int)ViewState["PageSize"]; }
            set { ViewState["PageSize"] = value; }
        }

        protected void btnHienThiThem_Click(object sender, EventArgs e)
        {
            int mansx = 0;
            int.TryParse(Request.Params["mansx"], out mansx);
            PageSize += 4;
            LoadData(mansx);
        }
    }
}
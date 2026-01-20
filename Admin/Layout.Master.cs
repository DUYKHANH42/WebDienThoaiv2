using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;

namespace WebDienThoai
{
    public partial class Layout : System.Web.UI.MasterPage
    {
        TaiKhoanDAO tkDAO = new DAO.TaiKhoanDAO();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["TaiKhoan"] == null)
            {
                Response.Redirect("../login.aspx");
                return;
            }
            if (Session["Role"] == null || (int)Session["Role"] != 1)
            {
                Response.Redirect("~/customer/index.aspx");
                return;
            }
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;
using WebDienThoai.Models;

namespace WebDienThoai
{
    public partial class login : System.Web.UI.Page
    {
            TaiKhoanDAO tkDAO = new DAO.TaiKhoanDAO();
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void btnDangNhap_Click(object sender, EventArgs e)
        {
            string username = txtTenDN.Text;
            string password = txtPassword.Text;
            var tkdn = tkDAO.DangNhap(username, password);

            if (tkdn == null)
            {
                cvLogin.IsValid = false;
                return;
            }
            Session["TaiKhoan"] = tkdn;
            Session["Role"] = tkdn.maVT;

            if (tkdn.maVT == 1)
            {
                Response.Redirect("~/admin/index.aspx");
            }
            else
            {
                Response.Redirect("~/customer/index.aspx");
            }
        }
    }
}
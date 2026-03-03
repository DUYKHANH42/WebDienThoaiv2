using System;
using System.Collections.Generic;
using System.Security.Principal;
using WebDienThoai.Helper;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class Layout : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TaiKhoan tk = Session["TaiKhoan"] as TaiKhoan;
            if (!IsPostBack)
            {
                rptMenu.DataSource = MenuCache.GetMenu();
                rptMenu.DataBind();
                if (tk != null)
                {
                    btnLogin.Visible = false;
                    btnLogout.Visible = true;
                    spAccount.InnerText = tk.username;
                }
                else
                {
                    btnLogin.Visible = true;
                    btnLogout.Visible = false;
                    spAccount.Visible = false;

                }
                
            }
        }
        public int CartCount
        {
            get
            {
                int total = 0;
                if (Session["Cart"] != null)
                {
                    List<CartItem> cart = (List<CartItem>)Session["Cart"];
                    foreach (CartItem c in cart)
                    {
                        total += c.SoLuong;
                    }
                }
                return total;
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session["TaiKhoan"] = null;
            Session["MaKH"] = null;
            Response.Redirect("default.aspx");
        }
    }
}
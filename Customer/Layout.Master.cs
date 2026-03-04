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
                try
                {
                    rptMenu.DataSource = MenuCache.GetMenu();
                    rptMenu.DataBind();
                }
                catch
                {
                    
                }
                if (tk != null)
                {
                    liLogin.Visible = false;
                    liUser.Visible = true;
                    spAccount.InnerText = tk.username;
                    
                }
                else
                {
                    liLogin.Visible = true;
                    liUser.Visible = false;
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
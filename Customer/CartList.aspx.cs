using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using WebDienThoai.Helper;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class CartList : System.Web.UI.Page
    {
        List<CartItem> cart
        {
            get
            {
                return Session["Cart"] as List<CartItem>;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            TaiKhoan tk = Session["TaiKhoan"] as TaiKhoan;
            if (!IsPostBack) {
                rptMenu.DataSource = MenuCache.GetMenu();
                rptMenu.DataBind();
                DocSession();
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
            Response.Redirect("index.aspx");
        }
        private void DocSession()
        {
            rpCart.DataSource = cart;
            decimal total = 0;
            if (cart != null)
                foreach (CartItem c in cart)
                    total += c.SanPham.DonGia * c.SoLuong;
            lblTongTien.Text = total.ToString("N0") + " đ";
            rpCart.DataBind();
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class Detail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void btnAddToCart_Click(object sender, EventArgs e)
        {

            LinkButton btn = (LinkButton)sender;
            int maSP = Convert.ToInt32(btn.CommandArgument);
            int maMau = 0;
            string tenMau = "";
            string hex = "";
            MauSac mau = null;
            string maMauStr = Request.QueryString["mamau"];
            if (!string.IsNullOrEmpty(maMauStr))
            {
                int.TryParse(maMauStr, out maMau);
                mau = new MauSac().GetByMaMau(maMau);
            if (mau != null)
                {
                    tenMau = mau.TenMau;
                    hex = mau.MaMauHex;
                }
            }

            SanPham spInstance = new SanPham();
            SanPham sp = spInstance.GetSPByID(maSP);


            if (sp != null)
            {
                List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();

                CartItem item = cart.FirstOrDefault(c =>
                                c.SanPham.MaSP == maSP &&
                                ((c.MauSac == null && maMau == 0) || (c.MauSac != null && c.MauSac.MaMau == maMau)));
                if (item != null)
                {
                    item.SoLuong++;
                }
                else
                {
                    cart.Add(new CartItem
                    {
                        SanPham = sp,
                        SoLuong = 1,
                        MauSac = mau
                    });
                }

                Session["Cart"] = cart;

                ScriptManager.RegisterStartupScript(this, GetType(), "success",
                    "Swal.fire({icon:'success', title:'Thành công', text:'Đã thêm sản phẩm vào giỏ hàng.'});", true);

            }


        }
    }
}
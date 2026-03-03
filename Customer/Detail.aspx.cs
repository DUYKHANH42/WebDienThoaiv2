using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class Detail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static int AddToCart(int maSP, int maMau)
        {
            var session = HttpContext.Current.Session;

            MauSac mau = null;
            if (maMau != 0)
                mau = new MauSac().GetByMaMau(maMau);

            SanPham sp = new SanPham().GetSPByID(maSP);
            if (sp == null) return 0;

            List<CartItem> cart = session["Cart"] as List<CartItem> ?? new List<CartItem>();

            CartItem item = cart.FirstOrDefault(c =>
                c.MaSP == maSP &&
                ((c.MauSac == null && maMau == 0) ||
                 (c.MauSac != null && c.MauSac.MaMau == maMau)));

            if (item != null)
            {
                item.SoLuong++;
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
                    SoLuong = 1
                });
            }

            session["Cart"] = cart;
            return cart.Sum(x => x.SoLuong);
        }


    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using WebDienThoai.DAO;
using WebDienThoai.Helper;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class CartList : System.Web.UI.Page
    {

        DonDatHang dh = new DonDatHang();
        DonHangDAO dhDAO = new DonHangDAO();
        CTDatHangDAO ctdh = new CTDatHangDAO();
        LichSuDonHang ls = new LichSuDonHang();
        LSDonHangDAO lsDAO = new LSDonHangDAO();
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
            if (!IsPostBack)
            {
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
            total += c.DonGia * c.SoLuong;

    lblTongTien.Text = total.ToString("N0") + " đ";

    rpCart.DataBind();
        }

        protected void btnDatHang_Click(object sender, EventArgs e)
        {
            try {
              var tk = Session["TaiKhoan"] as TaiKhoan;
                if (tk == null)
                {
                    Response.Redirect("../login.aspx");
                    return;
                }
                if (cart == null || cart.Count == 0)
                {
                    return;
                }
               int maKH = tk.MaKH.Value;
                dh.MaKH = maKH;
                dh.NgayDat = DateTime.Now;
                decimal tongTien = 0;
                foreach (CartItem c in cart)
                {
                    tongTien += c.SoLuong * c.SanPham.DonGia;
                }
                dh.TriGia = tongTien;
                dh.DaGiao = false;
                dh.MaTrangThai = 1;
                dhDAO.ThemMoi(dh);
                int soDH = dh.SoDH;
                foreach (var group in cart.GroupBy(x => x.SanPham.MaSP))
                {
                    CTDatHang ct = new CTDatHang();
                    ct.ThanhTien = group.Sum(x => x.SoLuong * x.SanPham.DonGia);
                    ct.SoDH = soDH;
                    ct.MaSP = group.Key;
                    ct.SoLuong = group.Sum(x => x.SoLuong);
                    ct.DonGia = group.First().SanPham.DonGia;
                    ctdh.ThemMoi(ct);
                }
                ls.SoDH = soDH;
                ls.MaTrangThai = dh.MaTrangThai;
                ls.NgayCapNhat = dh.NgayDat;
                ls.GhiChu = $"Đơn hàng được tạo ngày {ls.NgayCapNhat}." ;
                lsDAO.ThemMoi(ls);
                Session["Cart"] = null;
                Response.Redirect("OrderSuccess.aspx");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error placing order: " + ex.Message);
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object UpdateCart(int masp, int soluong, string action)
        {
            var cart = HttpContext.Current.Session["Cart"] as List<CartItem>;
            if (cart == null) return new { ok = false };

            var item = cart.FirstOrDefault(x => x.SanPham.MaSP == masp);
            if (item == null) return new { ok = false };

            if (action == "increase") item.SoLuong++;
            if (action == "decrease") item.SoLuong--;
            if (action == "set")
            {
                if (soluong <= 0)
                {
                    cart.Remove(item);
                }
                else
                {
                    item.SoLuong = soluong;
                }
            }
            else if (action == "remove")
            {
                cart.Remove(item);
            }


            if (item != null && item.SoLuong <= 0)
                cart.Remove(item);

            decimal total = cart.Sum(x => x.SoLuong * x.SanPham.DonGia);

            HttpContext.Current.Session["Cart"] = cart;

            return new
            {
                ok = true,
                total = total.ToString("N0") + " đ"
            };
        }
    }
}
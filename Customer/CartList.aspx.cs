using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
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
        DiaChiKHDAO DiaChiKHDAO = new DiaChiKHDAO();
        SanPhamDAO spdao = new SanPhamDAO();
        ThongBaoDAO tbdao = new ThongBaoDAO();
        List<CartItem> cart
        {
            get
            {
                return Session["Cart"] as List<CartItem>;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    rptMenu.DataSource = MenuCache.GetMenu();
                    rptMenu.DataBind();
                    DocSession();
                    CheckLoginStatus();
                }
                catch
                {

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
        private void CheckLoginStatus()
        {
            var tk = Session["TaiKhoan"] as TaiKhoan;
            if (tk != null)
            {
                phNotLoggedIn.Visible = false;
                phLoggedIn.Visible = true;
                LoadUserAddresses();
                liLogin.Visible = false;
                liUser.Visible = true;
                spAccount.InnerText = tk.username;
                btnDatHang.Visible = true;

            }
            else
            {
                phNotLoggedIn.Visible = true;
                phLoggedIn.Visible = false;
                liLogin.Visible = true;
                liUser.Visible = false;
                btnDatHang.Visible = false;
            }
        }
        private void LoadUserAddresses()
        {
            int makh = (int)Session["MaKH"];
            rblAddress.Items.Clear();
            var list = DiaChiKHDAO.FindByID(makh);
            foreach (var item in list)
            {
                string text;

                if (item.MacDinh)
                {
                    text = string.Format(
                        "<strong>{0}</strong> - {1} " +
                        "<span class='badge bg-primary ms-2'>Mặc định</span>" +
                        "<br/><span class='small text-muted'>{2}</span>",
                        item.TenNguoiNhan,
                        item.DienThoai,
                        item.DiaChi
                    );
                }
                else
                {
                    text = string.Format(
                        "<strong>{0}</strong> - {1}" +
                        "<br/><span class='small text-muted'>{2}</span>",
                        item.TenNguoiNhan,
                        item.DienThoai,
                        item.DiaChi
                    );
                }

                ListItem li = new ListItem(text, item.MaDC.ToString());

                if (item.MacDinh)
                    li.Selected = true;

                rblAddress.Items.Add(li);
            }
        }
        protected void btnEditAddress_Click(object sender, EventArgs e)
        {
            if (rblAddress.SelectedItem != null)
            {
                int maDC = int.Parse(rblAddress.SelectedValue);

                // Giả sử bạn có hàm lấy thông tin 1 địa chỉ theo MaDC
                var dc = DiaChiKHDAO.FindByIDDC(maDC);

                if (dc != null)
                {
                    // Đổ dữ liệu vào Modal Sửa
                    hfEditMaDC.Value = dc.MaDC.ToString();
                    txtEditHoTen.Text = dc.TenNguoiNhan;
                    txtEditSoDienThoai.Text = dc.DienThoai;
                    txtEditDiaChi.Text = dc.DiaChi;
                    chkEditDefault.Checked = dc.MacDinh;

                    // Gọi Script để mở Modal Sửa
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenEditModal",
                        "var myModal = new bootstrap.Modal(document.getElementById('modalEditAddress')); myModal.show();", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert",
                    "Swal.fire('Thông báo', 'Vui lòng chọn một địa chỉ để chỉnh sửa!', 'warning');", true);
            }
        }
        protected void btnDeleteAddress_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfEditMaDC.Value))
                return;

            int maDC = Convert.ToInt32(hfEditMaDC.Value);
            int maKH = (int)Session["MaKH"];

            DiaChiKHDAO dao = new DiaChiKHDAO();
            bool result = dao.Xoa(maDC, maKH);

            if (result)
            {
                LoadUserAddresses();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal",
                    "setTimeout(function(){" +
                    "var modalEl = document.getElementById('modalEditAddress');" +
                    "if(modalEl){" +
                    "var modal = bootstrap.Modal.getOrCreateInstance(modalEl);" +
                    "modal.hide();" +
                    "}" +
                    "document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());" +
                    "document.body.classList.remove('modal-open');" +
                    "document.body.style='';" +
                    "},200);",
                    true);
            }
        }
        protected void btnUpdateAddress_Click(object sender, EventArgs e)
        {
            // 1. Lấy dữ liệu từ các TextBox của Modal Sửa
            int maDC = Convert.ToInt32(hfEditMaDC.Value);

            // 2. Lấy dữ liệu từ TextBox
            string hoTen = txtEditHoTen.Text.Trim();
            string dienThoai = txtEditSoDienThoai.Text.Trim();
            string diaChi = txtEditDiaChi.Text.Trim();
            bool macDinh = chkEditDefault.Checked;
            int makh = (int)Session["MaKH"];
            DiaChiKH dckh = new DiaChiKH();
            dckh.MaDC = maDC;
            dckh.MaKH = makh;
            dckh.TenNguoiNhan = hoTen;
            dckh.DienThoai = dienThoai;
            dckh.DiaChi = diaChi;
            dckh.MacDinh = macDinh;
            bool result = DiaChiKHDAO.CapNhat(dckh);

            if (result)
            {
                LoadUserAddresses();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal",
     "setTimeout(function(){" +
     "var modalEl = document.getElementById('modalAddAddress');" +
     "if(modalEl){" +
     "var modal = bootstrap.Modal.getOrCreateInstance(modalEl);" +
     "modal.hide();" +
     "}" +
     "}, 200);",
     true);
            }
        }
        protected void btnSaveAddress_Click(object sender, EventArgs e)
        {
            string hoTen = txtNewHoTen.Text.Trim();
            string dienThoai = txtNewSoDienThoai.Text.Trim();
            string diaChi = txtNewDiaChi.Text.Trim();
            bool macDinh = chkDefault.Checked;

            int makh = (int)Session["MaKH"];
            DiaChiKH dckh = new DiaChiKH
            {
                MaKH = makh,
                TenNguoiNhan = hoTen,
                DienThoai = dienThoai,
                DiaChi = diaChi,
                MacDinh = macDinh
            };
            if (macDinh)
            {
                DiaChiKHDAO.ResetMacDinh(makh);
            }

            int newMaDC = DiaChiKHDAO.ThemMoi(dckh);

            if (newMaDC > 0)
            {
                txtNewHoTen.Text = "";
                txtNewSoDienThoai.Text = "";
                txtNewDiaChi.Text = "";
                chkDefault.Checked = false;

                LoadUserAddresses();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal",
     "setTimeout(function(){" +
     "var modalEl = document.getElementById('modalAddAddress');" +
     "if(modalEl){" +
     "var modal = bootstrap.Modal.getOrCreateInstance(modalEl);" +
     "modal.hide();" +
     "}" +
     "}, 200);",
     true);
            }

        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session["TaiKhoan"] = null;
            Session["MaKH"] = null;
            Response.Redirect("default.aspx");
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
            try
            {
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

                decimal tongTien = 0;
                foreach (CartItem c in cart)
                {
                    tongTien += c.SoLuong * c.SanPham.DonGia;
                }
                dh.MaDH = "DHS" + Guid.NewGuid().ToString("N").Substring(0, 7).ToUpper();
                dh.MaKH = maKH;
                int maDC = int.Parse(rblAddress.SelectedValue);
                DiaChiKH dc = DiaChiKHDAO.FindByIDDC(maDC);
                dh.NgayDat = DateTime.Now;
                dh.TriGia = tongTien;
                // snapshot địa chỉ
                dh.TenNguoiNhan = dc.TenNguoiNhan;
                dh.DienThoaiNhan = dc.DienThoai;
                dh.DiaChiNhan = dc.DiaChi;

                dh.PhuongThucThanhToan = "COD";
                dh.TrangThaiThanhToan = "Chưa thanh toán";

                dh.MaTrangThai = 1;

                dhDAO.ThemMoi(dh);

                int soDH = dh.SoDH;
                foreach (var group in cart.GroupBy(x => new
                {
                    x.SanPham.MaSP,
                    x.MauSac.MaMau
                }))
                {
                    CTDatHang ct = new CTDatHang();

                    ct.SoDH = soDH;
                    ct.MaSP = group.Key.MaSP;
                    ct.MaMau = group.Key.MaMau;

                    ct.SoLuong = group.Sum(x => x.SoLuong);
                    ct.DonGia = group.First().SanPham.DonGia;
                    ct.ThanhTien = ct.SoLuong * ct.DonGia;
                    ctdh.ThemMoi(ct);
                    int tonKhoConLai = spdao.UpdateTonKho(ct.MaSP, ct.SoLuong);

                    if (tonKhoConLai < 5)
                    {
                      SanPham sp = spdao.GetSPByID(ct.MaSP);
                        ThongBao tb = new ThongBao();
                        tb.MaNguoiNhan = 1;
                        tb.TieuDe = "Thông báo tồn kho";
                        tb.NoiDung = "Sản phẩm " +sp.TenSP + ", có mã " + sp.MaSP + " sắp hết hàng. Tồn kho còn: " + tonKhoConLai;
                        tb.LoaiThongBao = "TonKho";
                        tb.DaDoc = false;
                        tb.NgayTao = DateTime.Now;
                        tbdao.ThemThongBao(tb);
                    }
                }
                ls.SoDH = soDH;
                ls.MaTrangThai = dh.MaTrangThai;
                ls.NgayCapNhat = dh.NgayDat;
                ls.GhiChu = $"Đơn hàng được tạo ngày {ls.NgayCapNhat}.";
                lsDAO.ThemMoi(ls);
                ThongBao tbAdmin = new ThongBao();
                tbAdmin.TieuDe = "Đơn hàng mới";
                tbAdmin.NoiDung = "Có đơn hàng mới #" + dh.MaDH + " từ khách hàng " + tk.username;
                tbAdmin.MaNguoiNhan = 1;
                tbAdmin.LoaiThongBao = "DonHang";
                tbAdmin.DaDoc = false;
                tbAdmin.NgayTao = DateTime.Now;

                tbdao.ThemThongBao(tbAdmin);


                ThongBao tbUser = new ThongBao();
                tbUser.TieuDe = "Đặt hàng thành công";
                tbUser.NoiDung = "Bạn đã đặt hàng thành công. Mã đơn: " + dh.MaDH;
                tbUser.MaNguoiNhan = tk.Id;
                tbUser.LoaiThongBao = "DonHang";
                tbUser.DaDoc = false;
                tbUser.NgayTao = DateTime.Now;

                tbdao.ThemThongBao(tbUser);
                Session["Cart"] = null;
                Response.Redirect("OrderSuccess.aspx?sodh=" + soDH);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error placing order: " + ex.Message);
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object UpdateCart(int masp, int mamau, int soluong, string action)
        {

            var cart = HttpContext.Current.Session["Cart"] as List<CartItem>;

            if (cart == null) return new { ok = false };

            var item = cart.FirstOrDefault(x => x.SanPham.MaSP == masp && x.MauSac.MaMau == mamau);
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
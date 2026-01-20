using System;
using System.Web.UI;
using WebDienThoai.DAO;
using WebDienThoai.Helper;
using WebDienThoai.Models;

namespace WebDienThoai
{
    public partial class register : System.Web.UI.Page
    {
        KhachHang kh = new KhachHang();
        KhachHangDAO khDAO = new KhachHangDAO();
        TaiKhoan tk = new TaiKhoan();
        TaiKhoanDAO tkDAO = new TaiKhoanDAO();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnDangKy_Click(object sender, EventArgs e)
        {
            try
            {
                kh.TenKH = txtHoten.Text;
                kh.Email = txtEmail.Text;
                kh.DiaChi = txtDiaChi.Text;
                kh.SoDienThoai = txtSDT.Text;
                if (tkDAO.TonTaiUsernameHoacEmail(txtTenDN.Text, txtEmail.Text))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "exist",
                        "Swal.fire({ icon:'warning', title:'Thông báo', text:'Tên đăng nhập hoặc Email đã tồn tại!' })",
                        true);
                    return;
                }
                int makh = khDAO.ThemMoi(kh);
                if (makh != 0)
                {
                    tk.username = txtTenDN.Text;
                    tk.password = BCrypt.Net.BCrypt.HashPassword(txtPassword.Text);
                    tk.maVT = 3;
                    tk.MaKH = makh;
                    bool i = tkDAO.DangKy(tk);
                    if (i)
                    {
                        // đổi domain khi deploy
                        string loginUrl = "https://localhost:44332/login.aspx"; 

                        string body = $@"
<!DOCTYPE html>
<html lang='vi'>
<head>
<meta charset='UTF-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0'>
<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css' rel='stylesheet'>
</head>

<body style='background-color:#f4f6f9;padding:30px 0;'>

<div class='container'>
  <div class='row justify-content-center'>
    <div class='col-md-8 col-lg-6'>

      <div class='card shadow-sm border-0 rounded-4'>
        
        <!-- Header -->
        <div class='card-header text-center text-white rounded-top-4'
             style='background:linear-gradient(135deg,#0d6efd,#0a58ca);padding:25px'>
          <h3 class='mb-0 fw-bold'>WEB ĐIỆN THOẠI</h3>
          <small>Nền tảng mua sắm điện thoại uy tín</small>
        </div>

        <!-- Body -->
        <div class='card-body p-4' style='color:#333'>
          <p class='fs-5'>Xin chào <strong>{kh.TenKH}</strong>,</p>

          <p>
            Chúng tôi xin chúc mừng bạn đã <strong>đăng ký tài khoản thành công</strong> 
            tại hệ thống <b>Web Điện Thoại</b>.
          </p>

          <div class='bg-light rounded-3 p-3 my-3'>
            <p class='mb-1'><strong>Tên đăng nhập:</strong> {tk.username}</p>
            <p class='mb-0'><strong>Email:</strong> {kh.Email}</p>
          </div>

          <p>
            Bạn có thể đăng nhập ngay để trải nghiệm các sản phẩm và dịch vụ của chúng tôi.
          </p>

          <!-- Button -->
          <div class='text-center my-4'>
            <a href='{loginUrl}'
               class='btn btn-primary btn-lg px-4'
               style='border-radius:30px'>
               Đăng nhập ngay
            </a>
          </div>

          <p class='text-muted small'>
            Nếu bạn không thực hiện đăng ký này, vui lòng bỏ qua email.
          </p>
        </div>

        <!-- Footer -->
        <div class='card-footer text-center text-muted small bg-white border-0 pb-3'>
          <hr>
          <p class='mb-1'>© {DateTime.Now.Year} Web Điện Thoại</p>
          <p class='mb-0'>Hotline: 1900 9999 · Email: support@webdienthoai.vn</p>
        </div>

      </div>

    </div>
  </div>
</div>

</body>
</html>";

                        EmailHelper.Send(
                            kh.Email,
                            "Đăng ký tài khoản thành công",
                            body
                        );

                        ScriptManager.RegisterStartupScript(this, GetType(), "success",
                            "Swal.fire({ icon: 'success', title: 'Thành công', text: 'Đăng ký thành công! Kiểm tra email của bạn.' })" +
                            ".then(() => { window.location = 'login.aspx'; });",
                            true);
                    }
                }
            }
            catch (Exception)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error",
                                                  "Swal.fire({ " +
                                                  "icon: 'error', " +
                                                  "title: 'Lỗi', " +
                                                  "text: 'Đăng ký thất bại!', " +
                                                  "confirmButtonText: 'Đóng', " +
                                                  "showCloseButton: true " +
                                                  "});",
                                                  true);

            }

        }
    }
}
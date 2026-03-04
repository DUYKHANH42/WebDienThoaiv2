using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["id"] == null) return;

                int userId = Convert.ToInt32(Session["id"]);
                TextBox txtTenKH = (TextBox)fvProfile.FindControl("txtEditTenKH");
                TextBox txtEmail = (TextBox)fvProfile.FindControl("txtEditEmail");
                TextBox txtDienThoai = (TextBox)fvProfile.FindControl("txtEditDienThoai");
                TextBox txtNgaySinh = (TextBox)fvProfile.FindControl("txtEditNgaySinh");
                RadioButton rbMale = (RadioButton)fvProfile.FindControl("rbMale");
                FileUpload fuAvatar = Sidebar1.AvatarUpload;
                TaiKhoanDAO tkDao = new TaiKhoanDAO();
                int maKH = (int)Session["MaKH"];

                KhachHang kh = new KhachHang();
                kh.MaKH = maKH;
                kh.TenKH = txtTenKH.Text.Trim();
                kh.Email = txtEmail.Text.Trim();
                kh.SoDienThoai = txtDienThoai.Text.Trim();
                kh.GioiTinh = rbMale.Checked;
                kh.NgaySinh = string.IsNullOrEmpty(txtNgaySinh.Text)
                                ? (DateTime?)null
                                : DateTime.Parse(txtNgaySinh.Text);

                string oldAvatar = Session["avt"]?.ToString();
                string avtUrl = null;

                if (fuAvatar != null && fuAvatar.HasFile)
                {
                    string folderPath = Server.MapPath("~/imgs/");
                    if (!Directory.Exists(folderPath))
                        Directory.CreateDirectory(folderPath);

                    string extension = Path.GetExtension(fuAvatar.FileName);
                    string fileName = Guid.NewGuid().ToString() + extension;

                    fuAvatar.SaveAs(Path.Combine(folderPath, fileName));

                    avtUrl = fileName;

                    Session["avt"] = fileName;
                }

                KhachHangDAO dao = new KhachHangDAO();
                bool result = dao.CapNhatThongTin(kh, avtUrl);
                if (result && IsPostBack)
                {
                   if (!string.IsNullOrEmpty(avtUrl))
                    {
                        string folderPath = Server.MapPath("~/imgs/");
                        string oldFilePath = Path.Combine(folderPath, oldAvatar ?? "");

                        if (!string.IsNullOrEmpty(oldAvatar)
                            && File.Exists(oldFilePath)
                            && oldAvatar != "default-avatar.png")
                        {
                            File.Delete(oldFilePath);
                        }

                        Session["avt"] = avtUrl;
                    }

                    ScriptManager.RegisterStartupScript(this, GetType(),
                        "success",
                        @"Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'success',
            title: 'Cập nhật thành công!',
            showConfirmButton: false,
            timer: 1000,
            timerProgressBar: true
        }).then(() => {
            window.location.href = window.location.pathname;
        });",
                        true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(),
      "fail",
      @"Swal.fire({
        toast: true,
        position: 'top-end',
        icon: 'error',
        title: 'Cập nhật thất bại!',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });",
      true);
                }
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this, GetType(),
                    "error", "alert('Đã xảy ra lỗi khi cập nhật!');", true);
            }
        }
    }
}
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.Admin.Model;
using WebDienThoai.Admin.Services;
using WebDienThoai.DAO;
using WebDienThoai.Models;

namespace WebDienThoai.Admin
{
    public partial class AddProduct : System.Web.UI.Page
    {
        SanPhamDAO dao = new SanPhamDAO();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnThemMoi_Click(object sender, EventArgs e)
        {
            try
            {
                ProductService service = new ProductService();

                List<CauHinhSP> listCH = new List<CauHinhSP>();

                string[] rams = Request.Form.GetValues("ram") ?? new string[0];
                string[] roms = Request.Form.GetValues("rom") ?? new string[0];
                string[] gias = Request.Form.GetValues("gia") ?? new string[0];
                string cpu = txtCPU.Text;
                string manhinh = txtManHinh.Text;
                string pin = txtPin.Text;
                string hedh = txtHDH.Text;
                SanPham sanPham = new SanPham
                {
                    TenSP = txtTenSP.Text,
                    MaLoai = int.Parse(ddlLoai.SelectedValue),
                    MaNSX = int.Parse(ddlNSX.SelectedValue),
                    DungLuong = txtDungLuong.Text,
                    ThiTruong = ddlMaMay.SelectedValue,
                    NgayCapNhat = txtNgayPhatHanh.Text != "" ? DateTime.Parse(txtNgayPhatHanh.Text) : DateTime.Now,

                };


                for (int i = 0; i < rams.Length; i++)
                {
                    decimal gia = 0;
                    decimal.TryParse(gias[i], out gia);

                    listCH.Add(new CauHinhSP
                    {
                        RAM = rams[i],
                        BoNho = roms[i],
                        DonGia = gia,
                        CPU = cpu,
                        ManHinh = manhinh,
                        Pin = pin,
                        HeDieuHanh = hedh
                    });
                }
                List<int> maus = new List<int>();
                var colorVals = Request.Form.GetValues("colors");
                if (colorVals != null)
                    maus = colorVals.Select(x => int.Parse(x)).ToList();
                List<HttpPostedFile> avatarFiles = new List<HttpPostedFile>();
                List<HttpPostedFile> albumFiles = new List<HttpPostedFile>();

                // ảnh đại diện
                if (multiImg.HasFiles)
                {
                    foreach (HttpPostedFile file in multiImg.PostedFiles)
                        avatarFiles.Add(file);
                }

                // album
                if (fuAlbum.HasFiles)
                {
                    foreach (HttpPostedFile file in fuAlbum.PostedFiles)
                        albumFiles.Add(file);
                }



                service.AddProduct(
                    sanPham,
                    listCH,
                    maus,
                    avatarFiles,
                    albumFiles,
                    Server
                );

                Response.Write("<script>alert('Thêm thành công');</script>");
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Thêm thất bại');</script>");
            }
        }


    }
}
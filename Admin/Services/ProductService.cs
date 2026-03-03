using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using WebDienThoai.Admin.Model;
using WebDienThoai.DAO;
using WebDienThoai.Models;

namespace WebDienThoai.Admin.Services
{
    public class ProductService
    {
        SanPhamDAO dao = new SanPhamDAO();

        string connStr = ConfigurationManager
                  .ConnectionStrings["DienThoaiDBConnectionString"]
                  .ConnectionString;
        public void AddProduct(SanPham sp,
                        List<CauHinhSP> cauHinhs,
                        List<int> maus,
                        List<HttpPostedFile> avatarFiles,
                        List<HttpPostedFile> albumFiles,
                        HttpServerUtility server)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction tran = conn.BeginTransaction();

                try
                {
                    SanPham sps = new SanPham
                    {
                        TenSP = sp.TenSP,
                        MaLoai = sp.MaLoai,
                        MaNSX = sp.MaNSX,
                        MoTa = sp.MoTa,
                        NgayCapNhat = DateTime.Now,
                        DungLuong = sp.DungLuong,
                        ThiTruong = sp.ThiTruong
                    };

                    int maSP = dao.InsertSanPham(conn, tran, sp);
                    foreach (var dto in cauHinhs)
                    {
                        CauHinhSP ch = new CauHinhSP
                        {
                            MaSP = maSP,
                            RAM = dto.RAM,
                            BoNho = dto.BoNho,
                            DonGia = dto.DonGia,
                            CPU = dto.CPU,
                            ManHinh = dto.ManHinh,
                            Pin = dto.Pin,
                            HeDieuHanh = dto.HeDieuHanh

                        };

                        dao.InsertCauHinh(conn, tran, ch);
                    }
                    dao.UpdateGiaSanPham(conn, tran, maSP);
                    foreach (var m in maus)
                        dao.InsertMau(conn, tran, maSP, m.ToString());

                    string firstImg = null;

                    foreach (var file in avatarFiles)
                    {
                        string ext = Path.GetExtension(file.FileName);
                        string name = Guid.NewGuid().ToString("N") + ext;
                        string path = server.MapPath("~/imgs/" + name);
                        file.SaveAs(path);
                        firstImg = name;
                        HinhAnhSP avatar = new HinhAnhSP
                        {
                            MaSP = maSP,
                            TenHinh = name
                        };
                        dao.InsertHinhAnh(conn, tran, avatar);
                        firstImg = name;
                        break;
                    }
                    foreach (HttpPostedFile file in albumFiles)
                    {
                        if (file == null || file.ContentLength == 0)
                            continue;

                        string ext = Path.GetExtension(file.FileName);
                        string name = Guid.NewGuid().ToString("N") + ext;
                        string path = server.MapPath("~/imgs/" + name);
                        file.SaveAs(path);

                        HinhAnhSP h = new HinhAnhSP
                        {
                            MaSP = maSP,
                            TenHinh = name
                        };

                        dao.InsertHinhAnh(conn, tran, h);

                        if (firstImg == null)
                            firstImg = name;
                    }

                    if (firstImg != null)
                        dao.UpdateAnhDaiDien(conn, tran, maSP, firstImg);

                    tran.Commit();
                }
                catch
                {
                    tran.Rollback();
                    throw;
                }
            }
        }
    }
}
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace WebDienThoai.Models
{
    
    public class SanPham
    {   
        public SanPham() { }

        public int MaSP { get; set; }
        public string TenSP { get; set; }
        public int MaLoai { get; set; }
        public int MaNSX { get; set; }
        public decimal DonGia { get; set; }
        public string AnhSP { get; set; }
        public string MoTa { get; set; }
        public DateTime NgayCapNhat { get; set; }
        public string DungLuong { get; set; }
        public string ThiTruong { get; set; }

        private string connStr = ConfigurationManager.ConnectionStrings["DienThoaiDBConnectionString"].ConnectionString;

        public List<SanPham> GetAllSanPham()
        {
            List<SanPham> ds = new List<SanPham>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM SanPham";
                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ds.Add(new SanPham
                    {
                        MaSP = Convert.ToInt32(dr["MaSP"]),
                        TenSP = dr["TenSP"].ToString(),
                        MaLoai = Convert.ToInt32(dr["MaLoai"]),
                        MaNSX = Convert.ToInt32(dr["MaNSX"]),
                        DonGia = Convert.ToDecimal(dr["DonGia"]),
                        AnhSP = dr["AnhSP"].ToString(),
                        MoTa = dr["MoTa"].ToString(),
                        NgayCapNhat = Convert.ToDateTime(dr["NgayCapNhat"]),
                        DungLuong = dr["DungLuong"].ToString(),
                        ThiTruong = dr["ThiTruong"].ToString()
                    });
                }
            }
            return ds;
        }
        public SanPham GetSPByID(int maSP)
        {
            return GetAllSanPham().FirstOrDefault(sp => sp.MaSP == maSP);
        }


        public List<SanPham> GetSpByMaLoai(int maLoai)
        {
            var ds = GetAllSanPham();
            return ds.Where(sp => sp.MaLoai == maLoai).ToList();
        }

        public List<SanPham> GetSpByMaNSX(int maNSX)
        {
            var ds = GetAllSanPham();
            return ds.Where(sp => sp.MaNSX == maNSX).ToList();
        }

        public List<SanPham> GetSPByMaLoaiAndMaNSX(int maLoai, int maNSX)
        {
            var ds = GetAllSanPham();
            return ds.Where(sp => sp.MaLoai == maLoai && sp.MaNSX == maNSX).ToList();
        }

        public List<SanPham> GetSanPhamNoiBat(int top = 4)
        {
            var ds = GetAllSanPham();
            return ds.OrderByDescending(sp => sp.NgayCapNhat).Take(top).ToList();
        }
    }
}

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
        public decimal GiaMin { get; set; }
        public decimal DonGia { get; set; }
        public string AnhSP { get; set; }
        public string MoTa { get; set; }
        public DateTime NgayCapNhat { get; set; }
        public int TonKho { get; set; }
        public string DungLuong { get; set; }
        public string ThiTruong { get; set; }
        public string TenLoai { get; set; }
        public string TenNSX { get; set; }
        public bool DaXoa { get; set; }

        private string connStr = ConfigurationManager.ConnectionStrings["DienThoaiDBConnectionString"].ConnectionString;

        public List<SanPham> GetAllSanPham()
        {
            List<SanPham> ds = new List<SanPham>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
SELECT 
    sp.MaSP,
    sp.TenSP,
    sp.AnhSP,
    sp.MaLoai,
    sp.MaNSX,
    sp.NgayCapNhat,
    l.TenLoai,
    n.TenNSX,
    MIN(sp.DonGia) AS GiaMin
FROM SanPham sp
LEFT JOIN CauHinhSP ch ON sp.MaSP = ch.MaSP
INNER JOIN LoaiSP l ON sp.MaLoai = l.MaLoai
INNER JOIN NhaSanXuat n ON sp.MaNSX = n.MaNSX
WHERE sp.DaXoa = 0
GROUP BY
    sp.MaSP,sp.DonGia, sp.TenSP, sp.AnhSP, sp.MaLoai, sp.MaNSX, sp.NgayCapNhat,
    l.TenLoai, n.TenNSX
ORDER BY sp.DonGia DESC,sp.MaSP DESC
";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    ds.Add(new SanPham
                    {
                        MaSP = (int)dr["MaSP"],
                        TenSP = dr["TenSP"].ToString(),
                        AnhSP = dr["AnhSP"].ToString(),
                        MaLoai = (int)dr["MaLoai"],
                        MaNSX = (int)dr["MaNSX"],
                        TenLoai = dr["TenLoai"].ToString(),
                        TenNSX = dr["TenNSX"].ToString(),
                        NgayCapNhat = (DateTime)dr["NgayCapNhat"],
                        GiaMin = dr["GiaMin"] == DBNull.Value ? 0 : (decimal)dr["GiaMin"]
                    });
                }
            }
            return ds;
        }

        public SanPham GetSPByID(int maSP)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
SELECT 
    sp.MaSP,
    sp.TenSP,
    sp.AnhSP,
    sp.MaLoai,
    sp.MaNSX,
    sp.NgayCapNhat,
    l.TenLoai,
    n.TenNSX,
    MIN(ch.DonGia) AS DonGia
FROM SanPham sp
LEFT JOIN CauHinhSP ch ON sp.MaSP = ch.MaSP
INNER JOIN LoaiSP l ON sp.MaLoai = l.MaLoai
INNER JOIN NhaSanXuat n ON sp.MaNSX = n.MaNSX
WHERE sp.MaSP = @MaSP AND sp.DaXoa = 0
GROUP BY 
    sp.MaSP, sp.TenSP, sp.AnhSP, sp.MaLoai, sp.MaNSX, sp.NgayCapNhat,
    l.TenLoai, n.TenNSX";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", maSP);

                conn.Open();
                var dr = cmd.ExecuteReader();

                if (!dr.Read()) return null;

                return new SanPham
                {
                    MaSP = (int)dr["MaSP"],
                    TenSP = dr["TenSP"].ToString(),
                    AnhSP = dr["AnhSP"].ToString(),
                    MaLoai = (int)dr["MaLoai"],
                    MaNSX = (int)dr["MaNSX"],
                    TenLoai = dr["TenLoai"].ToString(),
                    TenNSX = dr["TenNSX"].ToString(),
                    NgayCapNhat = (DateTime)dr["NgayCapNhat"],
                    DonGia = dr["DonGia"] == DBNull.Value ? 0 : (decimal)dr["DonGia"]
                };
            }
        }




        public List<SanPham> GetSpByMaLoai(int maLoai)
        {
            List<SanPham> ds = new List<SanPham>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
SELECT sp.MaSP,sp.Dungluong,sp.ThiTruong, sp.TenSP, sp.AnhSP, sp.MaLoai, sp.MaNSX, sp.NgayCapNhat,
       l.TenLoai, n.TenNSX,
       MIN(sp.DonGia) AS GiaMin
FROM SanPham sp
INNER JOIN LoaiSP l ON sp.MaLoai = l.MaLoai
INNER JOIN NhaSanXuat n ON sp.MaNSX = n.MaNSX
WHERE sp.MaLoai = @MaLoai AND sp.DaXoa = 0
GROUP BY sp.MaSP, sp.DonGia,sp.TenSP, sp.AnhSP, sp.MaLoai,sp.Dungluong,sp.ThiTruong, sp.MaNSX, sp.NgayCapNhat, l.TenLoai, n.TenNSX
ORDER BY sp.MaSP DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaLoai", maLoai);

                conn.Open();
                var dr = cmd.ExecuteReader();

                while (dr.Read())
                    ds.Add(MapSanPham(dr));
            }

            return ds;
        }


        public List<SanPham> GetSpByMaNSX(int maNSX)
        {
            List<SanPham> ds = new List<SanPham>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
SELECT sp.MaSP, sp.Dungluong,sp.ThiTruong,sp.TenSP, sp.AnhSP, sp.MaLoai, sp.MaNSX, sp.NgayCapNhat,
       l.TenLoai, n.TenNSX,
       DonGia AS GiaMin
FROM SanPham sp
INNER JOIN LoaiSP l ON sp.MaLoai = l.MaLoai
INNER JOIN NhaSanXuat n ON sp.MaNSX = n.MaNSX
WHERE sp.MaNSX = @MaNSX AND sp.DaXoa = 0
GROUP BY sp.MaSP, sp.TenSP, sp.AnhSP, sp.MaLoai,sp.Dungluong,sp.ThiTruong, 
sp.MaNSX, sp.NgayCapNhat, sp.DonGia,l.TenLoai, n.TenNSX
ORDER BY sp.MaSP DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaNSX", maNSX);

                conn.Open();
                var dr = cmd.ExecuteReader();

                while (dr.Read())
                    ds.Add(MapSanPham(dr));
            }

            return ds;
        }


        public List<SanPham> GetSPByMaLoaiAndMaNSX(int maLoai, int maNSX)
        {
            List<SanPham> ds = new List<SanPham>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
SELECT sp.MaSP,sp.Dungluong,sp.ThiTruong, sp.TenSP, sp.AnhSP, sp.MaLoai, sp.MaNSX, sp.NgayCapNhat,
       l.TenLoai, n.TenNSX,
       MIN(ch.DonGia) AS GiaMin
FROM SanPham sp
LEFT JOIN CauHinhSP ch ON sp.MaSP = ch.MaSP
INNER JOIN LoaiSP l ON sp.MaLoai = l.MaLoai
INNER JOIN NhaSanXuat n ON sp.MaNSX = n.MaNSX
WHERE sp.MaLoai = @MaLoai AND sp.MaNSX = @MaNSX AND sp.DaXoa = 0
GROUP BY sp.MaSP,sp.Dungluong,sp.ThiTruong, sp.TenSP, sp.AnhSP, sp.MaLoai, sp.MaNSX, sp.NgayCapNhat, l.TenLoai, n.TenNSX
ORDER BY sp.MaSP DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaLoai", maLoai);
                cmd.Parameters.AddWithValue("@MaNSX", maNSX);

                conn.Open();
                var dr = cmd.ExecuteReader();

                while (dr.Read())
                    ds.Add(MapSanPham(dr));
            }

            return ds;
        }


        public List<SanPham> GetSanPhamNoiBat(int top = 4)
        {
            var ds = GetAllSanPham();
            return ds.Where(x => !x.DaXoa).OrderByDescending(sp => sp.NgayCapNhat).Take(top).ToList();
        }
        private SanPham MapSanPham(SqlDataReader dr)
        {
            return new SanPham
            {
                MaSP = (int)dr["MaSP"],
                TenSP = dr["TenSP"].ToString(),
                AnhSP = dr["AnhSP"].ToString(),
                MaLoai = (int)dr["MaLoai"],
                MaNSX = (int)dr["MaNSX"],
                TenLoai = dr["TenLoai"].ToString(),
                TenNSX = dr["TenNSX"].ToString(),
                NgayCapNhat = (DateTime)dr["NgayCapNhat"],
                GiaMin = dr["GiaMin"] == DBNull.Value ? 0 : (decimal)dr["GiaMin"],
                DungLuong = dr["DungLuong"].ToString(),
                ThiTruong = dr["ThiTruong"].ToString()
            };
        }

    }
}

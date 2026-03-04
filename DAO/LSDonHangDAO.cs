using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebDienThoai.Models;
using WebDienThoai.ViewModels;

namespace WebDienThoai.DAO
{
    public class LSDonHangDAO
    {
        string connStr = ConfigurationManager
                 .ConnectionStrings["DienThoaiDBConnectionString"]
                 .ConnectionString;
        public int ThemMoi(LichSuDonHang ls)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO LichSuDonHang (SoDH, MaTrangThai, NgayCapNhat, GhiChu) " +
                    "OUTPUT INSERTED.MaLS " +
                    "VALUES (@soDH, @maTrangThai, @ngayCapNhat, @ghiChu)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@soDH", ls.SoDH);
                cmd.Parameters.AddWithValue("@maTrangThai", ls.MaTrangThai);
                cmd.Parameters.AddWithValue("@ngayCapNhat", ls.NgayCapNhat);
                cmd.Parameters.AddWithValue("@ghiChu", ls.GhiChu);
                conn.Open();
                int maLS = (int)cmd.ExecuteScalar();
                conn.Close();
                return maLS;
            }

        }
        public List<LichSuDonHangVM> GetByMaKh(int makh)
        {
            List<LichSuDonHangVM> list = new List<LichSuDonHangVM>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT 
                dh.SoDH,
                dh.NgayDH,
                dh.MaTrangThai,
                ttdh.TenTrangThai,
                sp.MaSP,
                sp.TenSP,
                dg.SoSao,
                sp.AnhSP,
                ms.TenMau AS MauSac,
                ms.MaMau,
                ctdh.SoLuong,
                ctdh.ThanhTien
            FROM DonDatHang dh
            INNER JOIN CTDatHang ctdh 
                ON dh.SoDH = ctdh.SoDH
            INNER JOIN SanPham sp 
                ON ctdh.MaSP = sp.MaSP
            INNER JOIN MauSac ms 
                ON ctdh.MaMau = ms.MaMau
            INNER JOIN TrangThaiDonHang ttdh 
                ON dh.MaTrangThai = ttdh.MaTrangThai
     LEFT JOIN DanhGia dg 
   ON dg.MaSP = ctdh.MaSP
   AND dg.MaMau = ctdh.MaMau
   AND dg.MaKH = dh.MaKH
            WHERE dh.MaKH = @maKH
            ORDER BY dh.NgayDH DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@maKH", makh);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    LichSuDonHangVM item = new LichSuDonHangVM
                    {
                        SoDH = (int)reader["SoDH"],
                        NgayDH = (DateTime)reader["NgayDH"],
                        MaTrangThai = (int)reader["MaTrangThai"],
                        TenTrangThai = reader["TenTrangThai"].ToString(),
                        MaSP = (int)reader["MaSP"],
                        TenSP = reader["TenSP"].ToString(),
                        AnhSP = reader["AnhSP"].ToString(),
                        MauSac = reader["MauSac"].ToString(),
                        SoLuong = (int)reader["SoLuong"],
                        ThanhTien = (decimal)reader["ThanhTien"],
                        SoSao = reader["SoSao"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["SoSao"]),
                        MaMau = Convert.ToInt32(reader["MaMau"])
                    };

                    list.Add(item);
                }

                conn.Close();
            }

            return list;
        }

    
    public List<LichSuDonHangVM> GetByMaKhAndStatus(int makh, int maTrangThai)
        {
            List<LichSuDonHangVM> list = new List<LichSuDonHangVM>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
         SELECT 
                dh.SoDH,
                dh.NgayDH,
                dh.MaTrangThai,
                ttdh.TenTrangThai,
                sp.MaSP,
                sp.TenSP,
                dg.SoSao,
                sp.AnhSP,
                ms.TenMau AS MauSac,
                ms.MaMau,
                ctdh.SoLuong,
                ctdh.ThanhTien
            FROM DonDatHang dh
            INNER JOIN CTDatHang ctdh 
                ON dh.SoDH = ctdh.SoDH
            INNER JOIN SanPham sp 
                ON ctdh.MaSP = sp.MaSP
            INNER JOIN MauSac ms 
                ON ctdh.MaMau = ms.MaMau
            INNER JOIN TrangThaiDonHang ttdh 
                ON dh.MaTrangThai = ttdh.MaTrangThai
     LEFT JOIN DanhGia dg 
   ON dg.MaSP = ctdh.MaSP
   AND dg.MaMau = ctdh.MaMau
   AND dg.MaKH = dh.MaKH
        WHERE dh.MaKH = @maKH AND dh.MaTrangThai = @maTrangThai
        ORDER BY dh.NgayDH DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@maKH", makh);
                cmd.Parameters.AddWithValue("@maTrangThai", maTrangThai);

                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    LichSuDonHangVM ls = new LichSuDonHangVM();

                    ls.SoDH = Convert.ToInt32(reader["SoDH"]);
                    ls.NgayDH = Convert.ToDateTime(reader["NgayDH"]);
                    ls.MaTrangThai = Convert.ToInt32(reader["MaTrangThai"]);
                    ls.TenTrangThai = reader["TenTrangThai"].ToString();
                    ls.MaSP = Convert.ToInt32(reader["MaSP"]);
                    ls.TenSP = reader["TenSP"].ToString();
                    ls.AnhSP = reader["AnhSP"].ToString();
                    ls.MauSac = reader["MauSac"].ToString();
                    ls.SoLuong = Convert.ToInt32(reader["SoLuong"]);
                    ls.SoSao = reader["SoSao"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["SoSao"]);
                    ls.ThanhTien = Convert.ToDecimal(reader["ThanhTien"]);
                    ls.MaMau = Convert.ToInt32(reader["MaMau"]);

                    list.Add(ls);
                }

                conn.Close();
            }

            return list;
        }
    }
}



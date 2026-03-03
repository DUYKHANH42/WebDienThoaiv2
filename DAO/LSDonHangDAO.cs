using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebDienThoai.Models;

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
    }
}
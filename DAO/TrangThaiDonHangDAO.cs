using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class TrangThaiDonHangDAO
    {

        // Add methods for CTDatHangDAO here
        string connStr = ConfigurationManager
                  .ConnectionStrings["DienThoaiDBConnectionString"]
                  .ConnectionString;
        public int ThemMoi(TrangThaiDonHang ttdh)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO[dbo].[TrangThaiDonHang]([MaTrangThai], [TenTrangThai])" +
                    "VALUES (@MaTrangThai,@TenTrangThai)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaTrangThai", ttdh.Id);
                cmd.Parameters.AddWithValue("@TenTrangThai", ttdh.Name);
                conn.Open();
                int maTT = (int)cmd.ExecuteScalar();
                conn.Close();
                return maTT;
            }
        }
    }
}
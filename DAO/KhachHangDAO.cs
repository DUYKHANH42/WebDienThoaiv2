using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Policy;
using System.Web;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class KhachHangDAO
    {
        string connStr = ConfigurationManager
                      .ConnectionStrings["DienThoaiDBConnectionString"]
                      .ConnectionString;


        public int ThemMoi(KhachHang khach)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            INSERT INTO KhachHang (TenKH, Email, DiaChi, DienThoai)
            OUTPUT INSERTED.MaKH
            VALUES (@TenKH, @Email, @DiaChi, @DienThoai)";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@TenKH", khach.TenKH);
                cmd.Parameters.AddWithValue("@Email", khach.Email);
                cmd.Parameters.AddWithValue("@DiaChi", khach.DiaChi);
                cmd.Parameters.AddWithValue("@DienThoai", khach.SoDienThoai);

                conn.Open();
                int maKH = (int)cmd.ExecuteScalar();
                conn.Close();

                return maKH;
            }
        }
        

    }
}
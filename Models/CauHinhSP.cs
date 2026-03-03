using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class CauHinhSP
    {
        public int MaCH { get; set; }
        public int MaSP { get; set; }

        public string CPU { get; set; }
        public string RAM { get; set; }
        public string BoNho { get; set; }
        public string ManHinh { get; set; }
        public string Pin { get; set; }
        public string HeDieuHanh { get; set; }

        public decimal DonGia { get; set; }
        private string connStr = ConfigurationManager.ConnectionStrings["DienThoaiDBConnectionString"].ConnectionString;
        public decimal GetGiaBySPVaMau(int maSP, int maMau)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT TOP 1 DonGia
        FROM CauHinhSP
        WHERE MaSP = @MaSP AND MaMau = @MaMau";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", maSP);
                cmd.Parameters.AddWithValue("@MaMau", maMau);

                conn.Open();
                object result = cmd.ExecuteScalar();

                return result == null ? 0 : (decimal)result;
            }
        }
    }

}

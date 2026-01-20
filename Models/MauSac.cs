using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class MauSac
    {
        public MauSac() { }
        public int  MaMau { get; set; }
        public string TenMau { get; set; }
        public string MaMauHex { get; set; }
        private string connStr = ConfigurationManager.ConnectionStrings["DienThoaiDBConnectionString"].ConnectionString;
        public MauSac GetByMaMau(int maMau)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM MauSac WHERE MaMau = @MaMau";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaMau", maMau);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    return new MauSac
                    {
                        MaMau = Convert.ToInt32(dr["MaMau"]),
                        TenMau = dr["TenMau"].ToString(),
                        MaMauHex = dr["MaMauHex"].ToString()
                    };
                }
            }
            return null;
        }

        public List<MauSac> GetByMaSP(int maSP)
        {
            List<MauSac> ds = new List<MauSac>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT m.MaMau, m.TenMau, m.MaMauHex 
                               FROM MauSac m
                               JOIN SanPham_MauSac spm ON m.MaMau = spm.MaMau
                               WHERE spm.MaSP = @MaSP";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", maSP);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ds.Add(new MauSac
                    {
                        MaMau = Convert.ToInt32(dr["MaMau"]),
                        TenMau = dr["TenMau"].ToString(),
                        MaMauHex = dr["MaMauHex"].ToString()
                    });
                }
            }
            return ds;
        }
    }
}
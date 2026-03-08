using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class DanhMucDAO
    {
        string connStr = ConfigurationManager
                 .ConnectionStrings["DienThoaiDBConnectionString"]
                 .ConnectionString;
        public DanhMuc GetByID(int ID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                DanhMuc dm;
                string sql = "SELECT * FROM LoaiSP WHERE MaLoai= @MaLoai";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaLoai", ID);

                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                if (rd.Read())
                {
                    dm = new DanhMuc
                    {
                        TenLoai = rd["TenLoai"].ToString(),
                        maLoai = (int)rd["MaLoai"],
                    };
                    return dm;
                }
            }
            return null;
        }

        public bool UpdateDanhMuc(DanhMuc dm)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE LoaiSP SET TenLoai = @TenLoai  WHERE MaLoai= @MaLoai";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@TenLoai", dm.TenLoai);
                cmd.Parameters.AddWithValue("@MaLoai", dm.maLoai);
                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            } 
        }
    }
}
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class DanhGiaDAO
    {
        string connStr = ConfigurationManager
               .ConnectionStrings["DienThoaiDBConnectionString"]
               .ConnectionString;
        public bool Insert(DanhGia dg)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                INSERT INTO DanhGia (MaSP, MaKH, SoSao, NoiDung, NgayDG)
                VALUES (@MaSP, @MaKH, @SoSao, @NoiDung, @NgayDG)";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@MaSP", dg.maSP);
                cmd.Parameters.AddWithValue("@MaKH", dg.maKH);
                cmd.Parameters.AddWithValue("@SoSao", dg.SoSao);
                cmd.Parameters.AddWithValue("@NoiDung", dg.NoiDung);
                cmd.Parameters.AddWithValue("@NgayDG", dg.ngayDG);

                conn.Open();
                int rows = cmd.ExecuteNonQuery();
                conn.Close();
                return rows > 0;
            }
        }
        public void Update(DanhGia dg)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                UPDATE DanhGia
                SET SoSao = @SoSao,
                    NoiDung = @NoiDung,
                    NgayDG = @NgayDG
                WHERE Id = @Id";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@Id", dg.Id);
                cmd.Parameters.AddWithValue("@SoSao", dg.SoSao);
                cmd.Parameters.AddWithValue("@NoiDung", dg.NoiDung);
                cmd.Parameters.AddWithValue("@NgayDG", dg.ngayDG);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }

    }
}
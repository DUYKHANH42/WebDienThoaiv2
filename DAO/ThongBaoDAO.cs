using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class ThongBaoDAO
    {
        string connStr = ConfigurationManager
              .ConnectionStrings["DienThoaiDBConnectionString"]
              .ConnectionString;
        public List<ThongBao> GetThongBao(int maNguoiNhan)
        {
            List<ThongBao> list = new List<ThongBao>();

            string sql = @"SELECT * FROM ThongBao 
                   WHERE MaNguoiNhan = @MaNguoiNhan AND  NgayTao >= DATEADD(HOUR,-24,GETDATE()) AND dadoc = 0
                   ORDER BY NgayTao DESC";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@MaNguoiNhan", maNguoiNhan);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    ThongBao tb = new ThongBao
                    {
                        MaThongBao = (int)reader["MaThongBao"],
                        TieuDe = reader["TieuDe"].ToString(),
                        NoiDung = reader["NoiDung"].ToString(),
                        MaNguoiNhan = (int)reader["MaNguoiNhan"],
                        LoaiThongBao = reader["LoaiThongBao"].ToString(),
                        DaDoc = (bool)reader["DaDoc"],
                        NgayTao = (DateTime)reader["NgayTao"]
                    };

                    list.Add(tb);
                }
            }

            return list;
        }
        public bool ThemThongBao(ThongBao tb)
        {
            string sql = @"INSERT INTO ThongBao
                   (TieuDe, NoiDung, MaNguoiNhan, LoaiThongBao)
                   VALUES (@TieuDe, @NoiDung, @MaNguoiNhan, @LoaiThongBao)";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@TieuDe", tb.TieuDe);
                cmd.Parameters.AddWithValue("@NoiDung", tb.NoiDung);
                cmd.Parameters.AddWithValue("@MaNguoiNhan", tb.MaNguoiNhan);
                cmd.Parameters.AddWithValue("@LoaiThongBao", tb.LoaiThongBao);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }
        public void DanhDauDaDoc(int maNguoiNhan)
        {
            string sql = @"UPDATE ThongBao
                   SET DaDoc = 1
                   WHERE MaNguoiNhan = @MaNguoiNhan AND DaDoc = 0";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@MaNguoiNhan", maNguoiNhan);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        public ThongBao GetThongBaoById(int maThongBao)
        {
            string sql = @"SELECT * 
                   FROM ThongBao
                   WHERE MaThongBao = @MaThongBao";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@MaThongBao", maThongBao);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    ThongBao tb = new ThongBao
                    {
                        MaThongBao = (int)reader["MaThongBao"],
                        TieuDe = reader["TieuDe"].ToString(),
                        NoiDung = reader["NoiDung"].ToString(),
                        MaNguoiNhan = (int)reader["MaNguoiNhan"],
                        LoaiThongBao = reader["LoaiThongBao"].ToString(),
                        DaDoc = (bool)reader["DaDoc"],
                        NgayTao = (DateTime)reader["NgayTao"]
                    };

                    return tb;
                }
            }

            return null;
        }

    }
}
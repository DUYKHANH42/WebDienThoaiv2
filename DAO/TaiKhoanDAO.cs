using System;
using System.Configuration;
using System.Data.SqlClient;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class TaiKhoanDAO
    {
        string connStr = ConfigurationManager
                     .ConnectionStrings["DienThoaiDBConnectionString"]
                     .ConnectionString;
        public TaiKhoan DangNhap(string username, string password)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM TaiKhoan WHERE username = @username";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@username", username);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    string storedHash = dr["password"].ToString();
                    if (BCrypt.Net.BCrypt.Verify(password, storedHash))
                    {
                        return new TaiKhoan
                        {
                            Id = (int)dr["id"],
                            username = dr["username"].ToString(),
                            password = storedHash,
                            maVT = (int)dr["MaVaiTro"],
                            MaKH = dr["MaKH"] != DBNull.Value ? (int?)dr["MaKH"] : null,
                            AvtURL = dr["AvtURL"].ToString(),
                        };
                    }
                }
                conn.Close();
                return null;
            }
        }
        public bool DangKy(TaiKhoan tk)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO TaiKhoan (username,password,maVaiTro,maKH) VALUES" +
                    " (@username,@password,@maVT,@maKH)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@username", tk.username);
                cmd.Parameters.AddWithValue("@password", tk.password);
                cmd.Parameters.AddWithValue("@maVT", tk.maVT);
                cmd.Parameters.AddWithValue("@maKH", tk.MaKH);
                conn.Open();
                int rows = cmd.ExecuteNonQuery();
                return rows > 0;
            }
        }
        public int KiemTraVaiTro(int mavt)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT COUNT(*) FROM TaiKhoan WHERE MaVaiTro = @mavt";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@mavt", mavt);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                conn.Close();
                return count; // trả về số tài khoản có vai trò này
            }
        }
        public bool TonTaiUsernameHoacEmail(string username, string email)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT COUNT(1)
            FROM TaiKhoan t
            LEFT JOIN KhachHang k ON t.MaKH = k.MaKH
            WHERE t.username = @username
               OR k.Email = @email";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@email", email);

                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

    }
}
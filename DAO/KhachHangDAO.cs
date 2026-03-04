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
        public bool CapNhatThongTin(KhachHang khach, string avtUrl)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlTransaction tran = conn.BeginTransaction();

                try
                {
                    // 1️⃣ Update KhachHang
                    string sqlKH = @"
                UPDATE KhachHang
                SET TenKH = @TenKH,
                    Email = @Email,
                    DienThoai = @DienThoai,
                    GioiTinh = @GioiTinh,
                    NgaySinh = @NgaySinh
                WHERE MaKH = @MaKH";

                    SqlCommand cmdKH = new SqlCommand(sqlKH, conn, tran);
                    cmdKH.Parameters.AddWithValue("@TenKH", khach.TenKH);
                    cmdKH.Parameters.AddWithValue("@Email", khach.Email);
                    cmdKH.Parameters.AddWithValue("@DienThoai", khach.SoDienThoai);
                    cmdKH.Parameters.AddWithValue("@GioiTinh", khach.GioiTinh);
                    cmdKH.Parameters.AddWithValue("@NgaySinh", khach.NgaySinh ?? (object)DBNull.Value);
                    cmdKH.Parameters.AddWithValue("@MaKH", khach.MaKH);

                    cmdKH.ExecuteNonQuery();
                    if (!string.IsNullOrEmpty(avtUrl))
                    {
                        string sqlTK = @"
                    UPDATE TaiKhoan
                    SET AvtUrl = @AvtUrl,
                        NgaySua = GETDATE()
                    WHERE MaKH = @MaKH";

                        SqlCommand cmdTK = new SqlCommand(sqlTK, conn, tran);
                        cmdTK.Parameters.AddWithValue("@AvtUrl", avtUrl);
                        cmdTK.Parameters.AddWithValue("@MaKH", khach.MaKH);

                        cmdTK.ExecuteNonQuery();
                    }
                    tran.Commit();
                    return true;
                }
                catch
                {
                    tran.Rollback();
                    return false;
                }
            }
        }


    }
}
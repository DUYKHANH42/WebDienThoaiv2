using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class DiaChiKHDAO
    {
        // Add methods for CTDatHangDAO here
        string connStr = ConfigurationManager
                  .ConnectionStrings["DienThoaiDBConnectionString"]
                  .ConnectionString;
        public int ThemMoi(DiaChiKH dckh)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            INSERT INTO DiaChiKH(MaKH, TenNguoiNhan, DienThoai, DiaChi, MacDinh)
            VALUES (@MaKH, @TenNguoiNhan, @DienThoai, @DiaChi, @MacDinh);
            SELECT SCOPE_IDENTITY();";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@MaKH", dckh.MaKH);
                cmd.Parameters.AddWithValue("@TenNguoiNhan", dckh.TenNguoiNhan);
                cmd.Parameters.AddWithValue("@DienThoai", dckh.DienThoai);
                cmd.Parameters.AddWithValue("@DiaChi", dckh.DiaChi);
                cmd.Parameters.AddWithValue("@MacDinh", dckh.MacDinh);

                conn.Open();

                int maDC = Convert.ToInt32(cmd.ExecuteScalar());

                conn.Close();
                return maDC;
            }
        }
        public List<DiaChiKH> FindByID(int makh)
        {
            List<DiaChiKH> list = new List<DiaChiKH>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [dbo].[DiaChiKH] WHERE MaKh = @MaKh ";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaKH", makh);
                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                while (rd.Read())
                {
                    list.Add(new DiaChiKH
                    {
                        MaDC = (int)rd.GetInt32(0),
                        MaKH = (int)rd.GetInt32(1),
                        TenNguoiNhan = rd["TenNguoiNhan"].ToString(),
                        DienThoai = rd["DienThoai"].ToString(),
                        DiaChi = rd["DiaChi"].ToString(),
                        MacDinh = (bool)rd["MacDinh"]
                    });
                }
                conn.Close();
                return list;
            }

        }
        public DiaChiKH FindByIDDC(int madc)
        {

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                DiaChiKH diachi = new DiaChiKH();
                string sql = "SELECT * FROM [dbo].[DiaChiKH] WHERE maDC = @MaDC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaDC", madc);
                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                if (rd.Read())
                {
                    diachi.MaDC = (int)rd.GetInt32(0);
                    diachi.MaKH = (int)rd.GetInt32(1);
                    diachi.TenNguoiNhan = rd["TenNguoiNhan"].ToString();
                    diachi.DienThoai = rd["DienThoai"].ToString();
                    diachi.DiaChi = rd["DiaChi"].ToString();
                    diachi.MacDinh = (bool)rd["MacDinh"];
                }

                conn.Close();
                return diachi;
            }
        }
        public bool CapNhat(DiaChiKH dckh)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();

                try
                {
                    if (dckh.MacDinh)
                    {
                        string resetSql = @"UPDATE DiaChiKH 
                                    SET MacDinh = 0 
                                    WHERE MaKH = @MaKH";

                        SqlCommand resetCmd = new SqlCommand(resetSql, conn, trans);
                        resetCmd.Parameters.AddWithValue("@MaKH", dckh.MaKH);
                        resetCmd.ExecuteNonQuery();
                    }
                    string sql = @"UPDATE DiaChiKH
                           SET TenNguoiNhan = @TenNguoiNhan,
                               DienThoai = @DienThoai,
                               DiaChi = @DiaChi,
                               MacDinh = @MacDinh
                           WHERE MaDC = @MaDC";

                    SqlCommand cmd = new SqlCommand(sql, conn, trans);
                    cmd.Parameters.AddWithValue("@MaDC", dckh.MaDC);
                    cmd.Parameters.AddWithValue("@MaKH", dckh.MaKH);
                    cmd.Parameters.AddWithValue("@TenNguoiNhan", dckh.TenNguoiNhan);
                    cmd.Parameters.AddWithValue("@DienThoai", dckh.DienThoai);
                    cmd.Parameters.AddWithValue("@DiaChi", dckh.DiaChi);
                    cmd.Parameters.AddWithValue("@MacDinh", dckh.MacDinh);

                    cmd.ExecuteNonQuery();

                    trans.Commit();
                    return true;
                }
                catch
                {
                    trans.Rollback();
                    return false;
                }
            }
        }
        public void ResetMacDinh(int makh)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE DiaChiKH SET MacDinh = 0 WHERE MaKH = @MaKH";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaKH", makh);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }
        public bool Xoa(int maDC, int maKH)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();

                try
                {
                    // Kiểm tra địa chỉ có phải mặc định không
                    string checkSql = "SELECT MacDinh FROM DiaChiKH WHERE MaDC = @MaDC AND MaKH = @MaKH";
                    SqlCommand checkCmd = new SqlCommand(checkSql, conn, trans);
                    checkCmd.Parameters.AddWithValue("@MaDC", maDC);
                    checkCmd.Parameters.AddWithValue("@MaKH", maKH);

                    bool isDefault = false;
                    object result = checkCmd.ExecuteScalar();
                    if (result != null)
                        isDefault = Convert.ToBoolean(result);

                    // Xóa địa chỉ
                    string deleteSql = "DELETE FROM DiaChiKH WHERE MaDC = @MaDC AND MaKH = @MaKH";
                    SqlCommand deleteCmd = new SqlCommand(deleteSql, conn, trans);
                    deleteCmd.Parameters.AddWithValue("@MaDC", maDC);
                    deleteCmd.Parameters.AddWithValue("@MaKH", maKH);

                    deleteCmd.ExecuteNonQuery();

                    // Nếu địa chỉ bị xóa là mặc định → set cái khác làm mặc định
                    if (isDefault)
                    {
                        string setDefaultSql = @"
                    UPDATE TOP (1) DiaChiKH
                    SET MacDinh = 1
                    WHERE MaKH = @MaKH";

                        SqlCommand setCmd = new SqlCommand(setDefaultSql, conn, trans);
                        setCmd.Parameters.AddWithValue("@MaKH", maKH);
                        setCmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                    return true;
                }
                catch
                {
                    trans.Rollback();
                    return false;
                }
            }
        }
    }
}
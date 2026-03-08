using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
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

        public DataTable GetKhachHangPaging(int page, int pageSize, out int totalRow)
        {
            DataTable dt = new DataTable();
            totalRow = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = @"
       SELECT COUNT(*) 
FROM KhachHang;

WITH KH_Paging AS
(
    SELECT *
    FROM KhachHang
    ORDER BY MaKH DESC
    OFFSET @Skip ROWS FETCH NEXT @PageSize ROWS ONLY
)

SELECT 
    kh.MaKH,
    kh.TenKH,
    kh.Email,
    kh.DienThoai,
    kh.DiaChi,tk.NgayTao,tk.TrangThai,
    COUNT(dh.SoDH) AS SoDonHang,
    ISNULL(SUM(dh.TriGia),0) AS TongChiTieu
FROM KH_Paging kh
LEFT JOIN DonDatHang dh 
    ON kh.MaKH = dh.MaKH
LEFT JOIN TaiKhoan tk 
	ON kh.MaKH = tk.MaKH
GROUP BY
    kh.MaKH,
    kh.TenKH,
    kh.Email,
    kh.DienThoai,
    kh.DiaChi,tk.NgayTao,tk.TrangThai
ORDER BY kh.MaKH DESC;;";

                SqlCommand cmd = new SqlCommand(sql, conn);

                int skip = (page - 1) * pageSize;

                cmd.Parameters.AddWithValue("@Skip", skip);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataReader rd = cmd.ExecuteReader();

                // lấy totalRow
                if (rd.Read())
                {
                    totalRow = rd.GetInt32(0);
                }

                // sang result thứ 2
                rd.NextResult();

                dt.Load(rd);

                rd.Close();
            }

            return dt;
        }
        public DataTable FilterKhachHangPaging(int page, int pageSize,
                                       string search,
                                       string trangThai,
                                       string ngay,
                                       out int totalRow)
        {
            DataTable dt = new DataTable();
            totalRow = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string where = " WHERE 1=1 ";
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;

                // search
                if (!string.IsNullOrEmpty(search))
                {
                    where += @" AND (kh.TenKH LIKE @search 
                          OR kh.Email LIKE @search 
                          OR kh.DienThoai LIKE @search)";
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");
                }

                // trạng thái
                if (!string.IsNullOrEmpty(trangThai))
                {
                    where += " AND tk.TrangThai = @trangThai";
                    cmd.Parameters.AddWithValue("@trangThai", trangThai);
                }

                // ngày tạo
                if (!string.IsNullOrEmpty(ngay))
                {
                    where += " AND CAST(tk.NgayTao AS DATE) = @ngay";
                    cmd.Parameters.AddWithValue("@ngay", ngay);
                }

                string sql = $@"

SELECT COUNT(*)
FROM KhachHang kh
LEFT JOIN TaiKhoan tk ON kh.MaKH = tk.MaKH
{where};

WITH KH_Paging AS
(
    SELECT kh.*
    FROM KhachHang kh
    LEFT JOIN TaiKhoan tk ON kh.MaKH = tk.MaKH
    {where}
    ORDER BY kh.MaKH DESC
    OFFSET @Skip ROWS FETCH NEXT @PageSize ROWS ONLY
)

SELECT 
    kh.MaKH,
    kh.TenKH,
    kh.Email,
    kh.DienThoai,
    kh.DiaChi,
    tk.NgayTao,
    tk.TrangThai,
    COUNT(dh.SoDH) AS SoDonHang,
    ISNULL(SUM(dh.TriGia),0) AS TongChiTieu
FROM KH_Paging kh
LEFT JOIN DonDatHang dh ON kh.MaKH = dh.MaKH
LEFT JOIN TaiKhoan tk ON kh.MaKH = tk.MaKH
GROUP BY
    kh.MaKH,
    kh.TenKH,
    kh.Email,
    kh.DienThoai,
    kh.DiaChi,
    tk.NgayTao,
    tk.TrangThai
ORDER BY kh.MaKH DESC";

                cmd.CommandText = sql;

                int skip = (page - 1) * pageSize;

                cmd.Parameters.AddWithValue("@Skip", skip);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataReader rd = cmd.ExecuteReader();

                // total row
                if (rd.Read())
                {
                    totalRow = rd.GetInt32(0);
                }

                rd.NextResult();

                dt.Load(rd);

                rd.Close();
            }

            return dt;
        }
    }


}
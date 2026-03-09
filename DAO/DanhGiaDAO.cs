using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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
                INSERT INTO DanhGia (MaSP, MaMau, MaKH, SoSao, NoiDung, NgayDG)
                VALUES (@MaSP, @MaMau, @MaKH, @SoSao, @NoiDung, @NgayDG)";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@MaSP", dg.maSP);
                cmd.Parameters.AddWithValue("@MaMau", dg.MaMau);   // thêm
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
        public int GetTotalReview()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT COUNT(*) FROM DanhGia";

                SqlCommand cmd = new SqlCommand(sql, conn);

                conn.Open();
                int total = (int)cmd.ExecuteScalar();
                conn.Close();

                return total;
            }
        }
        public DataTable GetAllReview(int page, int pageSize)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT 
        dg.MaDG,
        kh.TenKH,
        kh.MaKH,
        kh.DienThoai,
        dg.SoSao,
        dg.NoiDung,
        dg.NgayDG,
        sp.MaSP,
        tk.AvtUrl	
        FROM DanhGia dg
        JOIN KhachHang kh ON dg.MaKH = kh.MaKH
        JOIN SanPham sp ON dg.MaSP = sp.MaSP
        JOIN TaiKhoan tk ON tk.MaKH = kh.MaKH
        ORDER BY dg.NgayDG DESC
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY";

                SqlCommand cmd = new SqlCommand(sql, conn);

                int offset = (page - 1) * pageSize;

                cmd.Parameters.AddWithValue("@Offset", offset);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }
        public DataTable FilterReview(string keyword, int? soSao, int page, int pageSize)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT 
        dg.MaDG,
        kh.TenKH,
        kh.MaKH,
        kh.DienThoai,
        dg.SoSao,
        dg.NoiDung,
        dg.NgayDG,
        sp.MaSP,
        tk.AvtUrl
        FROM DanhGia dg
        JOIN KhachHang kh ON dg.MaKH = kh.MaKH
        JOIN SanPham sp ON dg.MaSP = sp.MaSP
        JOIN TaiKhoan tk ON tk.MaKH = kh.MaKH
        WHERE 
        (@Keyword IS NULL 
            OR kh.TenKH LIKE '%' + @Keyword + '%'
            OR dg.NoiDung LIKE '%' + @Keyword + '%'
            OR sp.MaSP LIKE '%' + @Keyword + '%')
        AND (@SoSao IS NULL OR dg.SoSao = @SoSao)

        ORDER BY dg.NgayDG DESC
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY";

                SqlCommand cmd = new SqlCommand(sql, conn);

                int offset = (page - 1) * pageSize;

                cmd.Parameters.AddWithValue("@Keyword",
                    string.IsNullOrEmpty(keyword) ? (object)DBNull.Value : keyword);

                cmd.Parameters.AddWithValue("@SoSao",
                    soSao.HasValue ? (object)soSao.Value : DBNull.Value);

                cmd.Parameters.AddWithValue("@Offset", offset);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }
        public int CountFilterReview(string keyword, int? soSao)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT COUNT(*)
        FROM DanhGia dg
        JOIN KhachHang kh ON dg.MaKH = kh.MaKH
        JOIN SanPham sp ON dg.MaSP = sp.MaSP
        WHERE 
        (@Keyword IS NULL 
            OR kh.TenKH LIKE '%' + @Keyword + '%'
            OR dg.NoiDung LIKE '%' + @Keyword + '%'
            OR sp.MaSP LIKE '%' + @Keyword + '%')
        AND (@SoSao IS NULL OR dg.SoSao = @SoSao)";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@Keyword",
                    string.IsNullOrEmpty(keyword) ? (object)DBNull.Value : keyword);

                cmd.Parameters.AddWithValue("@SoSao",
                    soSao.HasValue ? (object)soSao.Value : DBNull.Value);

                conn.Open();
                int total = (int)cmd.ExecuteScalar();
                conn.Close();

                return total;
            }
        }
    }
}
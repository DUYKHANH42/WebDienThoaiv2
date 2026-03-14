using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class DonHangDAO
    {
        string connStr = ConfigurationManager
                  .ConnectionStrings["DienThoaiDBConnectionString"]
                  .ConnectionString;
        public DonDatHang ThemMoi(DonDatHang dh)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        INSERT INTO DonDatHang
        (
            MaDonHang,
            MaKH,
            NgayDH,
            TriGia, 
            TenNguoiNhan,
            DienThoaiNhan,
            DiaChiNhan,
            PhuongThucThanhToan,
            TrangThaiThanhToan,
            MaTrangThai
        )
        OUTPUT INSERTED.SoDH
        VALUES
        (
            @MaDonHang,            
            @MaKH,
            @NgayDH,
            @TriGia,
            @TenNguoiNhan,
            @DienThoaiNhan,
            @DiaChiNhan,
            @PhuongThucThanhToan,
            @TrangThaiThanhToan,
            @MaTrangThai
        )";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@MaDonHang", dh.MaDH);
                cmd.Parameters.AddWithValue("@MaKH", dh.MaKH);
                cmd.Parameters.AddWithValue("@NgayDH", dh.NgayDat);
                cmd.Parameters.AddWithValue("@TriGia", dh.TriGia);
                cmd.Parameters.AddWithValue("@TenNguoiNhan", dh.TenNguoiNhan);
                cmd.Parameters.AddWithValue("@DienThoaiNhan", dh.DienThoaiNhan);
                cmd.Parameters.AddWithValue("@DiaChiNhan", dh.DiaChiNhan);
                cmd.Parameters.AddWithValue("@PhuongThucThanhToan", dh.PhuongThucThanhToan);
                cmd.Parameters.AddWithValue("@TrangThaiThanhToan", dh.TrangThaiThanhToan);
                cmd.Parameters.AddWithValue("@MaTrangThai", dh.MaTrangThai);

                conn.Open();
                int soDH = Convert.ToInt32(cmd.ExecuteScalar());
                conn.Close();

                dh.SoDH = soDH;
                return dh;
            }
        }
        public DataTable GetAllForAdmin()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT 
            dh.SoDH,
            dh.MaDonHang,
            dh.MaKH,
            dh.NgayDH,
            dh.TriGia AS TongTien,
            dh.PhuongThucThanhToan,
            dh.MaTrangThai,
            kh.TenKH,
            kh.DienThoai,
            tt.TenTrangThai
        FROM DonDatHang dh
        LEFT JOIN KhachHang kh ON dh.MaKH = kh.MaKH
        LEFT JOIN TrangThaiDonHang tt ON dh.MaTrangThai = tt.MaTrangThai
        ORDER BY dh.NgayDH DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }
        public DataTable GetByID(int soDH)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT 
            dh.SoDH,
            dh.MaDonHang,
            dh.NgayDH,
            dh.TriGia,
            dh.PhuongThucThanhToan,
            dh.MaTrangThai,
            dh.TenNguoiNhan,
            dh.DiaChiNhan,
            dh.DienThoaiNhan,
            tt.TenTrangThai
        FROM DonDatHang dh
        LEFT JOIN TrangThaiDonHang tt 
            ON dh.MaTrangThai = tt.MaTrangThai
        WHERE dh.SoDH = @SoDH";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@SoDH", soDH);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }
        public DataTable GetByTrangThai(int maTrangThai)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT 
            dh.SoDH,
            dh.MaDonHang,
            dh.NgayDH,
            dh.TriGia AS TongTien,
            dh.PhuongThucThanhToan,
            dh.MaTrangThai,
            kh.TenKH,
            kh.DienThoai,
            tt.TenTrangThai
        FROM DonDatHang dh
        LEFT JOIN KhachHang kh 
            ON dh.MaKH = kh.MaKH
        LEFT JOIN TrangThaiDonHang tt 
            ON dh.MaTrangThai = tt.MaTrangThai
        WHERE (@MaTrangThai = 0 OR dh.MaTrangThai = @MaTrangThai)
        ORDER BY dh.NgayDH DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaTrangThai", maTrangThai);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }
        public void UpdateTrangThai(int soDH, int maTrangThai)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE DonDatHang SET MaTrangThai = @MaTrangThai WHERE SoDH = @SoDH";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@SoDH", soDH);
                cmd.Parameters.AddWithValue("@MaTrangThai", maTrangThai);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }
        public DataTable FilterDonHang(
       string search,
       string phuongThuc,
       string ngay,
       int page,
       int pageSize,
       int maTrangThai,
       out int totalRow)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                int skip = (page - 1) * pageSize;
                if (skip < 0) skip = 0;

                string where = " WHERE 1=1 ";

                if (!string.IsNullOrEmpty(search))
                    where += " AND (dh.MaDonHang LIKE @Search OR kh.TenKH LIKE @Search)";

                if (!string.IsNullOrEmpty(phuongThuc))
                    where += " AND dh.PhuongThucThanhToan = @PhuongThuc";

                if (!string.IsNullOrEmpty(ngay))
                    where += " AND CAST(dh.NgayDH AS DATE) = @Ngay";

                if (maTrangThai != 0)
                    where += " AND dh.MaTrangThai = @MaTrangThai";


                string sql = $@"
        SELECT 
            dh.SoDH,
            dh.MaDonHang,
            dh.NgayDH,
            dh.TriGia AS TongTien,
            dh.PhuongThucThanhToan,
            dh.MaTrangThai,
            kh.TenKH,
            kh.DienThoai,
            tt.TenTrangThai
        FROM DonDatHang dh
        LEFT JOIN KhachHang kh ON dh.MaKH = kh.MaKH
        LEFT JOIN TrangThaiDonHang tt ON dh.MaTrangThai = tt.MaTrangThai
        {where}
        ORDER BY dh.NgayDH DESC
        OFFSET @Skip ROWS FETCH NEXT @PageSize ROWS ONLY;

        SELECT COUNT(*) 
        FROM DonDatHang dh
        LEFT JOIN KhachHang kh ON dh.MaKH = kh.MaKH
        {where};
        ";

                SqlCommand cmd = new SqlCommand(sql, conn);

                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@Search", "%" + search + "%");

                if (!string.IsNullOrEmpty(phuongThuc))
                    cmd.Parameters.AddWithValue("@PhuongThuc", phuongThuc);

                if (!string.IsNullOrEmpty(ngay))
                    cmd.Parameters.AddWithValue("@Ngay", DateTime.Parse(ngay));

                if (maTrangThai != 0)
                    cmd.Parameters.AddWithValue("@MaTrangThai", maTrangThai);

                cmd.Parameters.AddWithValue("@Skip", skip);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                totalRow = Convert.ToInt32(ds.Tables[1].Rows[0][0]);

                return ds.Tables[0];
            }
        }
        public DataTable GetOrderItems(int soDH)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT 
    sp.TenSP,
    sp.AnhSP,sp.DonGia,
    ct.MaMau,
    sp.DungLuong,
    ct.SoLuong,
	ms.TenMau,
    ct.ThanhTien
FROM CTDatHang ct
LEFT JOIN SanPham sp ON ct.MaSP = sp.MaSP
Left join MauSac ms on ct.MaMau = ms.MaMau
WHERE ct.SoDH = @SoDH";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@SoDH", soDH);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }
        public DataTable GetDonHangPaging(int page, int pageSize, int trangThai, out int totalRow)
        {
            DataTable dt = new DataTable();
            totalRow = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string where = "";

                if (trangThai > 0)
                    where = "WHERE dh.MaTrangThai = @TrangThai";

                string sql = $@"

SELECT COUNT(*) 
FROM DonDatHang dh
{where};

WITH DH_Paging AS
(
    SELECT *
    FROM DonDatHang dh
    {where}
    ORDER BY dh.SoDH DESC
    OFFSET @Skip ROWS FETCH NEXT @PageSize ROWS ONLY
)

SELECT 
    dh.SoDH,
    dh.MaDonHang,
    dh.NgayDH,
    dh.TriGia AS TongTien,
    dh.PhuongThucThanhToan,
    kh.TenKH,
    kh.DienThoai,
    tt.TenTrangThai
FROM DH_Paging dh
LEFT JOIN KhachHang kh ON dh.MaKH = kh.MaKH
LEFT JOIN TrangThaiDonHang tt ON dh.MaTrangThai = tt.MaTrangThai
ORDER BY dh.SoDH DESC
";

                SqlCommand cmd = new SqlCommand(sql, conn);

                if (trangThai > 0)
                    cmd.Parameters.AddWithValue("@TrangThai", trangThai);

                int skip = (page - 1) * pageSize;

                if (skip < 0)
                    skip = 0;

                cmd.Parameters.AddWithValue("@Skip", skip);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataReader rd = cmd.ExecuteReader();

                if (rd.Read())
                    totalRow = rd.GetInt32(0);

                rd.NextResult();

                dt.Load(rd);

                rd.Close();
            }

            return dt;
        }
    }

}
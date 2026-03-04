using System;
using System.Configuration;
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
    }
}
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using WebDienThoai.ViewModels;

namespace WebDienThoai.DAO
{
    public class DashboardDAO
    {
        string connStr = ConfigurationManager
                 .ConnectionStrings["DienThoaiDBConnectionString"]
                 .ConnectionString;
        public DashboardViewModel GetDashboardData()
        {
            var model = new DashboardViewModel();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                using (SqlTransaction tran = conn.BeginTransaction())
                {
                    try
                    {
                        model.DanhThuHomNay = GetScalarDecimal(conn, tran, @"
                        SELECT ISNULL(SUM(ThanhTien),0)
                        FROM DonDatHang dh
                        INNER JOIN CTDatHang ctdh ON dh.SoDH = ctdh.SoDH
                        WHERE CAST(NgayDH AS DATE) = CAST(GETDATE() AS DATE)
                        AND MaTrangThai = 4");

                        model.DanhThuHomQua = GetScalarDecimal(conn, tran, @"
                        SELECT ISNULL(SUM(ThanhTien),0)
                        FROM DonDatHang dh
                        INNER JOIN CTDatHang ctdh ON dh.SoDH = ctdh.SoDH
                        WHERE CAST(NgayDH AS DATE) = CAST(DATEADD(DAY,-1,GETDATE()) AS DATE)
                        AND MaTrangThai = 4");

                        model.SoDonHangHomNay = GetScalarInt(conn, tran, @"
                        SELECT COUNT(*)
                        FROM DonDatHang
                        WHERE CAST(NgayDH AS DATE) = CAST(GETDATE() AS DATE)");


                        model.SoDonHangDangXuLy = GetScalarInt(conn, tran, @"
                        SELECT COUNT(*)
                        FROM DonDatHang
                        WHERE MaTrangThai = 1");

                        model.TongTonKho = GetScalarInt(conn, tran, @"
                        SELECT ISNULL(SUM(SoLuongTon),0)
                        FROM SanPham");

                        model.SoThuongHieu = GetScalarInt(conn, tran, @"
                        SELECT COUNT(DISTINCT MaNSX)
                        FROM SanPham");

                        model.KhachHangMoi = GetScalarInt(conn, tran, @"
                        SELECT COUNT(*)
                        FROM KhachHang kh
                        INNER JOIN TaiKhoan tk ON kh.MaKH = tk.MaKH
                        WHERE MONTH(NgayTao) = MONTH(GETDATE())
                        AND YEAR(NgayTao) = YEAR(GETDATE())");
                        model.KhachHangCu = GetScalarInt(conn, tran, @"
                        SELECT COUNT(*)
                        FROM KhachHang kh
                        INNER JOIN TaiKhoan tk ON kh.MaKH = tk.MaKH
                        WHERE MONTH(NgayTao) = MONTH(GETDATE()) - 1
                        AND YEAR(NgayTao) = YEAR(GETDATE())");

                        model.DoanhThuTheoThang = GetMonthlyRevenue(conn, tran);
                        model.SanPhamBanChay = GetTopProducts(conn, tran);
                        model.DonHangGanDay = GetRecentOrders(conn, tran);

                        tran.Commit();
                    }
                    catch
                    {
                        tran.Rollback();
                        throw;
                    }
                }
            }

            return model;
        }
        private List<RecentOrderVM> GetRecentOrders(SqlConnection conn, SqlTransaction tran)
        {
            var list = new List<RecentOrderVM>();

            string sql = @"
        SELECT TOP 10
            dh.MaDonHang,
            kh.TenKH,
            dh.NgayDH,
            SUM(ctdh.ThanhTien) as TongTien,
            thdh.TenTrangThai
        FROM DonDatHang dh
        INNER JOIN CTDatHang ctdh ON ctdh.SoDH = dh.SoDH
        INNER JOIN KhachHang kh ON dh.MaKH = kh.MaKH
        INNER JOIN TrangThaiDonHang thdh ON thdh.MaTrangThai= dh.MaTrangThai
        GROUP BY dh.MaDonHang, kh.TenKH, dh.NgayDH, thdh.TenTrangThai
        ORDER BY dh.NgayDH DESC";

            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        list.Add(new RecentOrderVM
                        {
                             OrderId = rd["MaDonHang"]?.ToString() ?? "",
                            CustomerName = rd["TenKH"]?.ToString() ?? "",
                            OrderDate = rd["NgayDH"] != DBNull.Value ? Convert.ToDateTime(rd["NgayDH"]) : DateTime.MinValue,
                           TotalMoney = rd["TongTien"] != DBNull.Value ? Convert.ToDecimal(rd["TongTien"]) : 0,
                            Status = rd["TenTrangThai"]?.ToString() ?? ""
                        });
                    }
                }
            }

            return list;
        }
        private List<MonthlyRevenueVM> GetMonthlyRevenue(SqlConnection conn, SqlTransaction tran)
        {
            var list = new List<MonthlyRevenueVM>();

            using (SqlCommand cmd = new SqlCommand(@"
        SELECT MONTH(NgayDH), ISNULL(SUM(ThanhTien),0)
        FROM DonDatHang dh
        INNER JOIN CTDatHang ctdh ON dh.SoDH = ctdh.SoDH
        WHERE YEAR(NgayDH) = YEAR(GETDATE())
        AND MaTrangThai = 4
        GROUP BY MONTH(NgayDH)
        ORDER BY 1", conn, tran))
            {
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        list.Add(new MonthlyRevenueVM
                        {
                            Month = rd.GetInt32(0),
                            Revenue = rd.GetDecimal(1)
                        });
                    }
                }
            }

            return list;
        }
        private List<TopProductVM> GetTopProducts(SqlConnection conn, SqlTransaction tran)
        {
            var list = new List<TopProductVM>();

            using (SqlCommand cmd = new SqlCommand(@"
        SELECT TOP 5 sp.TenSP, sp.DonGia, SUM(ct.SoLuong),sp.AnhSP
        FROM CTDatHang ct
        INNER JOIN DonDatHang dh ON ct.SoDH = dh.SoDH
        INNER JOIN SanPham sp ON ct.MaSP = sp.MaSP
        WHERE dh.MaTrangThai = 4
        GROUP BY sp.TenSP, sp.DonGia,sp.AnhSP
        ORDER BY SUM(ct.SoLuong) DESC", conn, tran))
            {
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        list.Add(new TopProductVM
                        {
                            ProductName = rd.GetString(0),
                            Price = rd.GetDecimal(1),
                            TotalSold = rd.GetInt32(2),
                            ProductImg = rd.GetString(3),

                        });
                    }
                }
            }

            return list;
        }
        private decimal GetScalarDecimal(SqlConnection conn, SqlTransaction tran, string sql)
        {
            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                object result = cmd.ExecuteScalar();
                return result == DBNull.Value || result == null
                    ? 0
                    : Convert.ToDecimal(result);
            }
        }

        private int GetScalarInt(SqlConnection conn, SqlTransaction tran, string sql)
        {
            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                object result = cmd.ExecuteScalar();
                return result == DBNull.Value || result == null
                    ? 0
                    : Convert.ToInt32(result);
            }
        } 
    
}
}

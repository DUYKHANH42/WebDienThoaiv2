using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.ViewModels
{
    public class DashboardViewModel
    {
        public decimal DanhThuHomNay { get; set; }
        public decimal DanhThuHomQua { get; set; }

        public int SoDonHangHomNay { get; set; }
        public int SoDonHangDangXuLy { get; set; }

        public int TongTonKho { get; set; }
        public int SoThuongHieu { get; set; }

        public int KhachHangMoi { get; set; }
        public int KhachHangCu { get; set; }

        public List<MonthlyRevenueVM> DoanhThuTheoThang { get; set; }
        public List<TopProductVM> SanPhamBanChay { get; set; }
        public List<RecentOrderVM> DonHangGanDay { get; set; }
    }
}
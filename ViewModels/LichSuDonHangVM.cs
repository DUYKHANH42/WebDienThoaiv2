using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.ViewModels
{
    public class LichSuDonHangVM
    {
        public int SoDH { get; set; }
        public DateTime NgayDH { get; set; }
        public int MaTrangThai { get; set; }
        public string TenTrangThai { get; set; }

        public int MaSP { get; set; }
        public string TenSP { get; set; }
        public string AnhSP { get; set; }
        public string MauSac { get; set; }

        public int SoLuong { get; set; }
        public decimal ThanhTien { get; set; }
        public int? SoSao { get; set; }
        public int MaMau { get; set; }
    }
}
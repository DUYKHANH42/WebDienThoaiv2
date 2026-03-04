using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class DonDatHang
    {
        public DonDatHang() { }
        public int SoDH { get; set; }
        public string MaDH { get; set; }
        public int MaKH { get; set; }
        public DateTime NgayDat { get; set; }
        public decimal TriGia { get; set; }
        public string TenNguoiNhan { get; set; }
        public string DienThoaiNhan { get; set; }
        public string DiaChiNhan { get; set; }
        public string PhuongThucThanhToan { get; set; }
        public string TrangThaiThanhToan { get; set; }
        public DateTime NgayGiao { get; set; }
        public int MaTrangThai { get; set; }    

    }
}
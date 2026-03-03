using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class CartItem
    {
        public SanPham SanPham { get; set; }
        public int MaSP { get; set; }
        public string TenSP { get; set; }
        public string HinhAnh { get; set; }
        public decimal DonGia { get; set; }

        public MauSac MauSac { get; set; }
        public int SoLuong { get; set; } = 1;

        public decimal ThanhTien => DonGia * SoLuong;
    }
}
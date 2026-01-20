using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class CartItem
    {
        public SanPham SanPham { get; set; }
        public MauSac MauSac { get; set; }
        public int SoLuong { get; set; } = 1;

        public decimal ThanhTien
        {
            get
            {
                if (SanPham != null)
                    return SanPham.DonGia * SoLuong;
                return 0;
            }
        }
    }
}
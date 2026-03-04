using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class DiaChiKH
    {
        public DiaChiKH() {}
        public int MaDC { get; set; }
        public int MaKH { get; set; }
        public string TenNguoiNhan { get; set; }
        public string DienThoai { get; set; }
        public string DiaChi { get; set; }
        public bool MacDinh { get; set; }

    }
}
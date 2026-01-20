using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class MenuLoai
    {
        public int MaLoai { get; set; }
        public string TenLoai { get; set; }

        public List<MenuNSX> ThuongHieu { get; set; }
        public List<MenuSP> SanPhamNoiBat { get; set; }

        public MenuLoai()
        {
            ThuongHieu = new List<MenuNSX>();
            SanPhamNoiBat = new List<MenuSP>();
        }
    }

    public class MenuNSX
    {
        public int MaNSX { get; set; }
        public string TenNSX { get; set; }
        public string Logo { get; set; }
        public int MaLoai { get; set; }
    }

    public class MenuSP
    {
        public int MaSP { get; set; }
        public string TenSP { get; set; }
    }
}
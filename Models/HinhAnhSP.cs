using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class HinhAnhSP
    {
        public int MaHinh { get; set; }
        public int MaSP { get; set; }
        public string TenHinh { get; set; }
        public int? ThuTu { get; set; }
        public int? MaMau { get; set; }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class LichSuDonHang
    {
        public LichSuDonHang() { }
        public int MaLS { get; set; }
        public int SoDH { get; set; }
        public int MaTrangThai { get; set; }
        public DateTime NgayCapNhat { get; set; }
        public string GhiChu { get; set; }

    }
}
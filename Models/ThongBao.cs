using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class ThongBao
    {
        public int MaThongBao { get; set; }
        public string TieuDe { get; set; }
        public string NoiDung { get; set; }
        public int MaNguoiNhan { get; set; }
        public string LoaiThongBao { get; set; }
        public bool DaDoc { get; set; }
        public DateTime NgayTao { get; set; }

    }
}
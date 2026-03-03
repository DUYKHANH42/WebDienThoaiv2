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
        public int MaKH { get; set; }
        public DateTime NgayDat { get; set; }
        public decimal TriGia { get; set; }
        public bool DaGiao { get; set; }
        public DateTime NgayGiao { get; set; }
        public int MaTrangThai { get; set; }    

    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class DanhGia
    {
        public int Id { get; set; }
        public int maSP { get; set; }
        public int maKH { get; set; }
        public int SoSao { get; set; }
        public string NoiDung {  get; set; }
        public DateTime ngayDG { get; set; }
        public int MaMau { get; set; }
    }
}
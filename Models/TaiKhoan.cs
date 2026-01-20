using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebDienThoai.Models
{
    public class TaiKhoan
    {
        public int Id { get; set; }
        public string username { get; set; }
        public string password { get; set; }

        public int maVT { get; set; }
        public int? MaKH { get; set; }

    }
}
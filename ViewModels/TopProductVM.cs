using System.Collections.Generic;

namespace WebDienThoai.ViewModels
{

    public class TopProductVM
    {
    public List<TopProductVM> TopProducts { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public int TotalSold { get; set; }
        public string ProductImg { get; set; }
    }
}
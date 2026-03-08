using System;
using System.Collections.Generic;

namespace WebDienThoai.ViewModels
{

    public class RecentOrderVM
    {
        public List<RecentOrderVM> RecentOrders { get; set; }

        public string OrderId { get; set; }
        public string CustomerName { get; set; }
        public DateTime OrderDate { get; set; }
        public decimal TotalMoney { get; set; }
        public string Status { get; set; }
    }
}
using System.Collections.Generic;

namespace WebDienThoai.ViewModels
{

    public class MonthlyRevenueVM
    {
    public List<MonthlyRevenueVM> MonthlyRevenue { get; set; }
        public int Month { get; set; }
        public decimal Revenue { get; set; }
    }
}
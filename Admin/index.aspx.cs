using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;
using WebDienThoai.ViewModels;

namespace WebDienThoai.Admin
{
    public partial class index : System.Web.UI.Page
    {
        public string PhamTramDoanhThu { get; set; }
        public string PhamTramKhachHang { get; set; }
        public string IconDoanhThu { get; set; }

        DashboardDAO dashboardDAO = new DashboardDAO();
        public DashboardViewModel model ;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboard();
            }

        }

        private void LoadDashboard()
        {
            model= dashboardDAO.GetDashboardData();
            litDoanhThuHomNay.Text = string.Format("{0:N0} ₫", model.DanhThuHomNay);
            litDonHangHomNay.Text = model.SoDonHangHomNay.ToString();
            litTonKho.Text = model.TongTonKho.ToString("N0");
            litKhachHangMoi.Text = model.KhachHangMoi.ToString();
            lblDonChoXuLy.Text = model.SoDonHangDangXuLy.ToString();
            lblSoThuongHieu.Text = model.SoThuongHieu.ToString();
            decimal ptKhachHang = TinhPhanTram(model.KhachHangMoi, model.KhachHangCu);
            PhamTramKhachHang = TaoMoTaPhanTram(ptKhachHang, "tháng này");

            decimal ptDoanhThu = TinhPhanTram(model.DanhThuHomNay, model.DanhThuHomQua);
            var result = TaoDoanhThu(ptDoanhThu);

            PhamTramDoanhThu = result.text;
            IconDoanhThu = result.icon;
            rptTopProducts.DataSource = model.SanPhamBanChay;
            rptTopProducts.DataBind();
            rptRecentOrders.DataSource = model.DonHangGanDay;
            rptRecentOrders.DataBind();

        }
        protected string GetStatusClass(string status)
        {
            switch (status)
            {
                case "Chờ xử lý":
                    return "badge-soft badge-pending";

                case "Hoàn thành":
                    return "badge-soft badge-success";

                case "Đã hủy":
                    return "badge-soft badge-danger";

                default:
                    return "badge-soft badge-secondary";
            }
        }
        private decimal TinhPhanTram(decimal giaTriMoi, decimal giaTriCu)
        {
            if (giaTriCu == 0)
                return giaTriMoi > 0 ? 100 : 0;

            return (giaTriMoi - giaTriCu) / giaTriCu * 100;
        }
        private string TaoMoTaPhanTram(decimal phanTram, string donViSoSanh)
        {
            if (phanTram > 0)
                return $"Tăng {Math.Abs(phanTram):N1}% {donViSoSanh}";
            if (phanTram < 0)
                return $"Giảm {Math.Abs(phanTram):N1}% {donViSoSanh}";

            return $"Không thay đổi {donViSoSanh}";
        }
        private (string text, string icon) TaoDoanhThu(decimal phanTram)
        {
            if (phanTram > 0)
                return ($"Tăng {Math.Abs(phanTram):N1}% so với hôm qua",
                        "fas fa-arrow-up me-1 text-success");

            if (phanTram < 0)
                return ($"Giảm {Math.Abs(phanTram):N1}% so với hôm qua",
                        "fas fa-arrow-down me-1 text-danger");

            return ("Không thay đổi so với hôm qua",
                    "fas fa-minus me-1 text-muted");
        }
        [System.Web.Services.WebMethod]
        public static List<object> GetRevenueChart()
        {
            DashboardDAO dao = new DashboardDAO();
            var data = dao.GetDashboardData().DoanhThuTheoThang;

            var result = new List<object>();

            for (int i = 1; i <= 12; i++)
            {
                var item = data.FirstOrDefault(x => x.Month == i);
                decimal value = item != null ? item.Revenue : 0;

                result.Add(new
                {
                    month = "Th " + i,
                    revenue = value
                });
            }

            return result;
        }
    }
}
namespace WebDienThoai.Models
{
    public class CTDatHang
    {
        public CTDatHang() { }
        public int SoDH { get; set; }
        public int MaSP { get; set; }
        public int SoLuong { get; set; }
        public decimal DonGia { get; set; }
        public SanPham SanPham { get; set; }
        public decimal ThanhTien { get; set; }
    }
}
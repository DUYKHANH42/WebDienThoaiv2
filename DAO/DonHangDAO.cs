using System.Configuration;
using System.Data.SqlClient;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class DonHangDAO
    {
        string connStr = ConfigurationManager
                  .ConnectionStrings["DienThoaiDBConnectionString"]
                  .ConnectionString;
        public DonDatHang ThemMoi(DonDatHang dh)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO DonDatHang (MaKH, NgayDH, TriGia, DaGiao, MaTrangThai) " +
                    "OUTPUT INSERTED.SoDH " +
                    "VALUES (@maKH, @ngayDH, @triGia, @daGiao, @maTrangThai)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@maKH", dh.MaKH);
                cmd.Parameters.AddWithValue("@ngayDH", dh.NgayDat);
                cmd.Parameters.AddWithValue("@triGia", dh.TriGia);
                cmd.Parameters.AddWithValue("@daGiao", dh.DaGiao);
                cmd.Parameters.AddWithValue("@maTrangThai", dh.MaTrangThai);
                conn.Open();
                int soDH = (int)cmd.ExecuteScalar();
                conn.Close();
                dh.SoDH = soDH;
                return dh;
            }
        }
    }
}
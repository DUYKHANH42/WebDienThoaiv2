using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class CTDatHangDAO
    {
        // Add methods for CTDatHangDAO here
        string connStr = ConfigurationManager
                  .ConnectionStrings["DienThoaiDBConnectionString"]
                  .ConnectionString;
        public CTDatHang ThemMoi (CTDatHang ct)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO CTDatHang (SoDH, MaSP, SoLuong, DonGia,ThanhTien,MaMau) " +
                    "VALUES (@soDH, @maSP, @soLuong, @donGia,@ThanhTien,@MaMau)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@soDH", ct.SoDH);
                cmd.Parameters.AddWithValue("@maSP", ct.MaSP);
                //cmd.Parameters.AddWithValue("@maMauSac", ct.MaMauSac);
                cmd.Parameters.AddWithValue("@soLuong", ct.SoLuong);
                cmd.Parameters.AddWithValue("@donGia", ct.DonGia);
                cmd.Parameters.AddWithValue("@ThanhTien", ct.ThanhTien);
                cmd.Parameters.AddWithValue("@MaMau", ct.MaMau);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
                return ct;
            }
        }
    }
}
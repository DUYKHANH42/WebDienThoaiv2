using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WebDienThoai.DAO
{
    public class MenuDAO
    {
        string connStr = ConfigurationManager
            .ConnectionStrings["DienThoaiDBConnectionString"].ConnectionString;

        public DataTable GetMenuRaw()
        {
            string sql = @"         
	 SELECT
    l.MaLoai,
    l.TenLoai,
    nsx.MaNSX,
    nsx.TenNSX,
    nsx.Logo,
    sp.MaSP,
    sp.TenSP,
    sp.DonGia
FROM LoaiSP l
LEFT JOIN (
    SELECT MaLoai, MaNSX, MIN(MaSP) AS MaSP -- lấy 1 sp bất kỳ cho NSX
    FROM SanPham
    GROUP BY MaLoai, MaNSX
) spFirst ON spFirst.MaLoai = l.MaLoai
LEFT JOIN NhaSanXuat nsx ON nsx.MaNSX = spFirst.MaNSX
LEFT JOIN SanPham sp ON sp.MaSP = spFirst.MaSP
ORDER BY l.MaLoai, nsx.MaNSX;
";

            SqlDataAdapter da = new SqlDataAdapter(sql, connStr);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
    }

}
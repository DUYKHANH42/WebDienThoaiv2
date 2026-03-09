using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using WebDienThoai.Models;

namespace WebDienThoai.DAO
{
    public class SanPhamDAO
    {
        // Add methods for CTDatHangDAO here
        string connStr = ConfigurationManager
                  .ConnectionStrings["DienThoaiDBConnectionString"]
                  .ConnectionString;
        public List<SanPham> GetSanPhamPaging(int page, int pageSize)
        {
            List<SanPham> list = new List<SanPham>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = @"
       SELECT *
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY sp.MaSP DESC) AS RowNum,
           sp.MaSP, sp.TenSP,sp.MaLoai, sp.AnhSP, sp.MaNSX, sp.DonGia,
           l.TenLoai, n.TenNSX,
           sp.NgayCapNhat
    FROM SanPham sp
    INNER JOIN LoaiSP l ON sp.MaLoai = l.MaLoai
    INNER JOIN NhaSanXuat n ON sp.MaNSX = n.MaNSX
) AS T
WHERE RowNum BETWEEN @start AND @end
";

                int start = (page - 1) * pageSize + 1;
                int end = page * pageSize;

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@start", start);
                cmd.Parameters.AddWithValue("@end", end);

                SqlDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    SanPham sp = new SanPham();
                    sp.MaSP = (int)rd["MaSP"];
                    sp.TenSP = rd["TenSP"].ToString();
                    sp.AnhSP = rd["AnhSP"].ToString();
                    sp.DonGia = (decimal)rd["DonGia"];
                    sp.MaLoai = (int)rd["MaLoai"];
                    sp.MaNSX = (int)rd["MaNSX"];
                    sp.TenLoai = rd["TenLoai"].ToString();
                    sp.TenNSX = rd["TenNSX"].ToString();
                    sp.NgayCapNhat = (DateTime)rd["NgayCapNhat"];

                    list.Add(sp);
                }
            }
            return list;
        }
        public List<SanPham> GetAllSanPham()
        {
            List<SanPham> ds = new List<SanPham>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
SELECT 
    sp.MaSP,
    sp.TenSP,
    sp.AnhSP,
    sp.MaLoai,
    sp.MaNSX,
    sp.NgayCapNhat,
    l.TenLoai,
    n.TenNSX,
    MIN(ch.DOnGia) AS GiaMin,sp.SoLuongTon
FROM SanPham sp
LEFT JOIN CauHinhSP ch ON sp.MaSP = ch.MaSP
INNER JOIN LoaiSP l ON sp.MaLoai = l.MaLoai
INNER JOIN NhaSanXuat n ON sp.MaNSX = n.MaNSX
WHERE sp.DaXoa = 0
GROUP BY
    sp.MaSP, sp.TenSP, sp.AnhSP, sp.MaLoai, sp.MaNSX, sp.NgayCapNhat,
    l.TenLoai, n.TenNSX,sp.SoLuongTon
ORDER BY sp.MaSP DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    ds.Add(new SanPham
                    {
                        MaSP = (int)dr["MaSP"],
                        TenSP = dr["TenSP"].ToString(),
                        AnhSP = dr["AnhSP"].ToString(),
                        MaLoai = (int)dr["MaLoai"],
                        MaNSX = (int)dr["MaNSX"],
                        TenLoai = dr["TenLoai"].ToString(),
                        TenNSX = dr["TenNSX"].ToString(),
                        NgayCapNhat = (DateTime)dr["NgayCapNhat"],
                        GiaMin = dr["GiaMin"] == DBNull.Value ? 0 : (decimal)dr["GiaMin"],
                        TonKho = dr["SoLuongTon"] == DBNull.Value ? 0 : (int)dr["SoLuongTon"],

                    });
                }
            }
            return ds;
        }

        public int GetTotalPages(int pageSize)
        {
            int totalRecords = GetAllSanPham().Count();
            return (int)Math.Ceiling((double)totalRecords / pageSize);
        }
        public SanPham GetSPByID(int maSP)
        {
            SanPham sp = null;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT sp.*, l.TenLoai, n.TenNSX
        FROM SanPham sp
        JOIN LoaiSP l ON sp.MaLoai = l.MaLoai
        JOIN NhaSanXuat n ON sp.MaNSX = n.MaNSX
        WHERE sp.MaSP = @MaSP";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", maSP);

                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                if (rd.Read())
                {
                    sp = new SanPham
                    {
                        MaSP = (int)rd["MaSP"],
                        TenSP = rd["TenSP"].ToString(),
                        MaLoai = (int)rd["MaLoai"],
                        MaNSX = (int)rd["MaNSX"],
                        TonKho = (int)rd["SoLuongTon"],
                        DonGia = rd["DonGia"] != DBNull.Value
                    ? Convert.ToDecimal(rd["DonGia"])
                    : 0,

                        MoTa = rd["MoTa"]?.ToString(),
                        AnhSP = rd["AnhSP"]?.ToString(),

                        NgayCapNhat = rd["NgayCapNhat"] != DBNull.Value
                        ? Convert.ToDateTime(rd["NgayCapNhat"])
                        : DateTime.MinValue,

                        DungLuong = rd["Dungluong"]?.ToString(),
                        ThiTruong = rd["ThiTruong"]?.ToString(),

                        DaXoa = rd["DaXoa"] != DBNull.Value
                    ? Convert.ToBoolean(rd["DaXoa"])
                    : false
                    };

                }
            }
            return sp;
        }

        public List<HinhAnhSP> GetListHinh(int maSP)
        {
            List<HinhAnhSP> list = new List<HinhAnhSP>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM HinhAnhSanPham WHERE MaSP = @MaSP";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaSP", maSP);

                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    list.Add(new HinhAnhSP
                    {
                        MaHinh = (int)rd["MaHinh"],
                        MaSP = (int)rd["MaSP"],
                        TenHinh = rd["TenHinh"].ToString()
                    });
                }
            }
            return list;
        }
        public bool UpdateSanPham(SanPham sp)
        {
            string sql = @"UPDATE SanPham
                   SET TenSP = @TenSP,
                       DonGia = @DonGia,
                       MoTa = @MoTa,
                       MaLoai = @MaLoai,
                       MaNSX = @MaNSX,
                       DungLuong = @DungLuong,
                       ThiTruong = @ThiTruong,  
                       SoLuongTon = @SoLuongTon
                   WHERE MaSP = @MaSP";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@MaSP", sp.MaSP);
                    cmd.Parameters.AddWithValue("@TenSP", sp.TenSP);
                    cmd.Parameters.AddWithValue("@DonGia", sp.DonGia);
                    cmd.Parameters.AddWithValue("@MoTa", sp.MoTa);
                    cmd.Parameters.AddWithValue("@MaLoai", sp.MaLoai);
                    cmd.Parameters.AddWithValue("@MaNSX", sp.MaNSX);
                    cmd.Parameters.AddWithValue("@DungLuong", sp.DungLuong);
                    cmd.Parameters.AddWithValue("@ThiTruong", sp.ThiTruong);
                    cmd.Parameters.AddWithValue("@SoLuongTon", sp.TonKho);
                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }
        public void DeleteHinh(int maHinh)
        {
            string sql = "DELETE FROM HinhAnhSanPham WHERE MaHinh = @MaHinh";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@MaHinh", maHinh);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        public void InsertHinh(int maSP, string tenHinh)
        {
            string sql = @"
        INSERT INTO HinhAnhSanPham(MaSP, TenHinh, ThuTu, MaMau)
        VALUES(
            @MaSP,
            @TenHinh,
            ISNULL((SELECT MAX(ThuTu) FROM HinhAnhSanPham WHERE MaSP=@MaSP),0) + 1,
            NULL
        )";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@MaSP", SqlDbType.Int).Value = maSP;
                cmd.Parameters.Add("@TenHinh", SqlDbType.NVarChar).Value = tenHinh;

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void DeleteFullSanPham(int maSP)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand(
                    "UPDATE SanPham SET DaXoa = 1 WHERE MaSP = @id",
                    conn);

                cmd.Parameters.AddWithValue("@id", maSP);

                cmd.ExecuteNonQuery();
            }
        }
        public int InsertSanPham(SqlConnection conn, SqlTransaction tran, SanPham sp)
        {
            string sql = @"
    INSERT INTO SanPham
    (
        TenSP,
        MaLoai,
        MaNSX,
        DonGia,
        AnhSP,
        MoTa,
        NgayCapNhat,
        ThiTruong,DungLuong,
        DaXoa,
        SoLuongTon
    )
    VALUES
    (
        @TenSP,
        @MaLoai,
        @MaNSX,
        @DonGia,
        @AnhSP,
        @MoTa,
        @NgayCapNhat,
        @ThiTruong,@DungLuong,
        0,@SoLuongTon
    );

    SELECT SCOPE_IDENTITY();";

            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                cmd.Parameters.AddWithValue("@TenSP", sp.TenSP);
                cmd.Parameters.AddWithValue("@MaLoai", sp.MaLoai);
                cmd.Parameters.AddWithValue("@MaNSX", sp.MaNSX);
                cmd.Parameters.AddWithValue("@DonGia", sp.DonGia);
                cmd.Parameters.AddWithValue("@AnhSP", (object)sp.AnhSP ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@MoTa", (object)sp.MoTa ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@NgayCapNhat", sp.NgayCapNhat);
                cmd.Parameters.AddWithValue("@ThiTruong", (object)sp.ThiTruong ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@DungLuong", (object)sp.DungLuong ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@SoLuongTon", (object)sp.TonKho ?? DBNull.Value);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }


        public void UpdateAnhDaiDien(SqlConnection conn, SqlTransaction tran,
                              int maSP, string tenHinh)
        {
            string sql = "UPDATE SanPham SET AnhSP=@anh WHERE MaSP=@id";

            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                cmd.Parameters.AddWithValue("@anh", tenHinh);
                cmd.Parameters.AddWithValue("@id", maSP);
                cmd.ExecuteNonQuery();
            }
        }

        public void InsertCauHinh(SqlConnection conn, SqlTransaction tran, CauHinhSP ch)
        {
            string sql = @"
    INSERT INTO CauHinhSP(
        MaSP, CPU, RAM, BoNho, ManHinh, Pin, HeDieuHanh, DonGia
    )
    VALUES(
        @MaSP, @CPU, @RAM, @BoNho, @ManHinh, @Pin, @HeDieuHanh, @DonGia
    )";

            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                cmd.Parameters.AddWithValue("@MaSP", ch.MaSP);
                cmd.Parameters.AddWithValue("@CPU", (object)ch.CPU ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@RAM", (object)ch.RAM ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@BoNho", (object)ch.BoNho ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@ManHinh", (object)ch.ManHinh ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Pin", (object)ch.Pin ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@HeDieuHanh", (object)ch.HeDieuHanh ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@DonGia", ch.DonGia);

                cmd.ExecuteNonQuery();
            }
        }
        public void UpdateGiaSanPham(SqlConnection conn, SqlTransaction tran, int maSP)
        {
            string sql = @"
    UPDATE SanPham
    SET DonGia = (
        SELECT MIN(DonGia)
        FROM CauHinhSP
        WHERE MaSP = @MaSP
    )
    WHERE MaSP = @MaSP;";

            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                cmd.Parameters.AddWithValue("@MaSP", maSP);
                cmd.ExecuteNonQuery();
            }
        }


        public void InsertMau(SqlConnection conn, SqlTransaction tran,
                        int maSP, string mau)
        {
            string sql = "INSERT INTO SanPham_MauSac(MaSP, MaMau) VALUES(@sp,@mau)";

            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                cmd.Parameters.AddWithValue("@sp", maSP);
                cmd.Parameters.AddWithValue("@mau", mau);
                cmd.ExecuteNonQuery();
            }
        }

        public void InsertHinhAnh(SqlConnection conn, SqlTransaction tran, HinhAnhSP h)
        {
            string sql = @"
    INSERT INTO HinhAnhSanPham(MaSP, TenHinh, ThuTu, MaMau)
    VALUES(
        @sp,
        @ten,
        ISNULL((SELECT MAX(ThuTu) FROM HinhAnhSanPham WHERE MaSP=@sp),0)+1,
        @maMau
    )";

            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
            {
                cmd.Parameters.AddWithValue("@sp", h.MaSP);
                cmd.Parameters.AddWithValue("@ten", h.TenHinh);
                cmd.Parameters.AddWithValue("@maMau", (object)h.MaMau ?? DBNull.Value);

                cmd.ExecuteNonQuery();
            }
        }
        public int UpdateTonKho(int maSP, int soLuongMua)
        {
            string sql = @"UPDATE SanPham 
                   SET SoLuongTon = SoLuongTon - @SoLuongMua
                   WHERE MaSP = @MaSP;

                   SELECT SoLuongTon 
                   FROM SanPham 
                   WHERE MaSP = @MaSP";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@MaSP", maSP);
                cmd.Parameters.AddWithValue("@SoLuongMua", soLuongMua);

                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
        public DataTable SearchSuggest(string keyword)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
        SELECT TOP 5 
            MaSP,
            TenSP,
            DonGia,
            AnhSP,
            MaNSX
        FROM SanPham
        WHERE TenSP LIKE @keyword
        ORDER BY TenSP";

                SqlCommand cmd = new SqlCommand(sql, conn);

                cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }

    }
}
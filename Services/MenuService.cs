using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using WebDienThoai.DAO;
using WebDienThoai.Models;

namespace WebDienThoai.Services
{
    public class MenuService
    {
        public List<MenuLoai> BuildMenu()
        {
            MenuDAO dao = new MenuDAO();
            DataTable dt = dao.GetMenuRaw();

            var menu = new List<MenuLoai>();

            foreach (DataRow row in dt.Rows)
            {
                int maLoai = row["MaLoai"] != DBNull.Value ? (int)row["MaLoai"] : 0;

                var loai = menu.Find(x => x.MaLoai == maLoai);
                if (loai == null)
                {
                    loai = new MenuLoai
                    {
                        MaLoai = maLoai,
                        TenLoai = row["TenLoai"].ToString()
                    };
                    menu.Add(loai);
                }

                // Thương hiệu
                if (row["MaNSX"] != DBNull.Value)
                {
                    int maNSX = (int)row["MaNSX"];
                    if (!loai.ThuongHieu.Exists(x => x.MaNSX == maNSX))
                    {
                        loai.ThuongHieu.Add(new MenuNSX
                        {
                            MaNSX = maNSX,
                            TenNSX = row["TenNSX"].ToString(),
                            Logo = row["Logo"].ToString(),
                            MaLoai = loai.MaLoai
                            
                        });
                    }
                }

                // SP nổi bật
                if (row["MaSP"] != DBNull.Value)
                {
                    int maSP = (int)row["MaSP"];
                    if (!loai.SanPhamNoiBat.Exists(x => x.MaSP == maSP))
                    {
                        loai.SanPhamNoiBat.Add(new MenuSP
                        {
                            MaSP = maSP,
                            TenSP = row["TenSP"].ToString(),
                            MaNSX = (int)row["MaNSX"]
                        });
                    }
                }
            }

            return menu;
        }
    }
}
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using WebDienThoai.DAO;

namespace WebDienThoai.Customer.Handler
{
    /// <summary>
    /// Summary description for SearchSuggest
    /// </summary>
    public class SearchSuggest : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string keyword = context.Request["q"];

            SanPhamDAO dao = new SanPhamDAO();

            DataTable dt = dao.SearchSuggest(keyword);

            var list = new System.Collections.Generic.List<object>();

            foreach (DataRow row in dt.Rows)
            {
                list.Add(new
                {
                    MaSP = row["MaSP"],
                    TenSP = row["TenSP"],
                    Gia = row["DonGia"],
                    Hinh = row["AnhSP"],
                    MaNhaSX = row["MaNSX"]
                });
            }

            JavaScriptSerializer js = new JavaScriptSerializer();

            context.Response.ContentType = "application/json";
            context.Response.Write(js.Serialize(list));
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
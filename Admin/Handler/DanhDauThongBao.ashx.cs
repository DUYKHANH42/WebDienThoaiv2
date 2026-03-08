using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using WebDienThoai.DAO;

namespace WebDienThoai.Admin.Handler
{
    /// <summary>
    /// Summary description for DanhDauThongBao
    /// </summary>
    public class DanhDauThongBao : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            int id = Convert.ToInt32(context.Session["id"]);

            ThongBaoDAO dao = new ThongBaoDAO();
            dao.DanhDauDaDoc(id);

            context.Response.ContentType = "application/json";
            context.Response.Write("{\"success\":true}");
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
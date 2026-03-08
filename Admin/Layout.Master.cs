using System;
using System.Linq;
using System.Web;
using System.Web.Services;
using WebDienThoai.DAO;
using WebDienThoai.Models;

namespace WebDienThoai
{
    public partial class Layout : System.Web.UI.MasterPage
    {
        TaiKhoanDAO tkDAO = new DAO.TaiKhoanDAO();
        public TaiKhoan tk;
        protected void Page_Load(object sender, EventArgs e)
        {
            tk = Session["TaiKhoan"] as TaiKhoan;
            if (Session["TaiKhoan"] == null)
            {
                Response.Redirect("../login.aspx");
                return;
            }
            if (Session["Role"] == null || (int)Session["Role"] != 1)
            {
                Response.Redirect("~/customer/index.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadThongBao();
            }
        }
        void LoadThongBao()
        {
            ThongBaoDAO dao = new ThongBaoDAO();
            var list = dao.GetThongBao(tk.Id);

            ulThongBao.InnerHtml = "";

            ulThongBao.InnerHtml += "<li class='px-3 py-2 fw-bold'>Thông báo</li>";
            ulThongBao.InnerHtml += "<li><hr class='dropdown-divider'></li>";

            // Nếu không có thông báo
            if (list == null || list.Count == 0)
            {
                ulThongBao.InnerHtml += @"
        <li class='px-3 py-3 text-center text-muted'>
            Không có thông báo
        </li>";

                spnThongBaoDot.Visible = false;
                return;
            }

            foreach (var tb in list)
            {
                string css = tb.DaDoc ? "" : "fw-bold bg-light";

                ulThongBao.InnerHtml += $@"
        <li>
           <div class='dropdown-item py-2 {css}'>
        <div>{tb.TieuDe}</div>
        <small class='text-muted'>{tb.NoiDung}</small><br>
        <small class='text-secondary'>{tb.NgayTao:dd/MM/yyyy HH:mm}</small>
    </div>
        </li>";
            }

            int chuaDoc = list.Count(x => !x.DaDoc);

            if (chuaDoc > 0)
                spnThongBaoDot.InnerText = chuaDoc.ToString();
            else
                spnThongBaoDot.Visible = false;
        }

     
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session["TaiKhoan"] = null;
            Session["MaKH"] = null;
            Response.Redirect(ResolveUrl("~/customer/default.aspx"));
        }
    }
}
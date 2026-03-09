using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Security.Principal;
using WebDienThoai.DAO;
using WebDienThoai.Helper;
using WebDienThoai.Models;

namespace WebDienThoai.Customer
{
    public partial class Layout : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TaiKhoan tk = Session["TaiKhoan"] as TaiKhoan;
            if (!IsPostBack)
            {
                try
                {
                    rptMenu.DataSource = MenuCache.GetMenu();
                    rptMenu.DataBind();
                }
                catch
                {
                    
                }
                if (tk != null)
                {
                    liLogin.Visible = false;
                    liUser.Visible = true;
                    spAccount.InnerText = tk.username;
                    LoadThongBao();
                    
                }
                else
                {
                    liLogin.Visible = true;
                    liUser.Visible = false;
                    btnThongBao.Visible = false;
                }
            }
        }
        void LoadThongBao()
        {
            ThongBaoDAO dao = new ThongBaoDAO();
            int id = Convert.ToInt32(Session["id"]);

            var list = dao.GetThongBao(id);

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
        public int CartCount
        {
            get
            {
                int total = 0;
                if (Session["Cart"] != null)
                {
                    List<CartItem> cart = (List<CartItem>)Session["Cart"];
                    foreach (CartItem c in cart)
                    {
                        total += c.SoLuong;
                    }
                }
                return total;
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session["TaiKhoan"] = null;
            Session["MaKH"] = null;
            Response.Redirect("default.aspx");
        }
    }
}
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;

namespace WebDienThoai.Admin
{
    public partial class Reviews : System.Web.UI.Page
    {
        DanhGiaDAO dao = new DanhGiaDAO();

        int pageSize = 2;
        int CurrentPage
        {
            get { return ViewState["CurrentPage"] == null ? 1 : (int)ViewState["CurrentPage"]; }
            set { ViewState["CurrentPage"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CurrentPage = 1;
                LoadReview();

            }

        }

        void LoadReview()
        {
            DanhGiaDAO dao = new DanhGiaDAO();

            string keyword = txtSearch.Text.Trim();

            int? soSao = null;
            if (!string.IsNullOrEmpty(ddlSao.SelectedValue))
                soSao = Convert.ToInt32(ddlSao.SelectedValue);

            DataTable dt = dao.FilterReview(keyword, soSao, CurrentPage, pageSize);

            rptReview.DataSource = dt;
            rptReview.DataBind();

            int total = dao.CountFilterReview(keyword, soSao);

            int start = ((CurrentPage - 1) * pageSize) + 1;
            int end = start + dt.Rows.Count - 1;

            ltrStart.Text = start.ToString();
            ltrEnd.Text = end.ToString();
            ltrTotal.Text = total.ToString();

            LoadPaging(total);
        }
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadReview();
        }
        void LoadPaging(int totalRecord)
        {
            int totalPage = (int)Math.Ceiling((double)totalRecord / pageSize);

            DataTable dt = new DataTable();
            dt.Columns.Add("PageNumber", typeof(int));
            dt.Columns.Add("IsCurrent", typeof(bool));

            for (int i = 1; i <= totalPage; i++)
            {
                dt.Rows.Add(i, i == CurrentPage);
            }

            rptPaging.DataSource = dt;
            rptPaging.DataBind();

            btnPrev.Enabled = CurrentPage > 1;
            btnNext.Enabled = CurrentPage < totalPage;
        }

        protected void rptPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "page")
            {
                CurrentPage = Convert.ToInt32(e.CommandArgument);
                LoadReview();
            }
        }
        protected void btnPrev_Click(object sender, EventArgs e)
        {
            CurrentPage--;
            LoadReview();
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            LoadReview();
        }
        public string RenderStar(object starObj)
        {
            int star = Convert.ToInt32(starObj);

            string html = "";

            for (int i = 1; i <= 5; i++)
            {
                if (i <= star)
                {
                    html += "<span class='material-symbols-outlined text-lg star-filled'>star</span>";
                }
                else
                {
                    html += "<span class='material-symbols-outlined text-lg'>star</span>";
                }
            }

            return html;
        }
    }
}
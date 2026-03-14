using iText.IO.Font;
using iText.IO.Font.Constants;
using iText.IO.Image;
using iText.Kernel.Colors;
using iText.Kernel.Font;
using iText.Kernel.Pdf;
using iText.Kernel.Pdf.Canvas;
using iText.Layout;
using iText.Layout.Borders;
using iText.Layout.Element;
using iText.Layout.Properties;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;
using Image = iText.Layout.Element.Image;
using Table = iText.Layout.Element.Table;

namespace WebDienThoai.Admin
{
    public partial class Orders : System.Web.UI.Page
    {

        DonHangDAO dao = new DonHangDAO();
        int pageSize = 5;

        public int CurrentPage
        {
            get { return ViewState["CurrentPage"] == null ? 1 : (int)ViewState["CurrentPage"]; }
            set { ViewState["CurrentPage"] = value; }
        }

        public int TotalPages
        {
            get { return ViewState["TotalPages"] == null ? 1 : (int)ViewState["TotalPages"]; }
            set { ViewState["TotalPages"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDuLieu();

            }

        }
        void LoadPager(int currentPage, int totalPage)
        {
            CurrentPage = currentPage;
            TotalPages = totalPage;

            rpPaging.DataSource = Enumerable.Range(1, totalPage)
                .Select(x => new
                {
                    Page = x,
                    Css = x == currentPage
                    ? "size-8 flex items-center justify-center rounded-lg bg-primary text-white font-black text-xs"
                    : "size-8 flex items-center justify-center rounded-lg text-slate-600 font-bold text-xs hover:bg-white"
                });

            rpPaging.DataBind();
        }
        protected void btnView_Command(object sender, CommandEventArgs e)
        {
            int orderID = Convert.ToInt32(e.CommandArgument);
            OpenOrderModal(orderID);
        }
        protected void OpenOrderModal(int orderID)
        {
            DataTable dt = dao.GetByID(orderID);
            DataTable dtItems = dao.GetOrderItems(orderID);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];

                hfOrderID.Value = row["SoDH"].ToString();

                litMaDonHang.Text = row["MaDonHang"].ToString();
                litTenKH.Text = row["TenNguoiNhan"].ToString();
                litSDT.Text = row["DienThoaiNhan"].ToString();
                litDiaChi.Text = row["DiaChiNhan"].ToString();
                litTongTien.Text = Convert.ToDecimal(row["TriGia"]).ToString("N0") + " ₫";

                ddlOrderStatus.SelectedValue = row["MaTrangThai"].ToString();
                rptOrderItems.DataSource = dtItems;
                rptOrderItems.DataBind();
                litThanhToan.Text =
                    $"<span class='badge bg-white text-primary rounded-pill px-3 py-1 border border-primary-subtle'>" +
                    $"{row["TenTrangThai"]} ({row["PhuongThucThanhToan"]})</span>";
                ScriptManager.RegisterStartupScript(this, this.GetType(),
    "openModal",
    "var myModal = new bootstrap.Modal(document.getElementById('modalOrderManager')); myModal.show();",
    true);
            }
        }

        private void LoadDuLieu(int page = 1, int maTrangThai = 0)
        {
            if (page < 1)
                page = 1;

            string search = ViewState["search"]?.ToString();
            string phuongThuc = ViewState["phuongThuc"]?.ToString();
            string ngay = ViewState["ngay"]?.ToString();

            int totalRow;

            DataTable dt;

            if (!string.IsNullOrEmpty(search) || !string.IsNullOrEmpty(phuongThuc) || !string.IsNullOrEmpty(ngay))
            {
                dt = dao.FilterDonHang(search, phuongThuc, ngay, page, pageSize, maTrangThai, out totalRow);
            }
            else
            {
                dt = dao.GetDonHangPaging(page, pageSize, maTrangThai, out totalRow);
            }

            rptDonHang.DataSource = dt;
            rptDonHang.DataBind();

            int totalPage = (int)Math.Ceiling((double)totalRow / pageSize);

            LoadPager(page, totalPage);
        }
        protected void rpPaging_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Page")
            {
                int page = int.Parse(e.CommandArgument.ToString());
                LoadDuLieu(page);
            }
        }
        protected void btnPrev_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1)
                LoadDuLieu(CurrentPage - 1);
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
                LoadDuLieu(CurrentPage + 1);
        }
        protected void UpdateStatus_Click(object sender, EventArgs e)
        {
            try
            {
                int orderID = int.Parse(hfOrderID.Value);
                int newStatus = int.Parse(ddlOrderStatus.SelectedValue);

                DonHangDAO dao = new DonHangDAO();
                dao.UpdateTrangThai(orderID, newStatus);

                LoadDuLieu();

                ScriptManager.RegisterStartupScript(this, GetType(),
                "success",
                @"
       var modalEl = document.getElementById('modalOrderManager');
var modal = bootstrap.Modal.getOrCreateInstance(modalEl);
modal.hide();

document.querySelectorAll('.modal-backdrop').forEach(function(el) {
    el.remove();
});
document.body.classList.remove('modal-open');
document.body.style = '';

        Swal.fire({
            toast: true,
            position: 'top-end',
            icon: 'success',
            title: 'Cập nhật thành công!',
            showConfirmButton: false,
            timer: 1200,
            timerProgressBar: true
        });
        ",
                true);
            }
            catch (Exception ex)
            {
                // Nếu lỗi thì hiện toast lỗi và KHÔNG đóng modal
                ScriptManager.RegisterStartupScript(this, GetType(),
                "error",
                $@"
        Swal.fire({{
            toast: true,
            position: 'top-end',
            icon: 'error',
            title: 'Có lỗi xảy ra!',
            text: '{ex.Message.Replace("'", "")}',
            showConfirmButton: false,
            timer: 2000
        }});
        ",
                true);
            }
        }
        protected void btnFilter_Click(object sender, EventArgs e)
        {

            string search = txtSearch.Text.Trim();
            string phuongThuc = ddlThanhToan.SelectedValue;
            string ngay = txtNgay.Text;

            ViewState["search"] = search;
            ViewState["phuongThuc"] = phuongThuc;
            ViewState["ngay"] = ngay;

            CurrentPage = 1;

            LoadDuLieu(CurrentPage);
        }
        private void SetActiveTab(LinkButton activeBtn)
        {
            btnAll.CssClass = "nav-link";
            btnAwaiting.CssClass = "nav-link";
            btnPending.CssClass = "nav-link";
            btnShipping.CssClass = "nav-link";
            btnCompleted.CssClass = "nav-link";
            btnCancelled.CssClass = "nav-link";

            activeBtn.CssClass = "nav-link active";
        }


        protected void Filter_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string statusStr = btn.CommandArgument;
            int status;

            if (!int.TryParse(statusStr, out status))
            {
                status = 0;
            }
            LoadDuLieu(1, status);
            SetActiveTab(btn);
        }
        protected void btnPrint_Click(object sender, EventArgs e)
        {
            try
            {
                int orderID = int.Parse(hfOrderID.Value);

                DataTable dt = dao.GetByID(orderID);
                DataTable dtItems = dao.GetOrderItems(orderID);
                DataRow row = dt.Rows[0];

                MemoryStream ms = new MemoryStream();

                PdfWriter writer = new PdfWriter(ms);
                PdfDocument pdf = new PdfDocument(writer);
                pdf.AddNewPage();

                Document doc = new Document(pdf);
                doc.SetMargins(30, 30, 30, 60);

                // ===== FONT =====
                string font = Server.MapPath("~/font/arial.ttf");
                string fontBold = Server.MapPath("~/font/arialbd.ttf");

                PdfFont normal = PdfFontFactory.CreateFont(font, PdfEncodings.IDENTITY_H);
                PdfFont bold = PdfFontFactory.CreateFont(fontBold, PdfEncodings.IDENTITY_H);

                Color mainColor = new DeviceRgb(66, 102, 255);

                // ===== THANH MÀU TRÁI =====
                PdfCanvas canvas = new PdfCanvas(pdf.GetFirstPage());
                canvas.SetFillColor(mainColor);
                canvas.Rectangle(0, 0, 40, pdf.GetDefaultPageSize().GetHeight());
                canvas.Fill();

                // ===== HEADER =====
                Table header = new Table(new float[] { 6, 2 });
                header.SetWidth(UnitValue.CreatePercentValue(100));

                Paragraph title = new Paragraph("HÓA ĐƠN")
                    .SetFont(bold)
                    .SetFontSize(26)
                    .SetFontColor(mainColor);

                header.AddCell(new Cell().Add(title).SetBorder(Border.NO_BORDER));

                Paragraph logoText = new Paragraph("113 MOBILE")
                    .SetFont(bold)
                    .SetFontSize(14)
                    .SetFontColor(mainColor)
                    .SetTextAlignment(TextAlignment.RIGHT);

                header.AddCell(new Cell().Add(logoText).SetBorder(Border.NO_BORDER));

                doc.Add(header);
                doc.Add(new Paragraph("\n"));

                // ===== CUSTOMER INFO =====
                Table info = new Table(2);
                info.SetWidth(UnitValue.CreatePercentValue(100));

                info.AddCell(
                    new Cell().Add(
                        new Paragraph("Điện thoại khách hàng: " + row["DienThoaiNhan"])
                        .SetFont(normal)
                        .SetFontColor(ColorConstants.BLACK)
                    ).SetBorder(Border.NO_BORDER)
                );

                info.AddCell(new Cell().Add(new Paragraph("")).SetBorder(Border.NO_BORDER));

                info.AddCell(
                    new Cell().Add(
                        new Paragraph("Địa chỉ khách hàng: " + row["DiaChiNhan"])
                        .SetFont(normal)
                        .SetFontColor(ColorConstants.BLACK)
                    ).SetBorder(Border.NO_BORDER)
                );

                doc.Add(info);
                doc.Add(new Paragraph("\n"));

                // ===== TABLE =====
                Table table = new Table(new float[] { 2, 4, 2, 2, 2 });
                table.SetWidth(UnitValue.CreatePercentValue(100));
                table.SetMarginTop(15);
                table.SetFontSize(11);

                Cell h1 = new Cell().Add(new Paragraph("Ảnh").SetFont(bold));
                h1.SetBackgroundColor(new DeviceRgb(240, 240, 240));
                table.AddHeaderCell(h1);

                table.AddHeaderCell(new Cell().Add(new Paragraph("Mục").SetFont(bold)));
                table.AddHeaderCell(new Cell().Add(new Paragraph("Số lượng").SetFont(bold)));
                table.AddHeaderCell(new Cell().Add(new Paragraph("Đơn giá").SetFont(bold)));
                table.AddHeaderCell(new Cell().Add(new Paragraph("Thành tiền").SetFont(bold)));

                foreach (DataRow item in dtItems.Rows)
                {
                    string imgPath = Server.MapPath("~/imgs/" + item["AnhSP"]);
                    Image img = new Image(ImageDataFactory.Create(imgPath));
                    img.SetWidth(30);
                    img.SetAutoScale(true);

                    table.AddCell(new Cell().Add(img));

                    table.AddCell(
                        new Cell().Add(
                            new Paragraph(item["TenSP"] + "\n" + item["TenMau"])
                            .SetFont(normal)
                            .SetFontColor(ColorConstants.BLACK)
                        )
                    );

                    table.AddCell(
                        new Cell().Add(
                            new Paragraph(item["SoLuong"].ToString())
                            .SetFont(normal)
                            .SetFontColor(ColorConstants.BLACK)
                        ).SetTextAlignment(TextAlignment.CENTER)
                    );

                    table.AddCell(
                        new Cell().Add(
                            new Paragraph(Convert.ToDecimal(item["DonGia"]).ToString("N0") + "đ")
                            .SetFont(normal)
                            .SetFontColor(ColorConstants.BLACK)
                        ).SetTextAlignment(TextAlignment.RIGHT)
                    );

                    table.AddCell(
                        new Cell().Add(
                            new Paragraph(Convert.ToDecimal(item["ThanhTien"]).ToString("N0") + "đ")
                            .SetFont(normal)
                            .SetFontColor(ColorConstants.BLACK)
                        ).SetTextAlignment(TextAlignment.RIGHT)
                    );
                }

                doc.Add(table);
                doc.Add(new Paragraph("\n"));

                // ===== TOTAL =====
                decimal total = Convert.ToDecimal(row["TriGia"]);

                Paragraph totalText = new Paragraph("TỔNG TIỀN: " + total.ToString("N0") + "đ")
                    .SetFont(bold)
                    .SetFontSize(16)
                    .SetFontColor(mainColor)
                    .SetTextAlignment(TextAlignment.RIGHT);

                doc.Add(totalText);
                doc.Add(new Paragraph("\n\n"));

                // ===== FOOTER =====
                Table footer = new Table(3);
                footer.SetWidth(UnitValue.CreatePercentValue(100));

                footer.AddCell(new Cell().Add(new Paragraph("Xin cảm ơn!").SetFont(normal).SetFontColor(ColorConstants.BLACK)).SetBorder(Border.NO_BORDER));

                footer.AddCell(new Cell().Add(
                    new Paragraph("Thông tin Ngân hàng\nNgân hàng Nam Á\nSố tài khoản: 1234567890")
                    .SetFont(normal).SetFontColor(ColorConstants.BLACK)
                ).SetBorder(Border.NO_BORDER));

                footer.AddCell(new Cell().Add(
                    new Paragraph("113mobile.somee.com\n+84 912 345 678\nThành Phố Hồ Chí Minh, Việt Nam")
                    .SetFont(normal).SetFontColor(ColorConstants.BLACK)
                ).SetBorder(Border.NO_BORDER));

                doc.Add(footer);

                doc.Close();

                byte[] bytes = ms.ToArray();

                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", "attachment;filename=HoaDon.pdf");
                Response.BinaryWrite(bytes);
                Response.Flush();
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Lỗi tạo PDF: " + ex.Message.Replace("'", "") + "')</script>");
            }
        }
    }

}

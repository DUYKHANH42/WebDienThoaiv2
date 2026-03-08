using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;
using WebDienThoai.Models;

namespace WebDienThoai.Admin
{
    public partial class Product : System.Web.UI.Page
    {
        SanPhamDAO dao = new SanPhamDAO();
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

        int pageSize = 5;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData(1);
            }
        }
        private List<SanPham> Paging(List<SanPham> data, int page, int pageSize)
        {
            return data
                .OrderByDescending(x => x.MaSP)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();
        }
        private List<SanPham> FilterData(List<SanPham> data)
        {
            string ten = txtTenSP.Text.Trim().ToLower();
            string loai = ddlLoai.SelectedValue;
            string nsx = ddlNSX.SelectedValue;

            if (!string.IsNullOrEmpty(ten))
                data = data.Where(x => x.TenSP.ToLower().Contains(ten)).ToList();

            if (!string.IsNullOrEmpty(loai))
                data = data.Where(x => x.MaLoai == int.Parse(loai)).ToList();

            if (!string.IsNullOrEmpty(nsx))
                data = data.Where(x => x.MaNSX == int.Parse(nsx)).ToList();

            return data;
        }

        void LoadData(int page = 1)
        {
            int pageSize = 8;

            var data = dao.GetAllSanPham();

            // filter
            data = FilterData(data);

            // total page
            int totalPage = (int)Math.Ceiling((double)data.Count / pageSize);
            ViewState["TotalPage"] = totalPage;

            // paging
            var pageData = Paging(data, page, pageSize);

            lvSanPham.DataSource = pageData;
            lvSanPham.DataBind();

            LoadPager(page, totalPage);
        }

        void LoadPager(int currentPage, int totalPage)
        {
            CurrentPage = currentPage;
            TotalPages = totalPage;

            rpPager.DataSource = Enumerable.Range(1, totalPage)
                                           .Select(x => new { Page = x });
            rpPager.DataBind();
        }

        protected void rpPager_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Page")
            {
                int page = int.Parse(e.CommandArgument.ToString());
                LoadData(page);
            }
        }
        protected void Prev_Click(object sender, EventArgs e)
        {
            LoadData(CurrentPage - 1);
        }


        protected void btnSearch_Click(object sender, EventArgs e)
        {
            CurrentPage = 1;
            LoadData();
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            if (CurrentPage < TotalPages)
                LoadData(CurrentPage + 1);
        }

        protected void lvSanPham_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "editSP")
            {
                int maSP = Convert.ToInt32(e.CommandArgument);

                SanPham sanPhams = dao.GetSPByID(maSP);

                txtEditTenSP.Text = sanPhams.TenSP;
                txtEditMoTa.Text = sanPhams.MoTa;
                hdMaSP.Value = sanPhams.MaSP.ToString();
                ddlEditLoai.SelectedValue = sanPhams.MaLoai.ToString();
                ddlEditNSX.SelectedValue = sanPhams.MaNSX.ToString();
                txtEditDungLuong.Text = sanPhams.DungLuong;
                txtEditThiTruong.Text = sanPhams.ThiTruong;
                txtEditTonKho.Text = sanPhams.TonKho.ToString();
                txtEditDonGia.Text = sanPhams.DonGia.ToString();
                // LOAD ẢNH
                rpHinhAnh.DataSource = dao.GetListHinh(maSP);
                rpHinhAnh.DataBind();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "open", "openEditModal();", true);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                int maSP = int.Parse(hdMaSP.Value);

                // ===== 1. UPDATE SẢN PHẨM =====
                SanPham sp = new SanPham()
                {
                    MaSP = maSP,
                    TenSP = txtEditTenSP.Text.Trim(),
                    MoTa = txtEditMoTa.Text.Trim(),
                    MaLoai = int.Parse(ddlEditLoai.SelectedValue),
                    MaNSX = int.Parse(ddlEditNSX.SelectedValue),
                    DungLuong = txtEditDungLuong.Text.Trim(),
                    ThiTruong = txtEditThiTruong.Text.Trim(),
                    TonKho = int.Parse(txtEditTonKho.Text.Trim()),
                    DonGia = decimal.Parse(txtEditDonGia.Text.Trim())
                };

                if (!dao.UpdateSanPham(sp))
                    throw new Exception("Không cập nhật được sản phẩm");

                // ===== 2. XÓA ẢNH =====
                foreach (RepeaterItem item in rpHinhAnh.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chkXoa");
                    HiddenField hd = (HiddenField)item.FindControl("hdMaHinh");

                    if (chk != null && hd != null && chk.Checked)
                    {
                        int maHinh = int.Parse(hd.Value);
                        dao.DeleteHinh(maHinh);
                    }
                }


                // ===== 3. THÊM ẢNH MỚI =====
                if (fuHinhMoi.HasFiles)
                {
                    string folder = Server.MapPath("~/imgs/");

                    if (!System.IO.Directory.Exists(folder))
                        System.IO.Directory.CreateDirectory(folder);

                    foreach (HttpPostedFile file in fuHinhMoi.PostedFiles)
                    {
                        if (file.ContentLength == 0) continue;

                        string ext = System.IO.Path.GetExtension(file.FileName).ToLower();

                        // chặn file không phải ảnh
                        if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp")
                            throw new Exception("Chỉ được upload file ảnh (jpg, png, webp)");

                        string fileName = Guid.NewGuid() + ext;
                        string path = System.IO.Path.Combine(folder, fileName);

                        file.SaveAs(path);

                        dao.InsertHinh(maSP, fileName);
                    }
                }

                // reload
                LoadData(CurrentPage);
                ScriptManager.RegisterStartupScript(
    upProduct,
    upProduct.GetType(),
    "close",
    "setTimeout(function(){closeEditModal();},100);Swal.fire('Thành công','Đã cập nhật sản phẩm','success');",
    true
);
            }
            catch (FormatException)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                    "err", "Swal.fire('Lỗi','Giá tiền không hợp lệ','error');", true);
            }
            catch (UnauthorizedAccessException)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                    "err", "Swal.fire('Lỗi quyền','Thư mục /imgs không có quyền ghi','error');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                    "err", $"Swal.fire('Lỗi','{ex.Message}','error');", true);
            }
        }

    
    [WebMethod]
        public static object DeleteSP(int id)
        {
            try
            {
                SanPhamDAO dao = new SanPhamDAO();
                dao.DeleteFullSanPham(id);

                return new { success = true };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }
    }
    }
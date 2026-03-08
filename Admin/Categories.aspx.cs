using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebDienThoai.DAO;

namespace WebDienThoai.Admin
{
    public partial class Categories : System.Web.UI.Page
    {
        DanhMucDAO dmdao = new DanhMucDAO();
        
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void lvLoai_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "editLoai")
            {
                int maLoai = Convert.ToInt32(e.CommandArgument);

                DanhMuc dm = dmdao.GetByID(maLoai);

                hfMaLoai.Value = dm.maLoai.ToString();
                txtTenDanhMuc.Text = dm.TenLoai;

                // MỞ MODAL SAU POSTBACK
                ScriptManager.RegisterStartupScript(this, this.GetType(),
                    "openModal",
                    "$('#modalEditDM').modal('show');",
                    true);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int maloai = int.Parse(hfMaLoai.Value);
            string tenloai = txtTenDanhMuc.Text;
            DanhMuc md = new DanhMuc();
            md.maLoai = maloai;
            md.TenLoai = tenloai;
            bool rs = dmdao.UpdateDanhMuc(md);
            if (rs)
            {
                lvLoai.DataBind();
                ScriptManager.RegisterStartupScript(this, this.GetType(),
     "updateSuccess",
     @"
        var modalEl = document.getElementById('modalEditDM');
        var modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) { modal.hide(); }

        setTimeout(function(){
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'success',
                title: 'Cập nhật thành công!',
                showConfirmButton: false,
                timer: 1000,
                timerProgressBar: true
            });
        }, 300);
    ",
     true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(),
     "updateFail",
     @"
        setTimeout(function(){
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'error',
                title: 'Cập nhật thất bại!',
                showConfirmButton: false,
                timer: 1500,
                timerProgressBar: true
            });
        }, 300);
    ",
     true);
            }
        }
    }
}
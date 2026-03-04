using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebDienThoai.Customer
{
    public partial class CustomerSidebar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session["TaiKhoan"] = null;
            Session["Role"] = null;
            Session["id"] = null;
            Session["MaKH"] = null;
            Response.Redirect("default.aspx");
        }
        public FileUpload AvatarUpload
        {
            get
            {
                if (fvAvatar.Row != null)
                    return (FileUpload)fvAvatar.FindControl("fuAvatar");
                return null;
            }
        }
    }
}
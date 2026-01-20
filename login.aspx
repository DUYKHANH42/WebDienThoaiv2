<%@ Page Title="" Language="C#" MasterPageFile="~/02.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WebDienThoai.login" %>
<asp:Content ID="Login" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="container mt-5 ">
     <div class="row justify-content-center">
         <div class="col-md-5">

             <div class="card shadow rounded-4">
                 <div class="card-body p-4">

                     <h3 class="text-center fw-bold mb-3" style="font-family:roboto">ĐĂNG NHẬP
                     </h3>
                     <div class="mb-3">
                         <asp:Label ID="Label1"
                             runat="server"
                             CssClass="form-label"
                             Text="Tên đăng nhập" />
                         <asp:RequiredFieldValidator ID="refTenDN"
                         runat="server" ControlToValidate="txtTenDN"
                         Display="Dynamic" ErrorMessage="Vui lòng không để trống tên đăng nhập" ForeColor="Red">*</asp:RequiredFieldValidator>
                         <asp:TextBox ID="txtTenDN"
                             runat="server"
                             CssClass="form-control"
                             Placeholder="abc" />
                     </div>
                     <div class="mb-3">
                         <asp:Label ID="Label2"
                             runat="server"
                             CssClass="form-label"
                             Text="Mật khẩu" />
                         <asp:RequiredFieldValidator ID="refPassword"
                             runat="server" ControlToValidate="txtPassword"
                             Display="Dynamic" ErrorMessage="Vui lòng không để trống mật khẩu" ForeColor="Red">*</asp:RequiredFieldValidator>
                         <asp:CustomValidator 
                             ID="cvLogin"
                             runat="server"
                             ErrorMessage="Sai tên đăng nhập hoặc mật khẩu"
                             Display="None" />
                         <asp:TextBox ID="txtPassword"
                             runat="server"
                             CssClass="form-control"
                             TextMode="Password"
                             Placeholder="" />
                     </div>
                     <div class="d-grid mb-3">
                         <asp:ValidationSummary ID="vsLoi"  runat="server" DisplayMode="List" ForeColor="Red" />
                         
                         </div>
                     <div class="d-grid mb-3">
                         <asp:Button ID="btnDangNhap"
                             runat="server"
                             CssClass="btn btn-info rounded-3"
                             Text="Đăng Nhập" OnClick="btnDangNhap_Click"
                              />
                     </div>

                     <div class="text-center">
                         <span>Chưa có tài khoản?</span>
                         <asp:HyperLink ID="lnkDangKy"
                             runat="server"
                             NavigateUrl="register.aspx"
                             CssClass="fw-bold text-decoration-none ms-1">
                             Đăng ký
                         </asp:HyperLink>
                     </div>

                 </div>
             </div>

         </div>
     </div>
 </div>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/02.Master" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="WebDienThoai.register" %>
<asp:Content ID="register" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow rounded-4">
                    <div class="card-body p-4">

                        <h3 class="text-center fw-bold mb-3" style="font-family: roboto">ĐĂNG KÝ
                        </h3>
                        <div class="mb-3">
                            <asp:Label ID="Label3"
                                runat="server"
                                CssClass="form-label"
                                Text="Họ tên" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                runat="server" ControlToValidate="txtHoten"
                                Display="Dynamic" ErrorMessage="Vui lòng không để trống họ tên" ForeColor="Red">*</asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtHoten"
                                runat="server"
                                CssClass="form-control"
                                Placeholder="abc" />
                        </div>
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
                            <asp:TextBox ID="txtPassword"
                                runat="server"
                                CssClass="form-control"
                                TextMode="Password"
                                Placeholder="" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="Label4"
                                runat="server"
                                CssClass="form-label"
                                Text=" Nhập Lại Mật khẩu" />
                            <asp:RequiredFieldValidator ID="reftxtnhaplaiPass"
                                runat="server" ControlToValidate="txtNhapLaiPass"
                                Display="Dynamic" ErrorMessage="Vui lòng nhập lại mật khẩu" ForeColor="Red">*</asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="cvMatKhau" runat="server" ErrorMessage="Mật khẩu không khớp" ControlToCompare="txtNhapLaiPass" ControlToValidate="txtPassword" Display="Dynamic" ForeColor="Red">*</asp:CompareValidator>
                            <asp:TextBox ID="txtNhapLaiPass"
                                runat="server"
                                CssClass="form-control"
                                TextMode="Password"
                                Placeholder="" />
                        </div>
                        <div class="d-grid mb-3">
                            <asp:ValidationSummary ID="vsLoi" runat="server" DisplayMode="List" ForeColor="Red" />

                        </div>
                        <div class="mb-3">
                            <asp:Label ID="Label6"
                                runat="server"
                                CssClass="form-label"
                                Text="Email" />
                              <asp:RequiredFieldValidator ID="refEmail"
      runat="server" ControlToValidate="txtEmail"
      Display="Dynamic" ErrorMessage="Vui lòng nhập email" ForeColor="Red">*</asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtEmail"
                                runat="server"
                                CssClass="form-control"
                                TextMode="Email"
                                Placeholder="" />

                        </div>
                        <div class="mb-3">
                            <asp:Label ID="Label8"
                                runat="server"
                                CssClass="form-label"
                                Text="Địa chỉ" />
                            <asp:TextBox ID="txtDiaChi"
                                runat="server"
                                CssClass="form-control"
                                TextMode="SingleLine"
                                Placeholder="" />
                        </div>
                        <div class="mb-3">
                            <asp:Label ID="Label7"
                                runat="server"
                                CssClass="form-label"
                                Text="Số điện thoại" />
                            <asp:TextBox ID="txtSDT"
                                runat="server"
                                CssClass="form-control"
                                TextMode="Number"
                                Placeholder="" />
                        </div>
                        <div class="d-grid mb-3">
                            <asp:Button ID="btnDangKy"
                                runat="server"
                                CssClass="btn btn-info rounded-3"
                                Text="Đăng Ký" OnClick="btnDangKy_Click" />
                        </div>

                        <div class="text-center">
                            <span>Đã có tài khoản?</span>
                            <asp:HyperLink ID="lnkDangNhap"
                                runat="server"
                                NavigateUrl="DangNhap.aspx"
                                CssClass="fw-bold text-decoration-none ms-1">
                            Đăng nhập
                            </asp:HyperLink>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>
    
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<%@ Page Title="Trang cá nhân" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="WebDienThoai.Customer.Profile" %>
<%@ Register Src="~/Customer/CustomerSidebar.ascx" 
    TagPrefix="uc" 
    TagName="Sidebar" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
   
    <div class="profile-container">
        <div class="container">
            <div class="row g-4">
                <!-- Sidebar -->
              <uc:Sidebar id="Sidebar1" runat="server" />
                <!-- Main Content -->
                <div class="col-lg-9">
                    <div class="profile-card shadow-sm profile-content h-100">
                        <div class="d-flex justify-content-between align-items-center mb-5">
                            <h4 class="fw-bold mb-0">Hồ sơ cá nhân</h4>
                            <p class="text-muted small mb-0">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                        </div>
                        <asp:FormView ID="fvProfile" runat="server"
                            DataSourceID="ProFile"
                            RenderOuterTable="false">

                            <ItemTemplate>

                                <div class="row g-4">

                                    <div class="col-md-6">
                                        <label class="form-label-custom">Tên đăng nhập</label>
                                        <asp:TextBox runat="server"
                                            CssClass="form-control form-control-custom"
                                            Text='<%# Eval("username") %>'
                                            ReadOnly="true" />
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label-custom">Họ và tên</label>
                                        <asp:TextBox ID="txtEditTenKH" runat="server"
                                            CssClass="form-control form-control-custom"
                                            Text='<%# Bind("TenKH") %>' />
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label-custom">Email</label>
                                        <asp:TextBox ID="txtEditEmail" runat="server"
                                            CssClass="form-control form-control-custom"
                                            Text='<%# Bind("Email") %>' />
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label-custom">Số điện thoại</label>
                                        <asp:TextBox ID="txtEditDienThoai" runat="server"
                                            CssClass="form-control form-control-custom"
                                            Text='<%# Bind("DienThoai") %>' />
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label-custom">Ngày sinh</label>
                                        <asp:TextBox ID="txtEditNgaySinh" runat="server"
                                            CssClass="form-control form-control-custom"
                                            TextMode="Date"
                                            Text='<%# Bind("NgaySinh", "{0:yyyy-MM-dd}") %>' />
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label-custom">Giới tính</label>

                                        <div class="d-flex gap-4 mt-2">

                                            <div class="form-check">
                                                <asp:RadioButton ID="rbMale" runat="server"
                                                    GroupName="Gender"
                                                    CssClass="form-check-input"
                                                    Checked='<%# Bind("GioiTinh") %>' />
                                                <label class="form-check-label ms-1">Nam</label>
                                            </div>

                                            <div class="form-check">
                                                <asp:RadioButton ID="rbFemale" runat="server"
                                                    GroupName="Gender"
                                                    CssClass="form-check-input"
                                                    Checked='<%# !Convert.ToBoolean(Eval("GioiTinh")) %>' />
                                                <label class="form-check-label ms-1">Nữ</label>
                                            </div>

                                        </div>
                                    </div>

                                </div>

                            </ItemTemplate>

                        </asp:FormView>
                        <div class="mt-5 pt-4 border-top text-end">
                            <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Lưu thay đổi" CssClass="btn btn-primary btn-save" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <asp:SqlDataSource ID="ProFile" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="
        SELECT *
        FROM TaiKhoan tk
        INNER JOIN KhachHang kh ON tk.MaKH = kh.MaKH
        WHERE tk.id = @id">

        <SelectParameters>
            <asp:SessionParameter Name="id" SessionField="id" Type="Int32" />
        </SelectParameters>

    </asp:SqlDataSource>
</asp:Content>


<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomerSidebar.ascx.cs" Inherits="WebDienThoai.Customer.CustomerSidebar" %>

<div class="col-lg-3">
    <div class="profile-card shadow-sm profile-sidebar">

        <asp:FormView ID="fvAvatar" runat="server"
            DataSourceID="ProFile"
            RenderOuterTable="false">

            <ItemTemplate>
                <div class="text-center mb-4">
                    <div class="avatar-wrapper">
                        <img
                            src='<%# string.IsNullOrEmpty(Eval("AvtUrl").ToString()) 
                            ? "../imgs/default-avatar.png" 
                            : "../imgs/" + Eval("AvtUrl") %>'
                            id="imgPreview"
                            class="avatar-img"
                            alt="User Avatar" />

                        <label class="upload-btn">
                            <i class="fas fa-camera"></i>
                            <asp:FileUpload
                                ID="fuAvatar"
                                runat="server"
                                CssClass="d-none"
                                onchange="previewImage(this)" />
                        </label>
                    </div>
                </div>
            </ItemTemplate>
        </asp:FormView>

        <div class="nav-links mt-4">
            <a href="Profile.aspx" class="nav-profile-link"><i class="fas fa-user-circle"></i>Thông tin cá nhân</a>
            <a href="DonHang.aspx" class="nav-profile-link"><i class="fas fa-shopping-bag"></i>Đơn hàng của tôi</a>
            <a href="CartList.aspx" class="nav-profile-link"><i class="fas fa-heart"></i>Giỏ hàng của tôi</a>
            <a href="ChangePassword.aspx" class="nav-profile-link"><i class="fas fa-shield-alt"></i>Bảo mật & Mật khẩu</a>

            <hr class="opacity-10">

            <asp:LinkButton ID="btnLogout" runat="server"
                OnClick="btnLogout_Click"
                CssClass="nav-profile-link text-danger">
                <i class="fas fa-sign-out-alt"></i>Đăng xuất
            </asp:LinkButton>
        </div>

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

    </div>
</div>
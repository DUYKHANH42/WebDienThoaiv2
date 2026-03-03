<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="Product.aspx.cs" Inherits="WebDienThoai.Admin.Product" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Quản Lý Sản Phẩm</h2>
    <asp:HyperLink runat="server" Text="Thêm Sản Phẩm" ID="btnThemMoi"
        CssClass="btn btn-success mt-2 mb-2 w-10"
        NavigateUrl="AddProduct.aspx"></asp:HyperLink>
    <div class="row mb-3">
        <div class="col-md-4">
            <asp:TextBox ID="txtTenSP" runat="server"
                CssClass="form-control"
                placeholder="Nhập tên sản phẩm..." />
        </div>

        <div class="col-md-3">
            <asp:DropDownList ID="ddlLoai" runat="server"
                CssClass="form-select"
                DataSourceID="dsLoai"
                DataTextField="TenLoai"
                DataValueField="MaLoai"
                AppendDataBoundItems="true" AutoPostBack="false">
                <asp:ListItem Value="">-- Tất cả loại --</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="col-md-3">
            <asp:DropDownList ID="ddlNSX" runat="server"
                CssClass="form-select"
                DataSourceID="dsNSX"
                DataTextField="TenNSX"
                DataValueField="MaNSX"
                AppendDataBoundItems="true">
                <asp:ListItem Value="">-- Tất cả NSX --</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="col-md-2">
            <asp:Button ID="btnSearch" OnClick="btnSearch_Click" runat="server"
                Text="Tìm kiếm"
                CssClass="btn btn-primary w-100" />
        </div>
    </div>
    <asp:UpdatePanel ID="upProduct" runat="server">
<ContentTemplate>
    <asp:ListView ID="lvSanPham" runat="server" OnItemCommand="lvSanPham_ItemCommand" >
        <LayoutTemplate>
            <table class="table table-bordered table-hover text-center align-middle">
                <thead class="table-light text-nowrap">
                    <tr>
                        <th>Hình Ảnh</th>
                        <th>Tên Sản Phẩm</th>
                        <th>Loại Danh Mục</th>
                        <th>Nhà SX</th>
                        <th>Ngày mở bán</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                </tbody>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr data-id='<%# Eval("MaSP") %>'>
                <td style="width: 120px">
                    <img src="../imgs/<%# Eval("AnhSP") %>"
                        class="img-fluid rounded"
                        style="width: 80px; height: 80px; object-fit: cover" />
                </td>
                <td class="text-start"><%# Eval("TenSP") %></td>
                <td><%# Eval("TenLoai") %></td>
                <td><%# Eval("TenNSX") %></td>
                <td><%# Eval("NgayCapNhat","{0:dd/MM/yyyy}") %></td>
                <td>
                    <asp:Button runat="server"
    Text="Cập nhật"
    CssClass="btn btn-success btn-sm"
    CommandName="editSP"
    CommandArgument='<%# Eval("MaSP") %>' />
                <asp:LinkButton runat="server"
    CssClass="btn btn-danger btn-sm"
    OnClientClick='<%# "return deleteSP(" + Eval("MaSP") + ");" %>'>
    Xóa
</asp:LinkButton>
                </td>
            </tr>
        </ItemTemplate>
    </asp:ListView>
     <nav class="d-flex justify-content-center mt-3">
    <ul class="pagination">
        <li class="page-item <%= CurrentPage == 1 ? "disabled" : "" %>">
            <asp:LinkButton runat="server" CssClass="page-link"
    Enabled="<%# CurrentPage > 1 %>"
    OnClick="Prev_Click">«</asp:LinkButton>
        </li>

        <asp:Repeater ID="rpPager" runat="server" OnItemCommand="rpPager_ItemCommand">
    <ItemTemplate>
        <li class='page-item <%# (int)Eval("Page") == CurrentPage ? "active" : "" %>'>
            <asp:LinkButton 
                runat="server"
                CssClass="page-link"
                CommandName="Page"
                CommandArgument='<%# Eval("Page") %>'>
                <%# Eval("Page") %>
            </asp:LinkButton>
        </li>
    </ItemTemplate>
</asp:Repeater>
<li class="page-item">
    <asp:LinkButton ID="btnNext" runat="server"
        CssClass="page-link"
        OnClick="btnNext_Click">»</asp:LinkButton>
</li>
    </ul>
</nav>
    
<div class="modal fade" id="modalEdit" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Cập nhật sản phẩm</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">

                <asp:HiddenField ID="hdMaSP" runat="server" />

                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label">Tên sản phẩm</label>
                        <asp:TextBox ID="txtEditTenSP" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Loại</label>
                        <asp:DropDownList ID="ddlEditLoai" runat="server"
                            CssClass="form-select"
                            DataSourceID="dsLoai"
                            DataTextField="TenLoai"
                            DataValueField="MaLoai">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Nhà sản xuất</label>
                        <asp:DropDownList ID="ddlEditNSX" runat="server"
                            CssClass="form-select"
                            DataSourceID="dsNSX"
                            DataTextField="TenNSX"
                            DataValueField="MaNSX">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Dung lượng</label>
                        <asp:TextBox ID="txtEditDungLuong" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Thị trường</label>
                        <asp:TextBox ID="txtEditThiTruong" runat="server" CssClass="form-control" />
                    </div>

                    <div class="col-md-12">
                        <label class="form-label">Mô tả</label>
                        <asp:TextBox ID="txtEditMoTa" runat="server"
                            TextMode="MultiLine"
                            Rows="3"
                            CssClass="form-control" />
                    </div>
<div class="col-md-12">
    <label class="form-label">Ảnh sản phẩm</label>
    <asp:FileUpload ID="fuHinhMoi" runat="server" CssClass="form-control" AllowMultiple="true" />

    <hr />
    <asp:Repeater ID="rpHinhAnh" runat="server">
    <ItemTemplate>
        <div class="position-relative d-inline-block m-2 border rounded shadow-sm p-2 bg-white img-item">

            <img src="/imgs/<%# Eval("TenHinh") %>"
                class="rounded"
                style="width:100px;height:100px;object-fit:cover;" />

            <!-- giữ ID ảnh -->
            <asp:HiddenField ID="hdMaHinh"
                runat="server"
                Value='<%# Eval("MaHinh") %>' />

            <!-- checkbox server -->
            <asp:CheckBox ID="chkXoa"
                runat="server"
                CssClass="d-none" />

            <!-- nút UI -->
            <button type="button"
                class="btn btn-sm position-absolute top-0 end-0 translate-middle rounded-circle p-1 btn-delete-img"
                onclick="toggleDelete(this)">
                <i class="bi bi-x-circle-fill"></i>
            </button>

        </div>
    </ItemTemplate>
</asp:Repeater>


</div>

                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <asp:Button ID="btnUpdate" runat="server"
                    Text="Lưu thay đổi"
                    CssClass="btn btn-primary" OnClick="btnUpdate_Click" />
            </div>

        </div>
    </div>
</div>
    </ContentTemplate>
        <Triggers>
    <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
            <asp:PostBackTrigger ControlID="btnUpdate" />
</Triggers>


    </asp:UpdatePanel>


    <asp:SqlDataSource ID="dsSanPham" runat="server" ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        ProviderName="<%$ ConnectionStrings:DienThoaiDBConnectionString.ProviderName %>"
        SelectCommand="SELECT SanPham.* ,tenloai, tennsx FROM [SanPham]
                         inner join NhaSanXuat on  sanpham.mansx = nhasanxuat.mansx
                         inner join loaisp on  sanpham.maloai = loaisp.maloai
                            WHERE DaXoa = 0"></asp:SqlDataSource>
    <asp:SqlDataSource ID="dsLoai" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM LoaiSP" />

    <asp:SqlDataSource ID="dsNSX" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM NhaSanXuat" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
       
    </script>
</asp:Content>

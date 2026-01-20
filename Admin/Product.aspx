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
                AppendDataBoundItems="true">
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
            <asp:Button ID="btnSearch" runat="server"
                Text="Tìm kiếm"
                CssClass="btn btn-primary w-100" />
        </div>
    </div>
    <asp:ListView ID="lvSanPham" runat="server" DataSourceID="dsSanPham">
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
            <tr>
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
                    <asp:Button runat="server" Text="Cập nhật"
                        CssClass="btn btn-success btn-sm" />
                    <asp:Button runat="server" Text="Xóa"
                        CssClass="btn btn-danger btn-sm" />
                </td>
            </tr>
        </ItemTemplate>
    </asp:ListView>
    <nav class="d-flex justify-content-center mt-3">
        <div class="pagination">
            <asp:DataPager ID="DataPagerSP" runat="server"
                PagedControlID="lvSanPham"
                PageSize="5">
                <Fields>
                <asp:NumericPagerField
                    ButtonCount="5"
                    RenderNonBreakingSpacesBetweenControls="false" />
                </Fields>
            </asp:DataPager>
        </div>
    </nav>

    <asp:SqlDataSource ID="dsSanPham" runat="server" ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        ProviderName="<%$ ConnectionStrings:DienThoaiDBConnectionString.ProviderName %>"
        SelectCommand="SELECT SanPham.* ,tenloai, tennsx FROM [SanPham]
                         inner join NhaSanXuat on  sanpham.mansx = nhasanxuat.mansx
                         inner join loaisp on  sanpham.maloai = loaisp.maloai"></asp:SqlDataSource>
    <asp:SqlDataSource ID="dsLoai" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM LoaiSP" />

    <asp:SqlDataSource ID="dsNSX" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM NhaSanXuat" />

</asp:Content>

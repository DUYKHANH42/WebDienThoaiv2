<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="Product.aspx.cs" Inherits="WebDienThoai.Admin.Product" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h3 class="page-title">Quản Lý Sản Phẩm</h3>
        <asp:HyperLink runat="server" ID="btnThemMoi" CssClass="btn btn-pill btn-add d-flex align-items-center" NavigateUrl="AddProduct.aspx"><i class="fas fa-plus me-2"></i>Thêm Sản Phẩm Mới </asp:HyperLink>
    </div>
    <!-- Filter Card -->
    <div class="filter-card shadow-sm">
        <div class="row g-3">
            <div class="col-md-4">
                <asp:TextBox ID="txtTenSP" runat="server" CssClass="form-control" placeholder="Tìm kiếm theo tên sản phẩm..." />
            </div>
            <div class="col-md-3">
                <asp:DropDownList ID="ddlLoai" runat="server" CssClass="form-select" DataSourceID="dsLoai" DataTextField="TenLoai" DataValueField="MaLoai" AppendDataBoundItems="true">
                    <asp:ListItem Value="">-- Tất cả loại sản phẩm --</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:DropDownList ID="ddlNSX" runat="server" CssClass="form-select" DataSourceID="dsNSX" DataTextField="TenNSX" DataValueField="MaNSX" AppendDataBoundItems="true">
                    <asp:ListItem Value="">-- Tất cả thương hiệu --</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2">
                <asp:Button ID="btnSearch" OnClick="btnSearch_Click" runat="server" Text="Tìm kiếm" CssClass="btn btn-dark btn-pill w-100" />
            </div>
        </div>
    </div>
    <asp:UpdatePanel ID="upProduct" runat="server">
        <ContentTemplate>
            <div class="table-container shadow-sm">
                <asp:ListView ID="lvSanPham" runat="server" OnItemCommand="lvSanPham_ItemCommand">
                    <LayoutTemplate>
                        <table class="table table-modern text-center">
                            <thead>
                                <tr>
                                    <th>Ảnh</th>
                                    <th class="text-start">Tên Sản Phẩm</th>
                                    <th>Danh Mục</th>
                                    <th>Thương Hiệu</th>
                                    <th>Ngày Mở Bán</th>
                                    <th>Số Lượng Tồn</th>
                                    <th>Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr data-id='<%# Eval("MaSP") %>'>
                            <td style="width: 100px">
                                <img src="../imgs/<%# Eval("AnhSP") %>" class="rounded-3 shadow-sm" style="width: 60px; height: 60px; object-fit: cover" />
                            </td>
                            <td class="text-start fw-bold text-dark"><%# Eval("TenSP") %></td>
                            <td><span class="badge bg-light text-secondary rounded-pill px-3"><%# Eval("TenLoai") %></span></td>
                            <td><span class="fw-bold"><%# Eval("TenNSX") %></span></td>
                            <td class="small text-muted"><%# Eval("NgayCapNhat","{0:dd/MM/yyyy}") %></td>
                            <td><span class="fw-bold"><%# Eval("TonKho") %></span></td>
                            <td>
                                <div class="d-flex justify-content-center gap-2">
                                    <asp:LinkButton runat="server" CssClass="btn btn-outline-success btn-sm rounded-pill px-3" CommandName="editSP" CommandArgument='<%# Eval("MaSP") %>'><i class="fas fa-edit me-1"></i>Sửa </asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn btn-outline-danger btn-sm rounded-pill px-3" OnClientClick='<%# "return deleteSP(" + Eval("MaSP") + ");" %>'><i class="fas fa-eye-slash me-1"></i>Ẩn sản phẩm </asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:ListView>
            </div>
            <!-- Pagination -->
            <nav class="d-flex justify-content-center mt-5">
                <ul class="pagination shadow-sm rounded-pill p-1 bg-white">
                    <li class="page-item <%= CurrentPage == 1 ? "disabled" : "" %>">
                        <asp:LinkButton runat="server" CssClass="page-link" OnClick="Prev_Click">«</asp:LinkButton>
                    </li>
                    <asp:Repeater ID="rpPager" runat="server" OnItemCommand="rpPager_ItemCommand">
                        <ItemTemplate>
                            <li class='page-item <%# (int)Eval("Page") == CurrentPage ? "active" : "" %>'>
                                <asp:LinkButton runat="server" CssClass="page-link" CommandName="Page" CommandArgument='<%# Eval("Page") %>'><%# Eval("Page") %></asp:LinkButton>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                    <li class="page-item">
                        <asp:LinkButton ID="btnNext" runat="server" CssClass="page-link" OnClick="btnNext_Click">»</asp:LinkButton>
                    </li>
                </ul>
            </nav>
            <!-- Modal Cập nhật -->
            <div class="modal fade" id="modalEdit" tabindex="-1">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content modal-content-modern shadow-lg">
                        <div class="modal-header modal-header-modern border-0">
                            <h5 class="fw-bold mb-0">Cập Nhật Thông Tin Sản Phẩm</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <asp:HiddenField ID="hdMaSP" runat="server" />
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small text-muted">Tên sản phẩm</label>
                                    <asp:TextBox ID="txtEditTenSP" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold small text-muted">Loại</label>
                                    <asp:DropDownList ID="ddlEditLoai" runat="server" CssClass="form-select" DataSourceID="dsLoai" DataTextField="TenLoai" DataValueField="MaLoai"></asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold small text-muted">Thương hiệu</label>
                                    <asp:DropDownList ID="ddlEditNSX" runat="server" CssClass="form-select" DataSourceID="dsNSX" DataTextField="TenNSX" DataValueField="MaNSX"></asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small text-muted">Dung lượng</label>
                                    <asp:TextBox ID="txtEditDungLuong" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small text-muted">Thị trường</label>
                                    <asp:TextBox ID="txtEditThiTruong" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small text-muted">Số Lượng Tồn Kho</label>
                                    <asp:TextBox ID="txtEditTonKho" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small text-muted">Đơn Giá</label>
                                    <asp:TextBox ID="txtEditDonGia" runat="server" CssClass="form-control" />
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label fw-bold small text-muted">Mô tả sản phẩm</label>
                                    <asp:TextBox ID="txtEditMoTa" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" />
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label fw-bold small text-muted">Quản lý hình ảnh</label>
                                    <asp:FileUpload ID="fuHinhMoi" runat="server" CssClass="form-control mb-3" AllowMultiple="true" />
                                    <div class="d-flex flex-wrap gap-3 bg-light p-3 rounded-4">
                                        <asp:Repeater ID="rpHinhAnh" runat="server">
                                            <ItemTemplate>
                                                <div class="position-relative img-item">
                                                    <img src="/imgs/<%# Eval("TenHinh") %>" class="rounded shadow-sm border border-white border-3" style="width: 90px; height: 90px; object-fit: cover;" />
                                                    <asp:HiddenField ID="hdMaHinh" runat="server" Value='<%# Eval("MaHinh") %>' />
                                                    <asp:CheckBox ID="chkXoa" runat="server" CssClass="d-none" />
                                                    <button type="button" class="btn btn-danger position-absolute top-0 end-0 translate-middle rounded-circle p-1" style="font-size: 10px;" onclick="toggleDelete(this)"><i class="fas fa-times"></i></button>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-0 p-4 pt-0">
                            <button type="button" class="btn btn-light btn-pill" data-bs-dismiss="modal">Hủy bỏ</button>
                            <asp:Button ID="btnUpdate" runat="server" Text="Lưu thay đổi" CssClass="btn btn-primary btn-pill shadow" OnClick="btnUpdate_Click" />
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

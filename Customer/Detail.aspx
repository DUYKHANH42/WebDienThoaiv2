<%@ Page Title="Chi Tiết Sản Phẩm" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true"
    CodeBehind="Detail.aspx.cs" Inherits="WebDienThoai.Customer.Detail" %>

<asp:Content ID="Detail" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    
    <div class="container py-5">
        <!-- Breadcrumb & Title -->
        <div class="mb-4">
           <div class="breadcrumb-wrapper">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="Default.aspx"><i class="fas fa-home"></i>Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="Product.aspx">Điện thoại</a></li>
                <li class="breadcrumb-item active" aria-current="page">Chi tiết sản phẩm</li>
            </ol>
        </nav>
    </div>
</div>
        </div>
        <div class="product-detail-container shadow-sm border-light">
            <asp:Repeater ID="rptSP" runat="server" DataSourceID="SP">
                <ItemTemplate>
                    <div class="row g-5">
                        <!-- Cột 1: Hình ảnh -->
                        <div class="col-lg-5">
                            <div class="main-img-wrapper mb-4">
                                <asp:Repeater ID="rptHinhMain" runat="server" DataSourceID="dsHinhAnh">
                                    <ItemTemplate>
                                        <%# Container.ItemIndex==0 ? "<img src='../imgs/" + Eval("TenHinh")
                                                + "' class='img-fluid main-img' />" : "" %>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                            <div class="d-flex gap-3 justify-content-center overflow-auto pb-2">
                                <asp:Repeater ID="rptHinh" runat="server" DataSourceID="dsHinhAnh">
                                    <ItemTemplate>
                                        <img src="../imgs/<%# Eval(" TenHinh") %>" class="thumb-img"
                                            alt="Thumbnail">
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        <!-- Cột 2: Thông tin chính -->
                        <div class="col-lg-4">
                            <span
                                class="badge bg-primary-subtle text-primary mb-2 px-3 py-2 rounded-pill fw-bold small">CHÍNH
                                    HÃNG</span>
                            <h1 class="fw-bold mb-3 text-dark">
                                <%# Eval("TenSP") %>
                            </h1>
                            <div class="d-flex align-items-baseline mb-4">
                                <span class="price-large">
                                    <%# Eval("GiaMin", "{0:N0}" ) %> ₫
                                  <%--  </span> <span class="ms-3 text-muted text-decoration-line-through small">34.990.000
                                        ₫</span>--%>
                            </div>
                            <div class="row g-2 mb-4">
                                <div class="col-6">
                                    <div class="spec-badge text-center w-100">
                                        <i class="fas fa-microchip me-2"></i>
                                        <%# Eval("dungluong") %>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="spec-badge text-center w-100">
                                        <i class="fas fa-globe me-2"></i>
                                        <%# Eval("thitruong") %>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-4">
                                <h6 class="fw-bold text-muted small text-uppercase mb-3">Chọn màu sắc</h6>
                                <div class="d-flex gap-3 align-items-center">
                                    <asp:Repeater ID="rptMauSac" runat="server" DataSourceID="dsMauSac">
                                        <ItemTemplate>
                                            <div class="color-dot" data-mamau="<%# Eval(" MaMau") %>" title="<%#
                                                        Eval("TenMau") %>"
                                                style="background-color: <%# Eval("MaMauHex")
                                                            %>;">
                                            </div>
                                            <asp:HiddenField ID="hfSelectedMaMau" runat="server"
                                                Value='<%# Eval("MaMau") %>' />
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                            <div class="mb-4">
                                <h6 class="fw-bold text-muted small text-uppercase mb-2">Mô tả sản phẩm</h6>
                                <p class="text-secondary small leading-relaxed">
                                    <%# Eval("mota") %>
                                </p>
                            </div>
                            <asp:LinkButton
                                ID="btnAddToCart"
                                runat="server"
                                CssClass="btn btn-danger btn-add-cart-large w-100 mb-3"
                                ClientIDMode="Static"
                                CommandArgument='<%# Eval("MaSP") %>'>
                                    <i class="fas fa-cart-plus me-2"></i>
                                    Thêm vào giỏ hàng
                            </asp:LinkButton>
                        </div>
                        <div class="col-lg-3">
                            <div class="specs-card">
                                <h6 class="fw-bold mb-4"><i class="fas fa-info-circle me-2 text-primary"></i>Thông
                                        số kỹ thuật</h6>
                                <div class="spec-item">
                                    <span class="spec-label">CPU</span> <span
                                        class="spec-value text-end small ps-2">
                                        <%# Eval("Cpu") %>
                                    </span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label">RAM</span> <span
                                        class="spec-value">
                                        <%# Eval("ram") %>
                                    </span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label">Màn hình</span> <span
                                        class="spec-value text-end small ps-2">
                                        <%# Eval("manhinh") %>
                                    </span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label">Pin</span> <span
                                        class="spec-value">
                                        <%# Eval("pin") %>
                                    </span>
                                </div>
                                <div class="spec-item">
                                    <span class="spec-label">Hệ điều hành</span> <span
                                        class="spec-value">
                                        <%# Eval("hedieuhanh") %>
                                    </span>
                                </div>
                                <div class="mt-4">
                                    <button type="button"
                                        class="btn btn-outline-primary btn-sm w-100 rounded-pill">
                                        Xem cấu hình chi
                                            tiết</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <!-- Sản phẩm gợi ý -->
        <div class="mt-5 pt-4">
            <h4 class="section-title-line">SẢN PHẨM CÙNG THƯƠNG HIỆU</h4>
            <div class="row g-4">
                <asp:Repeater ID="rptDanhMucGoiY" runat="server" DataSourceID="dsGoiY">
                    <ItemTemplate>
                        <div class="col-lg-2 col-md-4 col-6">
                            <div class="card product-card-modern border-0 shadow-sm h-100">
                                <a
                                    href='Detail.aspx?masp=<%# Eval("masp") %>&mansx=<%# Eval("mansx") %>'
                                    class="text-decoration-none">
                                    <div class="p-3 text-center" style="background: #fbfbfb;">
                                        <img
                                            src="../imgs/<%# Eval(" AnhSP") %>" class="img-fluid" style="height: 150px; object-fit: contain;"
                                            alt="Product">
                                    </div>
                                    <div class="card-body p-3">
                                        <h6 class="text-dark fw-bold mb-1 text-truncate small">
                                            <%# Eval("TenSP") %>
                                        </h6>
                                        <div class="text-danger fw-bold small mb-2">
                                            <%# Eval("DonGia", "{0:N0}" ) %> ₫
                                        </div>
                                        <asp:HyperLink ID="lnkDetail" runat="server"
                                            CssClass="btn btn-light btn-sm w-100 fw-bold"
                                            NavigateUrl='<%# "Detail.aspx?masp=" + Eval("MaSP") + "&mansx=" + Eval("MaNSX") %>'>Chi tiết
                                        </asp:HyperLink>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <asp:SqlDataSource ID="SP" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT TOP 1 sp.*, ch.*, gm.GiaMin FROM SanPham sp INNER JOIN CauHinhSP ch ON sp.MaSP = ch.MaSP INNER JOIN ( SELECT MaSP, MIN(DonGia) AS GiaMin FROM CauHinhSP GROUP BY MaSP ) gm ON gm.MaSP = sp.MaSP WHERE sp.MaSP = @MaSP">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaSP" QueryStringField="masp" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsGoiY" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT top 6 * FROM [SanPham] WHERE ([MaNSX] = @MaNSX AND Masp != @MaSP) ORDER BY [NgayCapNhat]">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaNSX" QueryStringField="mansx" Type="Int32" />
            <asp:QueryStringParameter Name="MaSP" QueryStringField="masp" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsHinhAnh" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand=" SELECT TenHinh, ThuTu FROM HinhAnhSanPham WHERE MaSP = @MaSP AND ( MaMau IS NULL OR MaMau = @MaMau ) ORDER BY CASE WHEN MaMau = @MaMau THEN 0 ELSE 1 END, ThuTu ">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaSP" QueryStringField="masp" Type="Int32" />
            <asp:QueryStringParameter Name="MaMau" QueryStringField="mamau" DefaultValue="2" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsMauSac" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand=" SELECT m.MaMau, m.TenMau, m.MaMauHex FROM MauSac m JOIN SanPham_MauSac spm ON m.MaMau = spm.MaMau WHERE spm.MaSP = @MaSP">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaSP" QueryStringField="masp" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebDienThoai.Customer.index2" %>

<asp:Content ID="TrangChu" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">Điện thoại chính hãng<br>
                        Giá tốt nhất thị trường</h1>
                    <p class="lead mb-4">Cam kết 100% hàng chính hãng, bảo hành toàn quốc. Miễn phí vận chuyển toàn quốc cho đơn hàng từ 500.000đ</p>
                    <a href="#products" class="btn btn-danger btn-lg px-5">
                        <i class="fas fa-shopping-bag me-2"></i>Mua ngay
                    </a>
                </div>
                <div class="col-lg-6 text-center">
                    <a href="#products">
                        <img src="../imgs/ip15pm.jpg"
                            class="img-fluid rounded hero-img" />
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories Dien Thoai -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="row g-3 text-center">
                <h2 class="text-center mb-4 fw-bold">Thương Hiệu Nổi Bật</h2>
                <asp:Repeater ID="rptCategories" DataSourceID="dsCategories" runat="server">
                    <ItemTemplate>
                        <div class="col-md-3 mb-3">
                            <a href='Product.aspx?mansx=<%# Eval("MaNSX") %>'
                                class='btn <%# 
                   Eval("TenNSX").ToString() == "Apple" ? "btn-outline-dark" :
                   Eval("TenNSX").ToString() == "Samsung" ? "btn-outline-primary" :
                   Eval("TenNSX").ToString() == "Xiaomi" ? "btn-outline-danger" :
                   "btn-outline-success" 
               %> w-100 py-3 fw-semibold d-flex align-items-center justify-content-center'>
                                <img src='../imgs/<%# Eval("logo") %>' alt='<%# Eval("TenNSX") %>' style="width: 24px; height: 24px; margin-right: 0.5rem;">
                                <%# Eval("TenNSX") %>
                            </a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- Products -->
    <section class="py-5" id="products">
        <div class="container">
            <h2 class="text-center mb-4 fw-bold">Điện Thoại</h2>
            <div class="row g-4">
                <asp:Repeater ID="rptSP" runat="server" DataSourceID="dsSP">
                    <ItemTemplate>
                        <div class="col-md-3">
                            <div class="card product-card">
                                <a href='Detail.aspx?masp=<%# Eval("MaSP") %>&mansx=<%# Eval("mansx") %>' class="text-decoration-none">
                                    <div class="position-relative">
                                        <%--<span class="badge-discount">-10%</span>--%>
                                        <img src="../imgs/<%# Eval("AnhSP") %>" class="card-img-top product-img" alt="<%# Eval("TenSP") %>">
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title"><%# Eval("TenSP") %></h5>
                                        <p class="text-muted small mb-2"><%# Eval("dungluong") %> - Chính hãng <%# Eval("thitruong") %></p>
                                        <div class="mb-3">
                                            <span class="price"><%# Eval("dongia", "{0:N0}") %></span>
                                            <%--<span class="old-price ms-2">34.990.000₫</span>--%>
                                        </div>
                                </a>
                                <asp:LinkButton
                                    ID="btnAddToCart"
                                    runat="server"
                                    CssClass="btn btn-primary btn-lg w-100 mt-2 btnAddToCart"
                                    CommandArgument='<%# Eval("MaSP") %>'>
<i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                </asp:LinkButton>
                            </div>
                        </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>
    <!-- Products -->
    <section class="py-5" id="productsHepl">
        <div class="container">
            <h2 class="text-center mb-4 fw-bold">Phụ Kiện</h2>
            <div class="row g-4">
                <asp:Repeater ID="Repeater1" runat="server" DataSourceID="dsSPPhuKien">
                    <ItemTemplate>
                        <div class="col-md-3">
                            <div class="card product-card">
                                <div class="position-relative">
                                    <a href='Detail.aspx?masp=<%# Eval("MaSP") %>&mansx=<%# Eval("mansx") %>' class="text-decoration-none">
                                        <span class="badge-discount">-10%</span>
                                        <img src="../imgs/<%# Eval("AnhSP") %>" class="card-img-top product-img " alt="<%# Eval("TenSP") %>">
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title text-nowrap"><%# Eval("TenSP") %></h6>
                                    <p class="text-muted small mb-2"><%# Eval("dungluong") %> - Chính hãng <%# Eval("thitruong") %></p>
                                    <div class="mb-3">
                                        <span class="price"><%# Eval("dongia", "{0:N0}") %></span>
                                        <%--<span class="old-price ms-2">34.990.000₫</span>--%>
                                    </div>
                                    </a>
                                <button class="btn btn-buy w-100">
                                    <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                </button>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <section class="py-5 bg-light">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-3 text-center">
                    <div class="feature-icon">
                        <i class="fas fa-shipping-fast"></i>
                    </div>
                    <h5>Miễn phí vận chuyển</h5>
                    <p class="text-muted">Đơn hàng từ 500.000₫</p>
                </div>
                <div class="col-md-3 text-center">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h5>Bảo hành chính hãng</h5>
                    <p class="text-muted">Bảo hành 12 tháng</p>
                </div>
                <div class="col-md-3 text-center">
                    <div class="feature-icon">
                        <i class="fas fa-undo"></i>
                    </div>
                    <h5>Đổi trả dễ dàng</h5>
                    <p class="text-muted">Trong vòng 7 ngày</p>
                </div>
                <div class="col-md-3 text-center">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h5>Hỗ trợ 24/7</h5>
                    <p class="text-muted">Tư vấn nhiệt tình</p>
                </div>
            </div>
        </div>
    </section>
    <asp:SqlDataSource
        ID="dsSP"
        runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT top 8 * FROM [SanPham] order by DonGia desc "></asp:SqlDataSource>
    <asp:SqlDataSource
        ID="dsSPPhuKien"
        runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT top 4 * FROM [SanPham] where MaLoai=2 order by DonGia desc "></asp:SqlDataSource>
    <asp:SqlDataSource ID="dsCategories" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM NhaSanXuat "></asp:SqlDataSource>
</asp:Content>

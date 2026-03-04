<%@ Page Title="Trang Chủ" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebDienThoai.Customer.index2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .hero-section {
            padding: 80px 0;
            background: #ffffff;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.2;
        }

        .hero-img-container {
            background: #f8fafc;
            border-radius: 40px;
            padding: 40px;
            text-align: center;
        }

        .brand-card {
            background: #fff;
            border: 1px solid #f1f5f9;
            border-radius: 15px;
            padding: 20px;
            transition: 0.3s;
            text-align: center;
        }

            .brand-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            }

        .product-card {
            border: none;
            border-radius: 20px;
            transition: 0.3s;
            padding: 15px;
            background: #fff;
        }

            .product-card:hover {
                box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            }

        .product-img {
            height: 220px;
            object-fit: contain;
            transition: 0.5s;
        }

        .product-card:hover .product-img {
            transform: scale(1.05);
        }

        .price-new {
            color: var(--accent-red);
            font-weight: 700;
            font-size: 1.2rem;
        }

        .price-old {
            text-decoration: line-through;
            color: #94a3b8;
            font-size: 0.9rem;
        }

        .badge-promo {
            background: #eff6ff;
            color: #3b82f6;
            font-weight: 600;
            padding: 5px 15px;
            border-radius: 50px;
        }

        .section-title {
            font-weight: 800;
            position: relative;
            padding-bottom: 15px;
            margin-bottom: 40px;
        }

            .section-title::after {
                content: '';
                position: absolute;
                left: 0;
                bottom: 0;
                width: 60px;
                height: 4px;
                background: var(--primary-color);
                border-radius: 2px;
            }

        .newsletter-box {
            background: #3b82f6;
            border-radius: 30px;
            padding: 60px;
            color: white;
            text-align: center;
        }
    </style>
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <span class="badge-promo mb-3 d-inline-block">SẢN PHẨM MỚI NHẤT</span>
                    <h1 class="hero-title mb-4">Điện thoại chính hãng,<br>
                        <span class="text-primary">Giá tốt nhất</span></h1>
                    <p class="text-muted mb-5 fs-5">Cam kết 100% hàng chính hãng, bảo hành toàn quốc. Trải nghiệm công nghệ đỉnh cao ngay hôm nay.</p>
                    <div class="d-flex gap-3"><a href="#products" class="btn btn-primary btn-lg px-5 py-3 fw-bold rounded-pill shadow">Mua ngay</a> <a href="#" class="btn btn-outline-secondary btn-lg px-5 py-3 fw-bold rounded-pill">Tìm hiểu thêm</a> </div>
                </div>
                <div class="col-lg-6">
                    <div class="hero-img-container shadow-sm">
                        <img src="../imgs/ip15pm.jpg" class="img-fluid rounded" alt="Hero Product" style="max-height: 450px;">
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Brands -->
    <section class="py-5">
        <div class="container">
            <h3 class="section-title">Thương Hiệu Nổi Bật</h3>
            <div class="row g-4">
                <asp:Repeater ID="rptCategories" DataSourceID="dsCategories" runat="server">
                    <ItemTemplate>
                        <div class="col-md-2 col-6">
                            <a href='/Customer/Product.aspx?mansx=<%# Eval("MaNSX") %>' class="text-decoration-none">
                                <div class="brand-card">
                                    <img src='../imgs/<%# Eval("logo") %>' alt='<%# Eval("TenNSX") %>' style="height: 30px; width: auto; object-fit: contain;">
                                    <div class="mt-2 text-dark fw-bold small"><%# Eval("TenNSX") %></div>
                                </div>
                            </a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>
    <!-- Products Section -->
    <section class="py-5" id="products">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <h3 class="section-title mb-0">Điện Thoại Mới</h3>
                <a href="Product.aspx" class="text-primary fw-bold text-decoration-none">Xem tất cả <i class="fas fa-arrow-right ms-1"></i></a></div>
            <div class="product-slider-container">
                <div class="product-slider">
                    <asp:Repeater ID="rptSP" runat="server" DataSourceID="dsSP">
                        <ItemTemplate>
                            <div class="product-item">
                                <div class="card product-card h-100"><a href='/Customer/Detail.aspx?masp=<%# Eval("MaSP") %>&mansx=<%# Eval("mansx") %>' class="text-decoration-none">
                                    <div class="text-center mb-4">
                                        <img src="../imgs/<%# Eval("AnhSP") %>" class="product-img" alt="<%# Eval("TenSP") %>">
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="text-muted small mb-1"><%# Eval("TenNSX") %></div>
                                        <h6 class="text-dark fw-bold mb-2"><%# Eval("TenSP") %></h6>
                                        <div class="small text-muted mb-3"><%# Eval("dungluong") %> - <%# Eval("thitruong") %></div>
                                        <div class="d-flex align-items-center justify-content-between">
                                            <div class="price-new"><%# Eval("DonGia", "{0:N0}") %>₫</div>
                                            <div class="text-warning small"><i class="fas fa-star me-1"></i>4.9</div>
                                        </div>
                                    </div>
                                </a></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </section>
    <section class="py-5">
        <div class="container">
            <div class="newsletter-box">
                <h2 class="fw-bold mb-3">Đừng bỏ lỡ ưu đãi!</h2>
                <p class="mb-4 opacity-75">Nhận thông báo về các chương trình khuyến mãi và sản phẩm mới nhất trực tiếp qua email của bạn.</p>
                <div class="d-flex justify-content-center">
                    <div class="input-group" style="max-width: 500px;">
                        <input type="email" class="form-control border-0 rounded-start-pill px-4" placeholder="Địa chỉ email của bạn">
                        <button class="btn btn-dark rounded-end-pill px-4 fw-bold">Đăng ký</button>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <asp:SqlDataSource ID="dsSP" runat="server" ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT  sp.*, nsx.TenNSX, sp.DonGia FROM SanPham sp
        JOIN NhaSanXuat nsx ON sp.MaNSX = nsx.MaNSX 
        WHERE sp.DaXoa != 1 ORDER BY  sp.MaLoai ASC, sp.DonGia DESC"></asp:SqlDataSource>
    <asp:SqlDataSource ID="dsCategories" runat="server" ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>" SelectCommand="SELECT * FROM NhaSanXuat"></asp:SqlDataSource>
</asp:Content>

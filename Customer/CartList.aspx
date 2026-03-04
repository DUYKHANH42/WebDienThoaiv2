<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CartList.aspx.cs" Inherits="WebDienThoai.Customer.CartList" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - PhoneStore</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" />
    <link href="../css/style.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .cart-item-card {
            border: none;
            border-radius: 20px;
            transition: 0.3s;
            background: #fff;
            margin-bottom: 15px;
        }

            .cart-item-card:hover {
                transform: translateX(5px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.05);
            }

        .checkout-sidebar {
            background: #fff;
            border-radius: 25px;
            padding: 30px;
            position: sticky;
            top: 100px;
            border: 1px solid #edf2f7;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
            background: #fbfbfb;
        }

            .form-control:focus {
                background: #fff;
                border-color: var(--bs-primary);
                box-shadow: none;
            }

        .payment-option {
            border: 2px solid #f1f5f9;
            border-radius: 15px;
            padding: 15px;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

            .payment-option:hover {
                border-color: var(--bs-primary);
                background: #f0f7ff;
            }

            .payment-option input[type="radio"]:checked + label {
                color: var(--bs-primary);
                font-weight: bold;
            }

        .qty-input-group {
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            max-width: 120px;
        }

        .btn-qty {
            border: none;
            background: #f1f5f9;
            width: 35px;
            transition: 0.2s;
        }

            .btn-qty:hover {
                background: #e2e8f0;
            }

        .summary-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            color: #64748b;
        }

        .summary-total {
            border-top: 2px dashed #f1f5f9;
            padding-top: 20px;
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold fs-3 text-primary" href="Default.aspx"><i class="fas fa-mobile-alt me-2"></i>PhoneStore </a>
                <div class="d-none d-lg-block ms-4">
                    <div class="input-group search-bar">
                        <input type="text" class="form-control bg-transparent border-0" placeholder="Tìm kiếm điện thoại, phụ kiện...">
                        <button class="btn border-0 text-muted"><i class="fas fa-search"></i></button>
                    </div>
                </div>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item"><a class="nav-link px-3" href="Default.aspx">Trang chủ</a></li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle px-3" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">Danh mục sản phẩm
                            </a>
                            <div class="dropdown-menu  mega-menu  mt-2" aria-labelledby="navbarDropdown">
                                <asp:Repeater ID="rptMenu" runat="server">
                                    <ItemTemplate>
                                        <div class="row mb-4 last-child-mb-0">
                                            <div class="col-12 mb-3">
                                                <h6 class="fw-bold category-title mb-0">
                                                    <i class="fas fa-chevron-right me-2 small"></i><%# Eval("TenLoai") %>
                                                </h6>
                                            </div>
                                            <div class="col-7">
                                                <p class="small text-muted fw-bold mb-2">THƯƠNG HIỆU</p>
                                                <div class="row g-2">
                                                    <asp:Repeater runat="server" DataSource='<%# Eval("ThuongHieu") %>'>
                                                        <ItemTemplate>
                                                            <div class="col-3">
                                                                <a href='Product.aspx?mansx=<%# Eval("MaNSX") %>' class="brand-item-link text-center">
                                                                    <img src='../imgs/<%# Eval("Logo") %>' alt='<%# Eval("TenNSX") %>' style="width: 100%; height: 30px; object-fit: contain;">
                                                                </a>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                            <div class="col-5 border-start">
                                                <p class="small text-danger fw-bold mb-2 ps-3">SẢN PHẨM HOT</p>
                                                <div class="ps-3">
                                                    <asp:Repeater runat="server" DataSource='<%# Eval("SanPhamNoiBat") %>'>
                                                        <ItemTemplate>
                                                            <a href='Detail.aspx?masp=<%# Eval("MaSP") %>&mansx=<%# Eval("MaNSX") %>' class="d-block text-decoration-none hot-product-link">
                                                                <i class="fas fa-fire me-2 text-warning small"></i><%# Eval("TenSP") %>
                                                            </a>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                        <hr class="opacity-10 my-3" />
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </li>

                        <li class="nav-item"><a class="nav-link px-3" href="#">Khuyến mãi</a></li>
                        <li class="nav-item px-3">
                            <a href="CartList.aspx" class="position-relative text-dark text-decoration-none">
                                <i class="fas fa-shopping-cart fs-5"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill cart-badge" id="cartCount">
                                    <%= CartCount %>
                                </span>
                            </a>
                        </li>

                        <!-- Nút Đăng nhập (Hiện khi chưa đăng nhập) -->
                        <li class="nav-item ms-3" id="liLogin" runat="server">
                            <a id="btnLogin" href="../login.aspx" class="btn btn-dark btn-login px-4">
                                <i class="fas fa-user me-2"></i>Đăng nhập
                            </a>
                        </li>

                        <!-- Dropdown Tài khoản (Hiện khi đã đăng nhập) -->
                        <li class="nav-item dropdown ms-3" id="liUser" runat="server">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <div class="avatar-circle me-2">
                                    <img src="../imgs/default-avatar.png" alt="User" id="imgUser" runat="server" class="rounded-circle" style="width: 32px; height: 32px; object-fit: cover; border: 2px solid #eee;">
                                </div>
                                <span class="fw-bold" id="spAccount" runat="server">Username</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item py-2" href="Profile.aspx">
                                        <i class="fas fa-user-circle me-2 text-primary"></i>Trang cá nhân
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="OrderHistory.aspx">
                                        <i class="fas fa-shopping-bag me-2 text-success"></i>Đơn hàng của tôi
                                    </a>
                                </li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li>
                                    <asp:LinkButton ID="btnLogout" runat="server" CssClass="dropdown-item py-2 text-danger" OnClick="btnLogout_Click">
                      <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </asp:LinkButton>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container py-5">
            <div class="breadcrumb-wrapper">
                <div class="container">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="Default.aspx"><i class="fas fa-home"></i>Trang chủ</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Giỏ hàng & Thanh toán</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <h2 class="fw-bold mb-4"><i class="fas fa-shopping-bag me-3 text-primary"></i>Giỏ hàng của bạn</h2>

            <div class="row g-4">
                <div class="col-lg-7">
                    <% if (CartCount > 0)
                        { %>
                    <asp:Repeater ID="rpCart" runat="server">
                        <ItemTemplate>
                            <div class="card cart-item-card shadow-sm">
                                <div class="card-body p-3">
                                    <div class="row align-items-center">
                                        <div class="col-3 col-md-2 text-center">
                                            <img src="../imgs/<%# Eval("SanPham.AnhSP") %>" class="img-fluid rounded" alt="Product">
                                        </div>
                                        <div class="col-9 col-md-10">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <a href="Detail.aspx?masp=<%# Eval("SanPham.MaSP") %>" class="fw-bold text-dark text-decoration-none d-block mb-1 fs-5">
                                                        <%# Eval("SanPham.TenSP") %>
                                                    </a>
                                                    <div class="d-flex align-items-center mb-2">
                                                        <span class="badge rounded-pill me-2" style="background-color: <%# Eval("MauSac.MaMauHex") %>; width: 15px; height: 15px; border: 1px solid #eee;">&nbsp;</span>
                                                        <span class="small text-muted"><%# Eval("MauSac.TenMau") %></span>
                                                    </div>
                                                    <div class="text-danger fw-bold fs-5 mb-2"><%# Eval("SanPham.DonGia", "{0:N0}") %> ₫</div>
                                                </div>
                                                <button type="button" class="btn text-danger btn-remove border-0" data-id="<%# Eval("SanPham.MaSP") %>" data-mamau="<%# Eval("MauSac.MaMau") %>">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </div>

                                            <div class="qty-input-group d-flex align-items-center">
                                                <button type="button" class="btn-qty btn-decrease" data-id="<%# Eval("SanPham.MaSP") %>" data-mamau="<%# Eval("MauSac.MaMau") %>">-</button>
                                                <input type="number" class="form-control text-center qty border-0 bg-transparent py-1 px-0" value="<%# Eval("SoLuong") %>" min="1" data-id="<%# Eval("SanPham.MaSP") %>" readonly>
                                                <button type="button" class="btn-qty btn-increase" data-id="<%# Eval("SanPham.MaSP") %>" data-mamau="<%# Eval("MauSac.MaMau") %>">+</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% }
                        else
                        { %>
                    <div class="text-center py-5 bg-white rounded-4 shadow-sm">
                        <i class="fas fa-shopping-cart fa-4x text-light mb-3"></i>
                        <h4 class="text-muted">Giỏ hàng đang trống</h4>
                        <p class="text-muted mb-4">Hãy lấp đầy giỏ hàng bằng những siêu phẩm công nghệ!</p>
                        <a href="Default.aspx" class="btn btn-primary px-5 rounded-pill fw-bold">Mua sắm ngay</a>
                    </div>
                    <% } %>
                </div>
                <div class="col-lg-5">
                    <div class="checkout-sidebar shadow-sm">
                        <!-- TRƯỜNG HỢP 1: CHƯA ĐĂNG NHẬP -->
                        <asp:PlaceHolder ID="phNotLoggedIn" runat="server">
                            <div class="text-center py-4">
                                <div class="mb-4">
                                    <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 80px; height: 80px;">
                                        <i class="fas fa-user-lock fa-2x text-muted"></i>
                                    </div>
                                </div>
                                <h5 class="fw-bold">Bạn chưa đăng nhập?</h5>
                                <p class="text-muted small px-4">Vui lòng đăng nhập để sử dụng địa chỉ đã lưu và nhận ưu đãi dành riêng cho thành viên.</p>
                                <div class="d-grid gap-2 mt-4 px-4">
                                    <a href="../login.aspx" class="btn btn-primary rounded-pill fw-bold py-2">ĐĂNG NHẬP NGAY</a>
                                </div>
                            </div>
                        </asp:PlaceHolder>

                        <asp:PlaceHolder ID="phLoggedIn" runat="server" Visible="false">
                            <h5 class="fw-bold mb-4"><i class="fas fa-map-marker-alt me-2 text-primary"></i>Thông tin nhận hàng</h5>

                            <!-- Danh sách địa chỉ đã có -->
                           <div class="mb-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <label class="form-label small fw-bold text-muted text-uppercase mb-0">Chọn địa chỉ giao hàng</label>
        <!-- Nút Sửa địa chỉ -->
        <asp:LinkButton ID="btnEditAddress" runat="server" CssClass="text-primary small fw-bold text-decoration-none" OnClick="btnEditAddress_Click">
            <i class="fas fa-edit me-1"></i>Chỉnh sửa địa chỉ đã chọn
        </asp:LinkButton>
    </div>

    <div class="address-container">
        <asp:RadioButtonList ID="rblAddress" runat="server" CssClass="w-100 address-list" AutoPostBack="false">
        </asp:RadioButtonList>
    </div>

    <div class="mt-3">
        <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#modalAddAddress">
            <i class="fas fa-plus-circle me-2"></i>Thêm địa chỉ giao hàng mới
        </button>
    </div>
</div>

                            <h5 class="fw-bold mb-3 mt-4"><i class="fas fa-credit-card me-2 text-primary"></i>Phương thức thanh toán</h5>
                            <div class="payment-options mb-4">
                                <div class="payment-option">
                                    <input class="form-check-input me-3" type="radio" name="payment" id="payCOD" checked>
                                    <label class="form-check-label w-100 mb-0" for="payCOD">
                                        <i class="fas fa-truck-moving me-2 text-muted"></i>Thanh toán khi nhận hàng (COD)
                                    </label>
                                </div>
                                <div class="payment-option">
                                    <input class="form-check-input me-3" type="radio" name="payment" id="payBank">
                                    <label class="form-check-label w-100 mb-0" for="payBank">
                                        <i class="fas fa-university me-2 text-muted"></i>Chuyển khoản ngân hàng
                                    </label>
                                </div>
                            </div>
                        </asp:PlaceHolder>
                        <div class="summary-total">
                            <div>
                                <span class="d-block text-muted small fw-bold">TỔNG CỘNG</span>
                                <asp:Label ID="lblTongTien" CssClass="fs-3 fw-bold text-danger" runat="server" Text="0 ₫"></asp:Label>
                            </div>
                            <asp:Button ID="btnDatHang" OnClick="btnDatHang_Click" CausesValidation="false" CssClass="btn btn-success btn-lg px-4 fw-bold rounded-pill" runat="server" Text="XÁC NHẬN ĐẶT HÀNG" />
                        </div>
                    </div>
                </div>
                <!-- MODAL THÊM ĐỊA CHỈ -->
                <div class="modal fade" id="modalAddAddress" tabindex="-1"
                    aria-labelledby="modalLabel" aria-hidden="true">

                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg" style="border-radius: 25px;">

                            <div class="modal-header border-0 pb-0">
                                <h5 class="modal-title fw-bold" id="modalLabel">Thêm địa chỉ giao hàng
                                </h5>
                                <button type="button" class="btn-close"
                                    data-bs-dismiss="modal">
                                </button>
                            </div>

                            <div class="modal-body p-4">

                                <!-- HIỂN THỊ TỔNG LỖI -->
                                <asp:ValidationSummary
                                    ID="vsAddAddress"
                                    runat="server"
                                    ValidationGroup="AddAddress"
                                    CssClass="alert alert-danger"
                                    HeaderText="Vui lòng kiểm tra lại:"
                                    DisplayMode="BulletList" />

                                <!-- TÊN -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold">
                                        Tên người nhận
                                    </label>

                                    <asp:TextBox ID="txtNewHoTen"
                                        runat="server"
                                        CssClass="form-control"
                                        placeholder="Ví dụ: Nguyễn Văn A" />

                                    <asp:RequiredFieldValidator
                                        ID="rfvHoTen"
                                        runat="server"
                                        ControlToValidate="txtNewHoTen"
                                        ErrorMessage="Vui lòng nhập tên người nhận"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="AddAddress" />
                                </div>

                                <!-- SỐ ĐIỆN THOẠI -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold">
                                        Số điện thoại
                                    </label>

                                    <asp:TextBox ID="txtNewSoDienThoai"
                                        runat="server"
                                        CssClass="form-control"
                                        placeholder="Số điện thoại nhận hàng" />

                                    <asp:RequiredFieldValidator
                                        ID="rfvPhone"
                                        runat="server"
                                        ControlToValidate="txtNewSoDienThoai"
                                        ErrorMessage="Vui lòng nhập số điện thoại"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="AddAddress" />

                                    <asp:RegularExpressionValidator
                                        ID="revPhone"
                                        runat="server"
                                        ControlToValidate="txtNewSoDienThoai"
                                        ValidationExpression="^(0|\+84)[0-9]{9}$"
                                        ErrorMessage="Số điện thoại không hợp lệ"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="AddAddress" />
                                </div>

                                <!-- ĐỊA CHỈ -->
                                <div class="mb-3">
                                    <label class="form-label small fw-bold">
                                        Địa chỉ chi tiết
                                    </label>

                                    <asp:TextBox ID="txtNewDiaChi"
                                        runat="server"
                                        CssClass="form-control"
                                        TextMode="MultiLine"
                                        Rows="3"
                                        placeholder="Số nhà, tên đường, phường/xã..." />

                                    <asp:RequiredFieldValidator
                                        ID="rfvDiaChi"
                                        runat="server"
                                        ControlToValidate="txtNewDiaChi"
                                        ErrorMessage="Vui lòng nhập địa chỉ"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="AddAddress" />
                                </div>

                                <!-- CHECKBOX -->
                                <div class="form-check mb-3">
                                    <asp:CheckBox ID="chkDefault"
                                        runat="server"
                                        CssClass="form-check-input" />
                                    <label class="form-check-label small"
                                        for="<%= chkDefault.ClientID %>">
                                        Đặt làm địa chỉ mặc định
                                    </label>
                                </div>

                            </div>

                            <div class="modal-footer border-0 pt-0 px-4 pb-4">
                                <button type="button"
                                    class="btn btn-light rounded-pill px-4 fw-bold"
                                    data-bs-dismiss="modal">
                                    Hủy
                                </button>

                                <asp:Button ID="btnSaveAddress"
                                    runat="server"
                                    Text="Lưu địa chỉ"
                                    CssClass="btn btn-primary rounded-pill px-4 fw-bold shadow-sm"
                                    OnClick="btnSaveAddress_Click"
                                    ValidationGroup="AddAddress" />
                            </div>

                        </div>
        </div>
</div>
                <!-- MODAL SỬA ĐỊA CHỈ -->
<div class="modal fade" id="modalEditAddress" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 25px;">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold">Cập nhật địa chỉ giao hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <asp:HiddenField ID="hfEditMaDC" runat="server" />
                <div class="mb-3">
                    <label class="form-label small fw-bold">Tên người nhận</label>
                    <asp:TextBox ID="txtEditHoTen" runat="server" CssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-bold">Số điện thoại</label>
                    <asp:TextBox ID="txtEditSoDienThoai" runat="server" CssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label small fw-bold">Địa chỉ chi tiết</label>
                    <asp:TextBox ID="txtEditDiaChi" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                </div>
                <div class="form-check mb-3">
                    <asp:CheckBox ID="chkEditDefault" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label small" for="<%= chkEditDefault.ClientID %>">Đặt làm địa chỉ mặc định</label>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0 px-4 pb-4">
                <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Hủy</button>
                <asp:Button ID="btnDeleteAddress"
    runat="server"
    Text="Xóa"
    CssClass="btn btn-danger rounded-pill px-4 fw-bold shadow-sm me-auto"
    OnClick="btnDeleteAddress_Click"
    OnClientClick="return confirm('Bạn có chắc muốn xóa địa chỉ này?');" />
                <asp:Button ID="btnUpdateAddress" runat="server" Text="Cập nhật" CssClass="btn btn-primary rounded-pill px-4 fw-bold shadow-sm" OnClick="btnUpdateAddress_Click" />
            </div>
        </div>
    </div>
</div>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js">
            </script>
            <script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script src="../js/Customer/site.js"></script>
            <script>
                function callCart(masp, mamau, soluong, action, row) {

                    $.ajax({
                        type: "POST",
                        url: "CartList.aspx/UpdateCart",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: JSON.stringify({
                            masp: masp,
                            mamau: mamau,
                            soluong: soluong,
                            action: action
                        }),

                        success: function (res) {

                            if (!res.d.ok) return;
                            $("#<%= lblTongTien.ClientID %>").text(res.d.total);
                            if (action === "remove")
                                $(row).closest(".cart-item-card").remove();
                        },

                        error: function (xhr) {
                            console.log(xhr.responseText);
                            alert("Lỗi cập nhật giỏ hàng");
                        }
                    });
                }
                $(document).on("click", ".btn-increase", function () {

                    let btn = $(this);
                    let id = parseInt(btn.data("id"));
                    let mamau = parseInt(btn.data("mamau"));
                    let input = btn.parent().find(".qty");

                    let newQty = parseInt(input.val()) + 1;

                    callCart(id, mamau, newQty, "set", btn);
                    input.val(newQty);
                });

                $(document).on("click", ".btn-decrease", function () {

                    let btn = $(this);
                    let id = parseInt(btn.data("id"));
                    let mamau = parseInt(btn.data("mamau"));
                    let input = btn.parent().find(".qty");

                    let newQty = parseInt(input.val()) - 1;

                    // <= 0 => xoá luôn
                    if (newQty <= 0) {
                        callCart(id, mamau, 0, "remove", btn);
                        return;
                    }

                    callCart(id, mamau, newQty, "set", btn);
                    input.val(newQty);
                });
                $(document).on("click", ".btn-remove", function () {

                    let btn = $(this);
                    let id = parseInt(btn.data("id"));
                    let mamau = parseInt(btn.data("mamau"));

                    callCart(id, mamau, 0, "remove", btn);

                });
                $(document).on("change", ".qty", function () {

                    let input = $(this);
                    let btn = input.parent().find("[data-id]");
                    let id = parseInt(btn.data("id"));
                    let mamau = parseInt(btn.data("mamau"));
                    let qty = parseInt(input.val());

                    if (isNaN(qty) || qty <= 0) {
                        callCart(id, mamau, 0, "remove", input);
                        return;
                    }

                    callCart(id, mamau, qty, "set", input);
                });

            </script>
    </form>
</body>
</html>

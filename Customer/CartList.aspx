<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CartList.aspx.cs" Inherits="WebDienThoai.Customer.CartList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
 <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
 <link href="../css/style.css" rel="stylesheet" />
    <title></title>

</head>
<body>
    <form id="form1" runat="server">
        <div>
                    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold fs-4" href="#">
                    <i class="fas fa-mobile-alt me-2"></i>PhoneStore
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-lg-center">
                        <li class="nav-item">
                            <a class="nav-link active" href="default.aspx"><i class="fas fa-home me-1"></i>Trang chủ</a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-mobile me-1"></i>Danh mục sản phẩm
                            </a>
                            <ul class="dropdown-menu p-3" style="min-width: 520px;">
                                <asp:Repeater ID="rptMenu" runat="server">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-start mb-2">
                                            <h6 class="fw-bold text-primary mb-0 me-3 text-nowrap">
                                                <%# Eval("TenLoai") %>
                                            </h6>
                                            <div class="flex-grow-1">
                                                <div class="row">

                                                    <div class="col-6 mb-2">
                                                        <h6 class="fw-bold text-primary mb-2 me-3 text-center text-nowrap">Thương Hiệu</h6>
                                                        <div class="d-flex flex-wrap gap-2 text-center">
                                                            <asp:Repeater runat="server"
                                                                DataSource='<%# Eval("ThuongHieu") %>'>
                                                                <ItemTemplate>
                                                                    <a href="Product.aspx?mansx=<%# Eval("MaNSX") %>"">
                                                                        <img src="../imgs/<%# Eval("Logo") %>"
                                                                            class="img-thumbnail"
                                                                            style="width: 48px; height: 48px; object-fit: contain; cursor: pointer;" />
                                                                    </a>
                                                                </ItemTemplate>
                                                            </asp:Repeater>
                                                        </div>
                                                    </div>

                                                    <div class="col-6">
                                                        <h6 class="fw-bold text-danger mb-2 me-3 text-nowrap">Sản Phẩm HOT</h6>
                                                        <asp:Repeater runat="server"
                                                            DataSource='<%# Eval("SanPhamNoiBat") %>'>
                                                            <ItemTemplate>
                                                                <a href="Detail.aspx?id=<%# Eval("MaSP") %>"
                                                                    class="d-block text-decoration-none text-dark small mb-1">
                                                                    <%# Eval("TenSP") %>
                                                                </a>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </div>

                                                </div>

                                            </div>
                                        </div>

                                        <hr class="my-2" />

                                    </ItemTemplate>
                                </asp:Repeater>
                            </ul>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#"><i class="fas fa-tags me-1"></i>Khuyến mãi</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#"><i class="fas fa-newspaper me-1"></i>Tin tức</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#"><i class="fas fa-phone me-1"></i>Liên hệ</a>
                        </li>
                    </ul>
                    <div class="d-flex ms-lg-3 mt-3 mt-lg-0 gap-2">
                        <a href="#" class="btn btn-outline-light">
                            <i class="fas fa-search"></i>
                        </a>
                        <a href="CartList.aspx" class="btn btn-outline-light position-relative">
                            <i class="fas fa-shopping-cart"></i>
                             <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="cartCount"><%= CartCount %></span>
                        </a>
                        <a id="btnLogin" runat="server" href="../login.aspx" class="btn btn-light">
                            <i class="fas fa-user me-1"></i> Đăng nhập
                        </a>
                        <asp:LinkButton ID="btnLogout" runat="server" CssClass="btn btn-danger d-flex align-items-center" OnClick="btnLogout_Click">
                        <i class="fas fa-sign-out-alt me-1"></i> Đăng xuất
                    </asp:LinkButton>
                           <div class="d-flex align-items-center">
    <span id="spAccount" runat="server" class="fw-semibold text-white">Account</span>
</div>

                    </div>
                </div>
            </div>
        </nav>

            <div class="container my-4" style="max-width: 900px;">
                <h2 class="mb-4 text-center">Giỏ hàng của bạn</h2>

                <div class="row g-3">
                    <%if (CartCount > 0)
                        {  %>
                    <asp:Repeater ID="rpCart" runat="server">
                        <ItemTemplate>
                    <div class="col-12">
                        <div class="card shadow-sm p-3">
                            <div class="row align-items-center">
                                <div class="col-md-3 text-center">
                                    <img src="../imgs/<%# Eval("SanPham.AnhSP") %>" class="img-fluid rounded" alt="<%# Eval("SanPham.TenSP") %>">
                                </div>
                                <div class="col-md-9">
                                    <a href="Detail.aspx?masp=<%# Eval("SanPham.MaSP") %>" class="h5 text-decoration-none text-dark d-block mb-2">
                                        <%# Eval("SanPham.TenSP") %> - <%# Eval("MauSac.TenMau") %>
                                    </a>
                                    <span class="badge ms-2" style="background-color:<%# Eval("MauSac.MaMauHex") %>;">
    &nbsp;
</span>
                                    <p class="text-danger fw-bold mb-2"><%# Eval("SanPham.DonGia", "{0:N0}") %></p>

                                    <div class="d-flex align-items-center gap-2 mb-2">
                                        <div class="input-group" style="width: 130px;">
                                            <button type="button" class="btn btn-outline-secondary btn-decrease"
        data-id="<%# Eval("SanPham.MaSP") %>">-</button>

<input type="number" class="form-control text-center qty"
       value="<%# Eval("SoLuong") %>" min="1" max="99"
       data-id="<%# Eval("SanPham.MaSP") %>">

<button type="button" class="btn btn-outline-secondary btn-increase"
        data-id="<%# Eval("SanPham.MaSP") %>">+</button>
                                        </div>
                                        <button type="button" class="btn btn-outline-danger btn-sm btn-remove"
        data-id="<%# Eval("SanPham.MaSP") %>">
    <i class="fas fa-trash me-1"></i>Xóa
</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <% }%>
                    <%else
                        {  %>
                      <div>Không có đơn hàng nào! Hãy bắt đầu mua sắm <asp:HyperLink runat="server" ID="hplMuaSach" NavigateUrl="~/Customer/default.aspx" Text="tại đây"></asp:HyperLink></div>
                    <%} %>
                </div>
            </div>

            <div class="card shadow-sm p-3 d-flex flex-row justify-content-between align-items-center position-fixed bottom-0 start-50 translate-middle-x w-50" style="z-index: 1050;">
                <div class="fw-bold fs-5">
                    <strong>Tổng tiền: <b></b></strong>
 <asp:Label ID="lblTongTien" CssClass="text-danger fw-bold" runat="server" Text=""></asp:Label>
                </div>
                <asp:Button ID="btnDatHang" OnClick="btnDatHang_Click" class="btn btn-success btn-lg" runat="server" Text="Đặt hàng" />
            </div>
        </div>
      <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    function callCart(masp, soluong, action, row) {

        $.ajax({
            type: "POST",
            url: "CartList.aspx/UpdateCart",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({
                masp: masp,
                soluong: soluong,
                action: action
            }),

            success: function (res) {

                if (!res.d.ok) return;
                $("#<%= lblTongTien.ClientID %>").text(res.d.total);
                if (action === "remove")
                    $(row).closest(".col-12").remove();
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
        let input = btn.parent().find(".qty");

        let newQty = parseInt(input.val()) + 1;

        callCart(id, newQty, "set", btn);
        input.val(newQty);
    });

    $(document).on("click", ".btn-decrease", function () {

        let btn = $(this);
        let id = parseInt(btn.data("id"));
        let input = btn.parent().find(".qty");

        let newQty = parseInt(input.val()) - 1;

        // <= 0 => xoá luôn
        if (newQty <= 0) {
            callCart(id, 0, "remove", btn);
            return;
        }

        callCart(id, newQty, "set", btn);
        input.val(newQty);
    });




    $(document).on("click", ".btn-remove", function () {

        let btn = $(this);
        let id = parseInt(btn.data("id"));

        callCart(id, 0, "remove", btn);
    });
    $(document).on("change", ".qty", function () {

        let input = $(this);
        let btn = input.parent().find("[data-id]");
        let id = parseInt(btn.data("id"));
        let qty = parseInt(input.val());

        if (isNaN(qty) || qty <= 0) {
            callCart(id, 0, "remove", input);
            return;
        }

        callCart(id, qty, "set", input);
    });

</script>
    </form>
</body>
</html>

<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebDienThoai.Admin.index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row align-items-center mb-4">
        <div class="col-md-6">
            <h3 class="page-title mb-1">Chào mừng trở lại, Admin!</h3>
            <p class="text-muted small">Dưới đây là tóm tắt hoạt động của PhoneStore ngày hôm nay.</p>
        </div>
        <div class="col-md-6 text-md-end">
            <div class="d-inline-flex align-items-center bg-white px-3 py-2 rounded-pill shadow-sm">
                <i class="far fa-calendar-alt text-primary me-2"></i>
                <span class="small fw-bold text-dark"><%= DateTime.Now.ToString("dd MMMM, yyyy") %></span>
            </div>
        </div>
    </div>

    <!-- Stat Cards -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-md-6">
            <div class="stat-card shadow-sm">
                <div class="stat-icon icon-revenue"><i class="fas fa-wallet"></i></div>
                <asp:Literal ID="litDoanhThuHomNay" runat="server" />
                <div class="stat-label">Doanh thu hôm nay</div>
                <div class="mt-2 small text-success fw-bold"><i class="<%= IconDoanhThu %>"></i><%= PhamTramDoanhThu %> </div>

            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stat-card shadow-sm">
                <div class="stat-icon icon-orders"><i class="fas fa-shopping-bag"></i></div>
                <asp:Literal ID="litDonHangHomNay" runat="server" />
                <div class="stat-label">Đơn hàng mới</div>
                <div class="mt-2 small text-warning fw-bold">
                    <i class="fas fa-clock me-1"></i>
                    <asp:Label ID="lblDonChoXuLy" runat="server"></asp:Label>
                    đơn chờ xử lý
                </div>

            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stat-card shadow-sm">
                <div class="stat-icon icon-products"><i class="fas fa-mobile-screen-button"></i></div>
                <asp:Literal ID="litTonKho" runat="server" />
                <div class="stat-label">Sản phẩm trong kho</div>
                <div class="mt-2 small text-primary fw-bold">
                    <asp:Label ID="lblSoThuongHieu" runat="server"></asp:Label>
                    thương hiệu
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6">
            <div class="stat-card shadow-sm">
                <div class="stat-icon icon-users"><i class="fas fa-user-plus"></i></div>
                <asp:Literal ID="litKhachHangMoi" runat="server" />
                <div class="stat-label">Khách hàng mới</div>
                <div class="mt-2 small text-muted font-italic"><%= PhamTramKhachHang %></div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Biểu đồ doanh thu -->
        <div class="col-lg-8">
            <div class="card card-custom shadow-sm h-100">
                <div class="card-header-custom">
                    <h6 class="card-title-custom">Doanh thu theo tháng</h6>

                </div>
                <div class="card-body p-4 text-center">
                    <div class="py-5 bg-light rounded-4 border border-dashed text-muted">
                        <canvas id="revenueChart" height="100"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sản phẩm bán chạy -->
        <div class="col-lg-4">
            <div class="card card-custom shadow-sm h-100">
                <div class="card-header-custom">
                    <h6 class="card-title-custom">Sản phẩm bán chạy</h6>
                </div>
                <div class="card-body p-4">
                    <asp:Repeater ID="rptTopProducts" runat="server">
                        <ItemTemplate>
                            <div class="product-mini-item mb-3">
                                <img src="../imgs/<%# Eval("ProductImg") %>" class="product-mini-img" alt="Product">

                                <div class="flex-grow-1">
                                    <div class="fw-bold small text-dark">
                                        <%# Eval("ProductName") %>
                                    </div>
                                    <div class="text-muted" style="font-size: 0.7rem;">
                                        <%# Eval("TotalSold") %> lượt bán
                           
                                    </div>
                                </div>

                                <div class="fw-bold text-primary small">
                                    <%# string.Format("{0:N0} ₫", Eval("Price")) %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                </div>
            </div>
        </div>

        <!-- Đơn hàng gần đây -->
        <div class="col-12">
            <div class="card card-custom shadow-sm">
                <div class="card-header-custom">
                    <h6 class="card-title-custom">Đơn hàng mới nhất</h6>
                    <a href="Orders.aspx" class="btn btn-link btn-sm text-decoration-none fw-bold p-0">Xem tất cả</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-custom mb-0">
                        <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Khách hàng</th>
                                <th>Sản phẩm</th>
                                <th>Thời gian</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptRecentOrders" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold text-primary">
                                            <%# Eval("OrderId") %>
                </td>

                                        <td class="fw-bold">
                                            <%# Eval("CustomerName") %>
                </td>

                                        <td>Đơn hàng
                </td>

                                        <td class="small">
                                            <%# Convert.ToDateTime(Eval("OrderDate")).ToString("HH:mm - dd/MM") %>
                </td>

                                        <td class="fw-bold">
                                            <%# string.Format("{0:N0} ₫", Eval("TotalMoney")) %>
                </td>

                                        <td>
                                            <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'>
                                                <%# Eval("Status") %>
                    </span>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="../js/Admin/chart.js"></script>

</asp:Content>

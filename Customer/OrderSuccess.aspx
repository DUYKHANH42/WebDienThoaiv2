<%@ Page Title="Đặt hàng thành công" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="OrderSuccess.aspx.cs" Inherits="WebDienThoai.Customer.OrderSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="container py-5 my-5">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8 text-center">
                <div class="card success-card shadow-sm">
                    <div class="card-body p-5">
                        <!-- Icon thành công -->
                        <div class="success-icon-wrapper"><i class="fas fa-check-circle" style="font-size: 50px;"></i></div>
                        <!-- Tiêu đề -->
                        <h2 class="fw-bold text-dark mb-3">Đặt hàng thành công!</h2>
                        <div class="order-id-badge">Mã đơn hàng: #<%= Request.QueryString["soDH"] ?? "12345" %> </div>
                        <!-- Thông điệp -->
                        <p class="text-muted fs-5 px-lg-4">Cảm ơn bạn đã tin tưởng mua hàng tại <strong>PhoneStore</strong>. Đơn hàng của bạn đang được đội ngũ nhân viên xử lý và sẽ sớm giao đến bạn. </p>
                        <div class="alert alert-warning border-0 rounded-4 py-3 mt-4 small"><i class="fas fa-info-circle me-2"></i>Nhân viên tư vấn sẽ liên hệ với bạn qua số điện thoại để xác nhận đơn hàng trong vòng 15-30 phút. </div>
                        <hr class="my-4 opacity-10" />
                        <!-- Nút điều hướng -->
                        <div class="d-grid gap-3 d-sm-flex justify-content-sm-center mt-4"><a href="Default.aspx" class="btn btn-pill btn-primary-custom text-white px-4 py-3"><i class="fas fa-home me-2"></i>Quay về trang chủ </a><a href="DonHang.aspx" class="btn btn-pill btn-outline-secondary px-4 py-3"><i class="fas fa-box-open me-2"></i>Xem đơn hàng của tôi </a></div>
                    </div>
                </div>
                <!-- Footer phụ dưới card -->
                <div class="mt-4 text-muted small">Bạn cần hỗ trợ? <a href="#" class="text-primary fw-bold text-decoration-none">Liên hệ ngay 1800 6601</a> </div>
            </div>
        </div>
    </div>
</asp:Content>

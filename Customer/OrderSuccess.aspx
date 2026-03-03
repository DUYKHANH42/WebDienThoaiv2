<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="OrderSuccess.aspx.cs" Inherits="WebDienThoai.Customer.OrderSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 text-center">

            <div class="card shadow-lg border-0">
                <div class="card-body p-5">

                    <!-- Icon -->
                    <div class="mb-4">
                        <i class="bi bi-check-circle-fill text-success" style="font-size:70px;"></i>
                    </div>

                    <!-- Title -->
                    <h2 class="text-success fw-bold">Đặt hàng thành công!</h2>

                    <!-- Message -->
                    <p class="text-muted mt-3">
                        Cảm ơn bạn đã mua hàng tại cửa hàng.<br />
                        Đơn hàng của bạn đang được xử lý và sẽ sớm giao đến bạn.
                    </p>

                    <hr />

                    <!-- Buttons -->
                    <div class="d-grid gap-2 mt-4">
                        <a href="default.aspx" class="btn btn-primary btn-lg">
                            🏠 Quay về trang chủ
                        </a>

                        <a href="DonHang.aspx" class="btn btn-outline-secondary">
                            📦 Xem đơn hàng của tôi
                        </a>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

</asp:Content>

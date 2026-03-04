<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="DonHang.aspx.cs" Inherits="WebDienThoai.Customer.DonHang" %>

<%@ Register Src="~/Customer/CustomerSidebar.ascx"
    TagPrefix="uc"
    TagName="Sidebar" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        
    </style>

    <div class="order-container">
        <div class="container">
            <div class="row g-4">

                <uc:Sidebar runat="server" />

                <!-- Main Content -->
                <div class="col-lg-9">
                    <div class="profile-card shadow-sm order-content h-100">
                        <h4 class="fw-bold mb-4">Đơn hàng của tôi</h4>
                        <asp:ScriptManager ID="ScriptManager1" runat="server" />

                        <asp:UpdatePanel ID="updOrders" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <!-- Tabs Trạng thái -->
                                <div class="nav-tabs-custom">
                                    <asp:LinkButton ID="btnAll" runat="server"
                                        CssClass="nav-link active"
                                        CommandArgument="All"
                                        OnClick="FilterOrders">Tất cả</asp:LinkButton>
                                    <asp:LinkButton ID="btnAwaiting" runat="server"
                                        CssClass="nav-link"
                                        CommandArgument="1"
                                        OnClick="FilterOrders">Chờ xác nhận</asp:LinkButton>
                                    <asp:LinkButton ID="btnPending" runat="server"
                                        CssClass="nav-link"
                                        CommandArgument="2"
                                        OnClick="FilterOrders">Chờ xử lý</asp:LinkButton>

                                    <asp:LinkButton ID="btnShipping" runat="server"
                                        CssClass="nav-link"
                                        CommandArgument="3"
                                        OnClick="FilterOrders">Đang giao</asp:LinkButton>

                                    <asp:LinkButton ID="btnCompleted" runat="server"
                                        CssClass="nav-link"
                                        CommandArgument="4"
                                        OnClick="FilterOrders">Đã hoàn thành</asp:LinkButton>

                                    <asp:LinkButton ID="btnCancelled" runat="server"
                                        CssClass="nav-link"
                                        CommandArgument="5"
                                        OnClick="FilterOrders">Đã hủy</asp:LinkButton>
                                </div>

                                <!-- Danh sách đơn hàng -->
                                <asp:Repeater ID="rptOrders" runat="server">
                                    <ItemTemplate>
                                        <div class="order-item-card">
                                            <div class="order-header">
                                                <div class="small fw-bold text-muted text-uppercase">Mã đơn hàng: <span class="text-dark">#<%# Eval("SoDH") %></span></div>
                                                <div class='status-badge 
<%# Eval("MaTrangThai").ToString() == "1" ? "status-waiting" :
    Eval("MaTrangThai").ToString() == "2" ? "status-processing" :
    Eval("MaTrangThai").ToString() == "3" ? "status-shipping" :
    Eval("MaTrangThai").ToString() == "4" ? "status-completed" :
    Eval("MaTrangThai").ToString() == "5" ? "status-cancelled" : "" %>'>

                                                    <%# Eval("TenTrangThai") %>
                                                </div>
                                            </div>
                                            <div class="order-body">
                                                <div class="row align-items-center">
                                                    <div class="col-md-2 text-center">
                                                        <img src='../imgs/<%# Eval("AnhSP") %>' class="img-fluid rounded" style="max-height: 80px;" alt="Product">
                                                    </div>
                                                    <div class="col-md-7">
                                                        <h6 class="fw-bold mb-1"><%# Eval("TenSP") %></h6>
                                                        <p class="text-muted small mb-0">Phân loại: <%# Eval("MauSac") %> | Số lượng: x<%# Eval("SoLuong") %></p>
                                                        <p class="text-muted small">Ngày đặt: <%# Eval("NgayDH", "{0:dd/MM/yyyy}") %></p>
                                                    </div>
                                                    <div class="col-md-3 text-end">
                                                        <div class="fw-bold text-danger fs-5"><%# Eval("ThanhTien", "{0:N0}") %> ₫</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="order-footer">
                                                <asp:PlaceHolder ID="phReviewed" runat="server"
                                                    Visible='<%# Eval("SoSao") != DBNull.Value %>'>

                                                    <div class="text-success small fw-bold mb-2">
                                                        Bạn đã đánh giá:
           
                                                        <%# new string('★', Convert.ToInt32(Eval("SoSao"))) %>
                                                    </div>
                                                </asp:PlaceHolder>

                                                <div class="d-flex gap-2">

                                                    <!-- Nút đánh giá chỉ hiện khi chưa đánh giá và đã hoàn thành -->
                                                    <asp:PlaceHolder ID="phReviewBtn" runat="server"
                                                        Visible='<%# Eval("MaTrangThai").ToString() == "4" && Eval("SoSao") == DBNull.Value %>'>

                                                        <button type="button"
                                                            class="btn btn-primary btn-action"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#modalReview"
                                                            onclick='setReviewData(<%# Eval("MaSP") %>, "<%# Eval("TenSP") %>")'>
                                                            Đánh giá ngay
           
                                                        </button>
                                                    </asp:PlaceHolder>

                                                    <asp:Button ID="btnReorder" runat="server"
                                                        Text="Mua lại"
                                                        CssClass="btn btn-outline-primary btn-action"
                                                        CommandArgument='<%# Eval("MaSP") + "|" + Eval("MaMau") + "|" + Eval("SoLuong") %>'
                                                         OnClick="btnReorder_Click"
                                                        Visible='<%# Eval("MaTrangThai").ToString() == "4" %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL ĐÁNH GIÁ SẢN PHẨM -->
    <div class="modal fade" id="modalReview" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 25px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Đánh giá sản phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <h6 id="reviewProductName" class="fw-bold text-primary mb-3">Tên sản phẩm</h6>
                    <div class="star-rating mb-4" id="ratingStars">
                        <i class="fas fa-star" data-value="1"></i>
                        <i class="fas fa-star" data-value="2"></i>
                        <i class="fas fa-star" data-value="3"></i>
                        <i class="fas fa-star" data-value="4"></i>
                        <i class="fas fa-star" data-value="5"></i>
                    </div>
                    <asp:HiddenField ID="hfRating" runat="server" Value="5" />
                    <asp:HiddenField ID="hfReviewMaSP" runat="server" />

                    <div class="text-start">
                        <label class="form-label small fw-bold">Nhận xét của bạn</label>
                        <asp:TextBox ID="txtReviewContent" runat="server" CssClass="form-control rounded-4" TextMode="MultiLine" Rows="4" placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..."></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 px-4 pb-4 justify-content-center">
                    <asp:Button ID="btnSubmitReview" OnClick="btnSubmitReview_Click" runat="server" Text="Gửi đánh giá" CssClass="btn btn-primary rounded-pill px-5 fw-bold" />
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        // Xử lý dữ liệu nạp vào Modal đánh giá
        function setReviewData(maSP, tenSP) {
            document.getElementById('reviewProductName').innerText = tenSP;
            document.getElementById('<%= hfReviewMaSP.ClientID %>').value = maSP;
        }

        // Xử lý chọn sao
        document.querySelectorAll('#ratingStars i').forEach(star => {
            star.addEventListener('click', function () {
                let value = this.getAttribute('data-value');
                document.getElementById('<%= hfRating.ClientID %>').value = value;

                document.querySelectorAll('#ratingStars i').forEach(s => {
                    if (s.getAttribute('data-value') <= value) {
                        s.classList.add('selected');
                    } else {
                        s.classList.remove('selected');
                    }
                });
            });
        });

        // Mặc định 5 sao
        document.querySelectorAll('#ratingStars i').forEach(s => s.classList.add('selected'));
    </script>
</asp:Content>

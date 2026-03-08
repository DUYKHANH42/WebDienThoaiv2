<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="WebDienThoai.Admin.Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="page-title">Quản Lý Đơn Hàng</h3>
        <button class="btn btn-outline-success btn-pill fw-bold"><i class="fas fa-file-excel me-2"></i>Xuất Excel</button>
    </div>
    <asp:UpdatePanel ID="updDonHang" runat="server">
        <ContentTemplate>

            <div class="nav-tabs-orders">

                <asp:LinkButton ID="btnAll" runat="server"
                    CssClass="nav-link active"
                    CommandArgument="0"
                    OnClick="Filter_Click">Tất cả</asp:LinkButton>
                <asp:LinkButton ID="btnAwaiting" runat="server"
                    CssClass="nav-link"
                    CommandArgument="1"
                    OnClick="Filter_Click">Chờ xác nhận</asp:LinkButton>
                <asp:LinkButton ID="btnPending" runat="server"
                    CssClass="nav-link"
                    CommandArgument="2"
                    OnClick="Filter_Click">Chờ xử lý</asp:LinkButton>

                <asp:LinkButton ID="btnShipping" runat="server"
                    CssClass="nav-link"
                    CommandArgument="3"
                    OnClick="Filter_Click">Đang giao</asp:LinkButton>

                <asp:LinkButton ID="btnCompleted" runat="server"
                    CssClass="nav-link"
                    CommandArgument="4"
                    OnClick="Filter_Click">Đã hoàn thành</asp:LinkButton>

                <asp:LinkButton ID="btnCancelled" runat="server"
                    CssClass="nav-link"
                    CommandArgument="5"
                    OnClick="Filter_Click">Đã hủy</asp:LinkButton>

            </div>

            <!-- Bộ lọc -->
            <div class="filter-card shadow-sm">
                <div class="row g-3">

                    <div class="col-md-4">
                        <asp:TextBox ID="txtSearch" runat="server"
                            CssClass="form-control rounded-pill border-light bg-light"
                            placeholder="Tìm theo mã đơn hoặc tên khách..." />
                    </div>

                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlThanhToan" runat="server"
                            CssClass="form-select rounded-pill border-light bg-light">
                            <asp:ListItem Text="Mọi phương thức thanh toán" Value="" />
                            <asp:ListItem Text="COD" Value="COD" />
                            <asp:ListItem Text="Chuyển khoản" Value="Chuyển khoản" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-3">
                        <asp:TextBox ID="txtNgay" runat="server"
                            TextMode="Date"
                            CssClass="form-control rounded-pill border-light bg-light" />
                    </div>

                    <div class="col-md-2">
                        <asp:Button ID="btnFilter" runat="server"
                            Text="Lọc dữ liệu"
                            CssClass="btn btn-primary btn-pill w-100 shadow-sm"
                            OnClick="btnFilter_Click" />
                    </div>

                </div>
            </div>

            <!-- Danh sách Đơn hàng -->
            <div class="table-container shadow-sm mb-5">
                <table class="table table-modern text-center align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Mã Đơn</th>
                            <th class="text-start">Khách Hàng</th>
                            <th>Ngày Đặt</th>
                            <th>Tổng Tiền</th>
                            <th>Thanh Toán</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptDonHang" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td class="fw-bold text-primary">#<%# Eval("MaDonHang") %>
                                    </td>

                                    <td class="text-start">
                                        <div class="fw-bold text-dark">
                                            <%# Eval("TenKH") %>
                                        </div>
                                        <div class="text-muted small">
                                            <%# Eval("DienThoai") %>
                                        </div>
                                    </td>

                                    <td class="small">
                                        <%# Convert.ToDateTime(Eval("NgayDH")).ToString("dd/MM/yyyy") %><br />
                                        <%# Convert.ToDateTime(Eval("NgayDH")).ToString("HH:mm") %>
                                    </td>

                                    <td class="fw-bold text-danger">
                                        <%# String.Format("{0:N0}", Eval("TongTien")) %> ₫
                                    </td>

                                    <td>
                                        <span class="badge bg-light text-dark border rounded-pill px-2">
                                            <%# Eval("PhuongThucThanhToan") %>
                                        </span>
                                    </td>

                                    <td>
                                        <span class="badge-soft status-pending">
                                            <%# Eval("TenTrangThai") %>
                                        </span>
                                    </td>

                                    <td>
                                        <asp:Button ID="btnView" runat="server"
                                            CssClass="btn btn-light btn-sm rounded-circle shadow-sm border btn-view-detail"
                                            CommandArgument='<%# Eval("SoDH") %>'
                                            OnCommand="btnView_Command"
                                            Text="👁"
                                            CausesValidation="false"
                                            UseSubmitBehavior="false"
                                            title="Xem chi tiết" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <!-- Footer Pagination -->
            <div class="px-6 py-4 flex flex-col sm:flex-row items-center justify-between gap-4 border-t border-slate-50 bg-slate-50/30">

                <div class="text-xs font-bold text-slate-500">
                    Hiển thị 
                            <span class="text-slate-900">
                                <asp:Literal ID="ltrFromTo" runat="server"></asp:Literal>
                            </span>
                    trong 
                            <span class="text-slate-900">
                                <asp:Literal ID="ltrTotal" runat="server"></asp:Literal>
                            </span>
                    đơn hàng
                </div>

                <div class="flex items-center gap-1.5">

                    <!-- Prev -->
                    <asp:LinkButton
                        ID="btnPrev"
                        runat="server"
                        CausesValidation="false"
                        CssClass="size-8 flex items-center justify-center rounded-lg text-slate-400 hover:bg-white hover:text-primary transition-all shadow-sm border border-transparent hover:border-slate-200"
                        OnClick="btnPrev_Click">

<span class="material-symbols-outlined text-lg">chevron_left</span>

                    </asp:LinkButton>

                    <!-- Paging -->
                    <asp:Repeater ID="rpPaging" runat="server" OnItemCommand="rpPaging_ItemCommand">
                        <ItemTemplate>

                            <asp:LinkButton
                                ID="btnPage"
                                runat="server"
                                CommandName="Page"
                                CommandArgument='<%# Eval("Page") %>'
                                CssClass='<%# Eval("Css") %>'>

<%# Eval("Page") %>

                            </asp:LinkButton>

                        </ItemTemplate>
                    </asp:Repeater>

                    <!-- Next -->
                    <asp:LinkButton
                        ID="btnNext"
                        runat="server"
                        CausesValidation="false"
                        CssClass="size-8 flex items-center justify-center rounded-lg text-slate-600 hover:bg-white hover:text-primary transition-all shadow-sm border border-transparent hover:border-slate-200"
                        OnClick="btnNext_Click">

<span class="material-symbols-outlined text-lg">chevron_right</span>

                    </asp:LinkButton>

                </div>
            </div>

            <asp:HiddenField ID="hfOrderID" runat="server" />
            <div class="modal fade" id="modalOrderManager" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-xl modal-dialog-centered">
                    <div class="modal-content border-0 shadow-lg" style="border-radius: 30px; overflow: hidden;">
                        <div class="modal-header border-0 bg-white p-4 pb-0">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-primary-subtle p-3 rounded-4">
                                    <i class="fas fa-file-invoice text-primary fs-4"></i>
                                </div>
                                <div>
                                    <h4 class="fw-bold mb-0">Quản lý Đơn hàng 
 <span class="text-primary">#<asp:Literal ID="litMaDonHang" runat="server" /></span>
                                    </h4>

                                    <span class="text-muted small">Khách hàng: 
 <strong>
     <asp:Literal ID="litTenKH" runat="server" /></strong> | 
 <asp:Literal ID="litSDT" runat="server" />
                                    </span>
                                </div>
                            </div>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body p-4">
                            <div class="row g-4">
                                <!-- CỘT TRÁI: CHI TIẾT SẢN PHẨM & DỮ LIỆU ĐƠN HÀNG -->
                                <div class="col-lg-8 border-end">
                                    <div class="section-title-sm mb-3">SẢN PHẨM ĐÃ ĐẶT</div>
                                    <div class="table-responsive rounded-4 border mb-4">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="bg-light">
                                                <tr class="small text-muted fw-bold">
                                                    <th class="ps-3">Sản phẩm</th>
                                                    <th>Phân loại</th>
                                                    <th class="text-center">Số lượng</th>
                                                    <th class="text-end pe-3">Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <asp:Repeater ID="rptOrderItems" runat="server">
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td class="ps-3 py-3">
                                                                <div class="d-flex align-items-center">
                                                                    <img src="../imgs/<%# Eval("AnhSP") %>" class="rounded-3 me-3 border" style="width: 50px; height: 50px; object-fit: cover;">
                                                                    <div class="fw-bold text-dark"><%# Eval("TenSP") %></div>
                                                                </div>
                                                            </td>
                                                            <td class="small text-muted"><%# Eval("TenMau") %>, <%# Eval("DungLuong") %></td>
                                                            <td class="text-center fw-bold">x<%# Eval("SoLuong") %></td>
                                                            <td class="text-end pe-3 fw-bold text-primary"><%# Eval("ThanhTien", "{0:N0}") %> ₫</td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <div class="bg-light p-3 rounded-4">
                                                <h6 class="fw-bold small mb-2 text-muted uppercase"><i class="fas fa-map-marker-alt me-2"></i>Địa chỉ nhận hàng</h6>
                                                <p class="small mb-0 fw-bold text-dark">
                                                    <asp:Literal ID="litDiaChi" runat="server" />
                                                </p>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="col-lg-4">
                                    <div class="card border-0 bg-primary-subtle rounded-4 p-4 mb-4">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span class="text-primary small fw-bold">Tổng tiền đơn hàng</span>
                                            <h4 class="fw-bold text-primary mb-0">
                                                <asp:Literal ID="litTongTien" runat="server" />
                                            </h4>
                                        </div>
                                        <asp:Literal ID="litThanhToan" runat="server" />
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label small fw-bold text-muted text-uppercase mb-3"><i class="fas fa-sync-alt me-2"></i>Cập nhật Trạng thái</label>
                                        <asp:DropDownList ID="ddlOrderStatus" runat="server" CssClass="form-select border-0 shadow-sm py-3 px-3 mb-3" Style="border-radius: 15px; background: #f8fafc;">
                                            <asp:ListItem Text="Chờ xác nhận" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="Đang xử lý" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="Đang giao" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="Hoàn tất" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="Đã huỷ" Value="5"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <asp:Button ID="btnUpdateOrder" runat="server" Text="LƯU THAY ĐỔI" CssClass="btn btn-primary btn-pill py-3 fw-bold shadow" OnClick="UpdateStatus_Click" />
                                        <button type="button" class="btn btn-light btn-pill py-2 text-muted small border-0" data-bs-dismiss="modal">Đóng cửa sổ</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer border-0 p-4 pt-0 bg-light-subtle d-flex justify-content-between">

                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-outline-dark btn-pill btn-sm px-3 fw-bold"><i class="fas fa-print me-2"></i>In hóa đơn</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>

    </asp:UpdatePanel>


</asp:Content>

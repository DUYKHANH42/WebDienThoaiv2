<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="Product.aspx.cs" Inherits="WebDienThoai.Customer.Product" %>

<asp:Content ID="SanPham" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Product Details Section -->
    <div class="container mt-5">
        <div class="breadcrumb-wrapper">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="Default.aspx"><i class="fas fa-home"></i>Trang chủ</a></li>
                <li class="breadcrumb-item active" aria-current="page">Tất cả điện thoại</li>
            </ol>
        </nav>
    </div>
</div>
        <!-- Gợi ý sản phẩm hot -->
        <section class="py-4 bg-light">
            <div class="container">
                <h3 class="mb-3 fw-bold text-danger">Sản phẩm HOT</h3>
                <div class="d-flex flex-row flex-nowrap overflow-auto">
                    <asp:Repeater ID="rptSanPhamHot" DataSourceID="dsSanPhamHot" runat="server">
                        <ItemTemplate>
                            <div class="me-3">
                                <a href='Detail.aspx?masp=<%# Eval("MaSP") %>&mansx=<%# Eval("mansx") %>' class="text-decoration-none">
                                    <span class="badge bg-danger p-2 d-inline-flex align-items-center">
                                        <i class="fas fa-star text-warning me-1"></i>
                                        <%# Eval("TenSP") %>
                                    </span>
                                </a>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </section>
        <asp:ScriptManager runat="server" />
        <asp:UpdatePanel ID="upProduct" runat="server">
            <ContentTemplate>

                <div class="row mt-3">
                    <div class="col-md-3">
                        <div class="card p-3 shadow-sm">

                            <h6 class="fw-bold mb-3">Bộ lọc</h6>
                            <div class="mb-3">
                                <label class="form-label small">Sắp xếp theo giá</label>
                                <asp:DropDownList
                                    ID="ddlSort"
                                    runat="server"
                                    CssClass="form-select"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                                    <asp:ListItem Text="Giá tăng dần" Value="asc" />
                                    <asp:ListItem Text="Giá giảm dần" Value="desc" />
                                </asp:DropDownList>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small">Khoảng giá</label>
                                <asp:DropDownList
                                    ID="ddlGia"
                                    runat="server"
                                    CssClass="form-select"
                                    AutoPostBack="true"
                                    OnSelectedIndexChanged="Filter_Changed">
                                    <asp:ListItem Text="Tất cả giá" Value="0" />
                                    <asp:ListItem Text="Dưới 5 triệu" Value="1" />
                                    <asp:ListItem Text="5 – 10 triệu" Value="2" />
                                    <asp:ListItem Text="10 – 20 triệu" Value="3" />
                                    <asp:ListItem Text="Trên 20 triệu" Value="4" />
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-9">

                        <asp:FormView ID="fvChuDe" runat="server" DataSourceID="NXB">
                            <ItemTemplate>
                                <h4 class="fw-bold mb-4 text-center"><%# Eval("TenNSX") %></h4>
                            </ItemTemplate>
                        </asp:FormView>

                        <div class="row g-4">
                            <asp:Repeater ID="rptDanhMuc" runat="server">
                                <ItemTemplate>
                                    <div class="col-md-4">
                                        <div class="card product-card h-100">
                                            <a href="Detail.aspx?masp=<%# Eval("masp") %>&mansx=<%# Eval("mansx") %>"
                                                class="text-decoration-none text-reset">
                                                <img src="../imgs/<%# Eval("AnhSP") %>"
                                                    class="card-img-top product-img"
                                                    alt="<%# Eval("TenSP") %>">
                                                <div class="card-body">
                                                    <h6 class="card-title"><%# Eval("TenSP") %></h6>
                                                    <p class="small text-muted mb-1">
                                                        <%# Eval("dungluong") %> - <%# Eval("thitruong") %>
                                                    </p>
                                                    <span class="fw-bold text-danger">
                                                        <%# Eval("GiaMin", "{0:N0}") %> ₫
                                                    </span>
                                                </div>
                                            </a>
                                            <div class="p-2">
                                                <a href='Detail.aspx?masp=<%# Eval("MaSP") %>'
                                                    class="btn btn-primary btn-lg w-100 mt-2">
                                                    <i class="fas fa-eye me-2"></i>
                                                    Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="text-center mt-4 mb-4">
                            <asp:Button
                                ID="btnHienThiThem"
                                runat="server"
                                Text="Hiển thị thêm sản phẩm"
                                CssClass="btn btn-danger btn-sm px-4"
                                OnClick="btnHienThiThem_Click" />
                        </div>

                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddlSort" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="ddlGia" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="btnHienThiThem" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>



    </div>
    <asp:SqlDataSource ID="NXB" runat="server" ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>" SelectCommand="SELECT * FROM [NhaSanXuat] WHERE ([MaNSX] = @MaNSX)">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaNSX" QueryStringField="mansx" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsSanPhamHot" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT TOP 5 * FROM SanPham where DaXoa != 1 ORDER BY DonGia DESC"></asp:SqlDataSource>
</asp:Content>

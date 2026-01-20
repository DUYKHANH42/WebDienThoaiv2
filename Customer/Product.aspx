<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="Product.aspx.cs" Inherits="WebDienThoai.Customer.Product" %>

<asp:Content ID="SanPham" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Product Details Section -->
    <div class="container mt-5">
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

                <div class="d-flex gap-2 mb-3 mt-2">
                    <!-- Dropdown sắp xếp -->
                    <div class="dropdown ">
                        <asp:DropDownList
                            ID="ddlSort"
                            runat="server"
                            CssClass="form-select w-auto"
                            AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                            <asp:ListItem Text="Giá tăng dần" Value="asc" />
                            <asp:ListItem Text="Giá giảm dần" Value="desc" />
                        </asp:DropDownList>
                    </div>
                    <asp:DropDownList
                        ID="ddlGia"
                        runat="server"
                        CssClass="form-select w-auto"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="Filter_Changed">

                        <asp:ListItem Text="Tất cả giá" Value="0" />
                        <asp:ListItem Text="Dưới 5 triệu" Value="1" />
                        <asp:ListItem Text="5 – 10 triệu" Value="2" />
                        <asp:ListItem Text="10 – 20 triệu" Value="3" />
                        <asp:ListItem Text="Trên 20 triệu" Value="4" />
                    </asp:DropDownList>

                </div>
                <section class="py-5 bg-light">
                    <div class="container">
                        <asp:FormView
                            ID="fvChuDe"
                            runat="server"
                            DataSourceID="NXB">
                            <ItemTemplate>
                                <div class="section-header align-center">
                                    <h2 class="text-center mb-4 fw-bold"><%# Eval("TenNSX") %>
                                    </h2>
                                </div>
                            </ItemTemplate>
                        </asp:FormView>
                        <div class="row g-4">
                            <asp:Repeater ID="rptDanhMuc" runat="server">
                                <ItemTemplate>
                                    <div class="col-md-3">
                                        <div class="card product-card">
                                            <div class="position-relative">
                                                <a href="Detail.aspx?masp=<%# Eval("masp") %>&mansx=<%# Eval("mansx") %>" class="text-decoration-none text-reset d-block">
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
                                 <button class="btn btn-buy w-100">
                                     <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                 </button>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div class="text-center mt-4">
    <asp:Button
        ID="btnHienThiThem"
        runat="server"
        Text="Hiển thị thêm sản phẩm"
        CssClass="btn btn-outline-primary px-4"
        OnClick="btnHienThiThem_Click" />
</div>

                        </div>
                    </div>
                </section>
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
        SelectCommand="SELECT TOP 5 * FROM SanPham ORDER BY DonGia DESC"></asp:SqlDataSource>
</asp:Content>

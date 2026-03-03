<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/Layout.Master" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="WebDienThoai.Customer.Detail" %>

<asp:Content ID="Detail" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="container mb-5">
        <div class="container mt-4">
            <h2 class="fw-bold mb-4 text-left">CHI TIẾT SẢN PHẨM
            </h2>
        </div>
        <div class="product-list" data-aos="fade-up">
            <asp:Repeater ID="rptSP" runat="server" DataSourceID="SP">
                <ItemTemplate>
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-body">

                            <div class="row">
                                <div class="col-md-4 text-center">
                                    <div class="ratio ratio-1x1 mb-2">
                                        <asp:Repeater ID="rptHinhMain" runat="server" DataSourceID="dsHinhAnh">
                                            <ItemTemplate>
                                                <%# Container.ItemIndex == 0
                ? "<img src='../imgs/" + Eval("TenHinh") + "' class='img-fluid rounded object-fit-contain main-img' />" : "" %>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>

                                    <div id="thumbCarousel" class="carousel slide" data-bs-ride="false">
                                        <div class="carousel-inner">

                                            <div class="carousel-item active">
                                                <div class="d-flex gap-2 justify-content-center">

                                                    <asp:Repeater ID="rptHinh" runat="server" DataSourceID="dsHinhAnh">
                                                        <ItemTemplate>
                                                            <img src="../imgs/<%# Eval("TenHinh") %>"
                                                                class="img-thumbnail thumb-img"
                                                                style="width: 70px; height: 70px; object-fit: contain; cursor: pointer">
                                                        </ItemTemplate>
                                                    </asp:Repeater>

                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                    <asp:LinkButton
                                        ID="btnAddToCart"
                                        runat="server"
                                        CssClass="btn btn-danger btn-lg w-100 mt-2 btnAddToCart"
                                        CommandArgument='<%# Eval("MaSP") %>'>
                                        <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                    </asp:LinkButton>


                                </div>
                                <div class="col-md-4">
                                    <h2 class="fw-bold mb-2"><%# Eval("TenSP") %></h2>

                                    <h4 class="text-danger fw-bold mb-3">
                                        <%# Eval("GiaMin", "{0:N0}") %> ₫
                                    </h4>

                                    <p class="mb-2">
                                        <span class="badge bg-secondary">Dung lượng</span>
                                        <b class="ms-2"><%# Eval("dungluong") %></b>
                                    </p>

                                    <p class="mb-2">
                                        <span class="badge bg-info">Thị trường</span>
                                        <b class="ms-2"><%# Eval("thitruong") %></b>
                                    </p>
                                    <h6 class="fw-bold mt-3">Màu sắc</h6>
                                    <div class="d-flex gap-2">
                                        <asp:Repeater ID="rptMauSac" runat="server" DataSourceID="dsMauSac">
                                            <ItemTemplate>
                                                <div class="color-dot"
                                                    data-mamau="<%# Eval("MaMau") %>"
                                                    title="<%# Eval("TenMau") %>"
                                                    style="background-color: <%# Eval("MaMauHex") %>;">
                                                </div>
                                                <asp:HiddenField ID="hfSelectedMaMau" runat="server" Value='<%# Eval("MaMau") %>' />
                                            </ItemTemplate>
                                        </asp:Repeater>

                                    </div>

                                    <hr>
                                    <p class="text-muted">
                                        <%# Eval("mota") %>
                                    </p>
                                </div>
                                <input type="hidden" id="selectedMaMau" name="selectedMaMau">
                                <div class="col-md-4">
                                    <h5 class="fw-bold mb-3">Thông số kỹ thuật</h5>

                                    <ul class="list-group list-group-flush small">
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>CPU</span>
                                            <b><%# Eval("Cpu") %></b>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>RAM</span>
                                            <b><%# Eval("ram") %></b>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Bộ nhớ</span>
                                            <b><%# Eval("bonho") %></b>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Màn hình</span>
                                            <b><%# Eval("manhinh") %></b>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Pin</span>
                                            <b><%# Eval("pin") %></b>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between">
                                            <span>Hệ điều hành</span>
                                            <b><%# Eval("hedieuhanh") %></b>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="container mt-4">
            <h4 class="fw-bold mb-4 text-left">SẢN PHẨM CÙNG THƯƠNG HIỆU
            </h4>
            <div class="row g-2 small">
                <asp:Repeater ID="rptDanhMucGoiY" runat="server" DataSourceID="dsGoiY">
                    <ItemTemplate>
                        <div class="col-md-2 col-sm-4 col-6">
                            <div class="card product-card">
                                <div class="position-relative">
                                    <a href="Detail.aspx?masp=<%# Eval("masp") %>&mansx=<%# Eval("mansx") %>" class="text-decoration-none text-reset d-block">
                                        <%--<span class="badge-discount">-10%</span>--%>
                                        <img src="../imgs/<%# Eval("AnhSP") %>" class="card-img-top product-img" alt="<%# Eval("TenSP") %>">
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title"><%# Eval("TenSP") %></h6>
                                    <p class="text-muted small mb-2"><%# Eval("dungluong") %> - Chính hãng <%# Eval("thitruong") %></p>
                                    <div class="mb-3">
                                        <span class="price"><%# Eval("DonGia", "{0:N0}") %></span>
                                        <%--<span class="old-price ms-2">34.990.000₫</span>--%>
                                    </div>
                                    </a>
                              <asp:HyperLink
    ID="lnkDetail"
    runat="server"
    CssClass="btn btn-outline-dark btn-sm w-100 mt-2"
    NavigateUrl='<%# "Detail.aspx?masp=" + Eval("MaSP") %>'>

    <i class="fas fa-eye me-2"></i>Xem chi tiết
</asp:HyperLink>

                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
        <asp:SqlDataSource ID="SP" runat="server" ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
            SelectCommand="SELECT TOP 1
    sp.*,
    ch.*,
    gm.GiaMin
FROM SanPham sp
INNER JOIN CauHinhSP ch ON sp.MaSP = ch.MaSP
INNER JOIN (
    SELECT MaSP, MIN(DonGia) AS GiaMin
    FROM CauHinhSP
    GROUP BY MaSP
) gm ON gm.MaSP = sp.MaSP
WHERE sp.MaSP = @MaSP">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaSP" QueryStringField="masp" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsGoiY" runat="server" ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT top 6 * FROM [SanPham] WHERE ([MaNSX] = @MaNSX AND Masp != @MaSP) ORDER BY [NgayCapNhat]">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaNSX" QueryStringField="mansx" Type="Int32" />
            <asp:QueryStringParameter Name="MaSP" QueryStringField="masp" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource
        ID="dsHinhAnh"
        runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="
            SELECT TenHinh, ThuTu
    FROM HinhAnhSanPham
    WHERE MaSP = @MaSP
    AND (
            MaMau IS NULL
         OR MaMau = @MaMau
        )
    ORDER BY 
        CASE WHEN MaMau = @MaMau THEN 0 ELSE 1 END,
        ThuTu
    ">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaSP" QueryStringField="masp" Type="Int32" />
            <asp:QueryStringParameter Name="MaMau" QueryStringField="mamau" DefaultValue="2" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource
        ID="dsMauSac"
        runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="
            SELECT m.MaMau, m.TenMau, m.MaMauHex
            FROM MauSac m
            JOIN SanPham_MauSac spm ON m.MaMau = spm.MaMau
            WHERE spm.MaSP = @MaSP">
        <SelectParameters>
            <asp:QueryStringParameter Name="MaSP" QueryStringField="masp" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

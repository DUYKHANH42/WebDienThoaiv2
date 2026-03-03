<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master"
    AutoEventWireup="true" CodeBehind="Categories.aspx.cs"
    Inherits="WebDienThoai.Admin.Categories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2>Quản Lý Danh Mục</h2>

    <asp:HyperLink runat="server"
        Text="Thêm Danh Mục"
        CssClass="btn btn-success mt-2 mb-2"
        NavigateUrl="AddCategory.aspx" />

    <!-- SEARCH -->
    <div class="row mb-3">
        <div class="col-md-4">
            <asp:TextBox ID="txtTenLoai" runat="server"
                CssClass="form-control"
                placeholder="Nhập tên danh mục..." />
        </div>

        <div class="col-md-2">
            <asp:Button ID="btnSearch"
                runat="server"
                Text="Tìm kiếm"
                CssClass="btn btn-primary w-100"
              />
        </div>
    </div>

    <asp:UpdatePanel ID="upCategory" runat="server">
        <ContentTemplate>

            <!-- LISTVIEW -->
            <asp:ListView ID="lvLoai" 
                runat="server" DataSourceID="dsLoai"
               >

                <LayoutTemplate>
                    <table class="table table-bordered table-hover text-center align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Mã Loại</th>
                                <th>Tên Danh Mục</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                        </tbody>
                    </table>
                </LayoutTemplate>

                <ItemTemplate>
                    <tr>
                        <td><%# Eval("MaLoai") %></td>
                        <td class="text-start"><%# Eval("TenLoai") %></td>
                        <td>
                            <asp:Button runat="server"
                                Text="Cập nhật"
                                CssClass="btn btn-success btn-sm"
                                CommandName="editLoai"
                                CommandArgument='<%# Eval("MaLoai") %>' />

                            <asp:LinkButton runat="server"
                                CssClass="btn btn-danger btn-sm"
                                OnClientClick='<%# "return deleteLoai(" + Eval("MaLoai") + ");" %>'>
                                Xóa
                            </asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>

            </asp:ListView>

            <!-- PHÂN TRANG -->
            <%--<nav class="d-flex justify-content-center mt-3">
                <ul class="pagination">

                    <li class="page-item <%= CurrentPage == 1 ? "disabled" : "" %>">
                        <asp:LinkButton runat="server"
                            CssClass="page-link"
                            OnClick="Prev_Click">«</asp:LinkButton>
                    </li>

                    <asp:Repeater ID="rpPager"
                        runat="server"
                        OnItemCommand="rpPager_ItemCommand">
                        <ItemTemplate>
                            <li class='page-item <%# (int)Eval("Page") == CurrentPage ? "active" : "" %>'>
                                <asp:LinkButton runat="server"
                                    CssClass="page-link"
                                    CommandName="Page"
                                    CommandArgument='<%# Eval("Page") %>'>
                                    <%# Eval("Page") %>
                                </asp:LinkButton>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>

                    <li class="page-item">
                        <asp:LinkButton runat="server"
                            CssClass="page-link"
                            OnClick="Next_Click">»</asp:LinkButton>
                    </li>

                </ul>
            </nav>--%>

            <!-- MODAL EDIT -->
            <div class="modal fade" id="modalEdit" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">

                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title">Cập nhật danh mục</h5>
                            <button type="button"
                                class="btn-close btn-close-white"
                                data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">

                            <asp:HiddenField ID="hdMaLoai" runat="server" />

                            <div class="mb-3">
                                <label class="form-label">Tên danh mục</label>
                                <asp:TextBox ID="txtEditTenLoai"
                                    runat="server"
                                    CssClass="form-control" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <asp:TextBox ID="txtEditMoTa"
                                    runat="server"
                                    CssClass="form-control"
                                    TextMode="MultiLine"
                                    Rows="3" />
                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="button"
                                class="btn btn-secondary"
                                data-bs-dismiss="modal">Hủy</button>

                            <asp:Button ID="btnUpdate"
                                runat="server"
                                Text="Lưu thay đổi"
                                CssClass="btn btn-primary"
                                />
                        </div>

                    </div>
                </div>
            </div>

        </ContentTemplate>

        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
            <asp:PostBackTrigger ControlID="btnUpdate" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="dsLoai"
        runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM LoaiSP">
    </asp:SqlDataSource>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</asp:Content>
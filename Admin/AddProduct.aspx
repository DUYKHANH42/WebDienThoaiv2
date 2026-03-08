<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="WebDienThoai.Admin.AddProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
       
    </style>

    <div class="container-fluid py-4">
        <div class="row justify-content-center">
            <div class="col-xl-10">
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="page-title">Thêm Sản Phẩm Mới</h2>
                        <p class="text-muted small mb-0">Nhập đầy đủ thông tin để niêm yết sản phẩm lên cửa hàng.</p>
                    </div>
                    <a href="Product.aspx" class="btn btn-light btn-pill text-muted small"><i class="fas fa-arrow-left me-2"></i>Quay lại danh sách</a>
                </div>

                <!-- Import Section -->
                <div class="import-card d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center">
                        <div class="bg-success text-white rounded-circle p-3 me-3">
                            <i class="fas fa-file-excel fa-lg"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1 text-success">Nhập dữ liệu từ Excel</h6>
                            <p class="small text-muted mb-0">Tiết kiệm thời gian bằng cách tải lên file danh sách sản phẩm.</p>
                        </div>
                    </div>
                    <div class="d-flex gap-2 align-items-center">
                        <asp:FileUpload ID="fileExcel" runat="server" CssClass="form-control form-control-sm" />
                        <asp:Button ID="btnImport" runat="server" Text="Import" CssClass="btn btn-success btn-pill px-4 shadow-sm" />
                    </div>
                </div>

                <!-- Main Form -->
                <div class="admin-card shadow-sm">
                    <div class="section-header mt-0">Thông tin cơ bản</div>
                    <div class="row g-4">
                        <div class="col-md-8">
                            <label class="form-label">Tên Sản Phẩm <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtTenSP" runat="server" CssClass="form-control" placeholder="Ví dụ: iPhone 15 Pro Max" />
                            <asp:RequiredFieldValidator ID="rfvTen" runat="server" ControlToValidate="txtTenSP" Display="Dynamic" ErrorMessage="Tên không được trống" ForeColor="Red" CssClass="small" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Dung lượng (GB)</label>
                            <asp:TextBox ID="txtDungLuong" runat="server" CssClass="form-control" placeholder="256GB" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Tồn Kho</label>
                            <asp:TextBox ID="txtTonKho" runat="server" CssClass="form-control" placeholder="" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Phiên bản máy</label>
                            <asp:DropDownList ID="ddlMaMay" runat="server" CssClass="form-select">
                                <asp:ListItem Text="-- Chọn phiên bản --" Value=""></asp:ListItem>
                                <asp:ListItem Text="VN/A (Việt Nam)" Value="VN/A"></asp:ListItem>
                                <asp:ListItem Text="LL/A (Mỹ)" Value="LL/A"></asp:ListItem>
                                <asp:ListItem Text="Quốc tế" Value="GLOBAL"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Loại sản phẩm</label>
                            <asp:DropDownList ID="ddlLoai" runat="server" CssClass="form-select" DataSourceID="dsLoai" DataTextField="TenLoai" DataValueField="MaLoai"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Nhà sản xuất</label>
                            <asp:DropDownList ID="ddlNSX" runat="server" CssClass="form-select" DataSourceID="dsNSX" DataTextField="TenNSX" DataValueField="MaNSX"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Ngày mở bán</label>
                            <asp:TextBox ID="txtNgayPhatHanh" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                    </div>

                    <div class="section-header">Phiên bản & Giá</div>
                    <div class="table-responsive">
                        <table class="table table-custom mb-3" id="tblGia">
                            <thead>
                                <tr>
                                    <th>RAM</th>
                                    <th>ROM</th>
                                    <th>Giá Niêm Yết (₫)</th>
                                    <th width="50"></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <button type="button" class="btn btn-add-variant btn-pill w-100 py-2" onclick="addGiaRow()">
                        <i class="fas fa-plus-circle me-2"></i>Thêm biến thể dung lượng & giá
                    </button>

                    <div class="section-header">Màu sắc</div>
                    <div class="d-flex gap-2 mb-3 align-items-center">
                        <asp:DropDownList ID="ddlColor" runat="server" DataSourceID="dsMau" DataTextField="TenMau" DataValueField="MaMau" CssClass="form-select" Style="max-width: 250px;"></asp:DropDownList>
                        <button type="button" class="btn btn-dark btn-pill px-4" onclick="addColor()">Thêm màu</button>
                    </div>
                    <div id="colorBox" class="d-flex flex-wrap gap-2"></div>

                    <div class="section-header">Thông số cấu hình</div>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <asp:TextBox ID="txtCPU" runat="server" CssClass="form-control" placeholder="CPU" /></div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtGPU" runat="server" CssClass="form-control" placeholder="GPU" /></div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtRamChuan" runat="server" CssClass="form-control" placeholder="RAM chuẩn" /></div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtManHinh" runat="server" CssClass="form-control" placeholder="Màn hình" /></div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtPin" runat="server" CssClass="form-control" placeholder="Pin" /></div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHDH" runat="server" CssClass="form-control" placeholder="Hệ điều hành" /></div>
                    </div>

                    <div class="section-header">Hình ảnh & Album</div>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Ảnh đại diện (Nhiều ảnh để tạo slider)</label>
                            <asp:FileUpload ID="multiImg" runat="server" AllowMultiple="true" CssClass="form-control" />
                            <div id="previewImg" class="d-flex flex-wrap gap-2 mt-3"></div>
                        </div>
                        <div class="col-md-6 border-start">
                            <label class="form-label">Album ảnh chi tiết (Nội dung bài viết)</label>
                            <asp:FileUpload ID="fuAlbum" runat="server" AllowMultiple="true" CssClass="form-control" accept="image/*" />
                            <div id="albumPreview" class="d-flex flex-wrap gap-2 mt-3"></div>
                        </div>
                    </div>

                    <div class="mt-5 pt-4 border-top text-center">
                        <asp:ValidationSummary ID="vsLoi" runat="server" CssClass="alert alert-danger rounded-4 py-2 small mb-4 text-start d-inline-block px-5" DisplayMode="List" />
                        <div class="d-flex justify-content-center gap-3">
                            <asp:Button ID="btnThemMoi" runat="server" CssClass="btn btn-primary btn-pill px-5 py-3 shadow-lg fs-5" Text="Lưu & Công bố sản phẩm" OnClick="btnThemMoi_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:SqlDataSource ID="dsLoai" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM LoaiSP" />
    <asp:SqlDataSource ID="dsMau" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM [MauSac]" />
    <asp:SqlDataSource ID="dsNSX" runat="server"
        ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
        SelectCommand="SELECT * FROM NhaSanXuat" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js"></script>
    <script>
        var ddlColorID = '<%= ddlColor.ClientID %>';
    </script>

</asp:Content>

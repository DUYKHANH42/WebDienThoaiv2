<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="WebDienThoai.Admin.AddProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Thêm Sản Phẩm Mới</h2>
    <hr />
    <h5 class="mt-3">Import sản phẩm từ Excel</h5>

    <asp:FileUpload ID="fileExcel" runat="server" CssClass="form-control" />
    <asp:Button ID="btnImport" runat="server" Text="Import Excel"
        CssClass="btn btn-success mt-2 mb-2" />

    <div class="row justify-content-center">
        <div class="col">
            <div class="card shadow rounded-4">
                <div class="card-body p-4">
                    <div class="mb-3">
                        <asp:Label ID="Label3"
                            runat="server"
                            CssClass="form-label"
                            Text="Tên Sản Phẩm" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                            runat="server" ControlToValidate="txtTenSP"
                            Display="Dynamic" ErrorMessage="Vui lòng không để trống tên sản phẩm" ForeColor="Red">*</asp:RequiredFieldValidator>
                        <asp:TextBox ID="txtTenSP"
                            runat="server"
                            CssClass="form-control"
                            Placeholder="abc" />
                    </div>
                    <div class="md-3">
        <asp:Label ID="LabelDungLuong"
            runat="server"
            CssClass="form-label"
            Text="Dung lượng (GB)" />

        <asp:RequiredFieldValidator ID="rfDungLuong"
            runat="server"
            ControlToValidate="txtDungLuong"
            Display="Dynamic"
            ErrorMessage="Không được để trống dung lượng"
            ForeColor="Red">*</asp:RequiredFieldValidator>

        <asp:TextBox ID="txtDungLuong"
            runat="server"
            CssClass="form-control"
            Placeholder="256GB" />
    </div>
                    <div class="mb-3">
                        <asp:Label ID="LabelMaMay"
    runat="server"
    CssClass="form-label"
    Text="Phiên bản máy" />

<asp:RequiredFieldValidator ID="rfMaMay"
    runat="server"
    ControlToValidate="ddlMaMay"
    InitialValue=""
    Display="Dynamic"
    ErrorMessage="Chọn phiên bản máy"
    ForeColor="Red">*</asp:RequiredFieldValidator>

<asp:DropDownList ID="ddlMaMay"
    runat="server"
    CssClass="form-select">

    <asp:ListItem Text="-- Chọn phiên bản --" Value=""></asp:ListItem>

    <asp:ListItem Text="VN/A (Phân phối Apple VN)" Value="VN/A"></asp:ListItem>
    <asp:ListItem Text="LL/A (Mỹ)" Value="LL/A"></asp:ListItem>
    <asp:ListItem Text="ZP/A (HongKong)" Value="ZP/A"></asp:ListItem>
    <asp:ListItem Text="CH/A (Trung Quốc)" Value="CH/A"></asp:ListItem>
    <asp:ListItem Text="J/A (Nhật)" Value="J/A"></asp:ListItem>
    <asp:ListItem Text="KH/A (Hàn Quốc)" Value="KH/A"></asp:ListItem>
    <asp:ListItem Text="ZA/A (Singapore)" Value="ZA/A"></asp:ListItem>
    <asp:ListItem Text="Bản quốc tế" Value="GLOBAL"></asp:ListItem>
    <asp:ListItem Text="Bản nội địa Trung" Value="CN"></asp:ListItem>
    <asp:ListItem Text="Bản Hàn" Value="KR"></asp:ListItem>

</asp:DropDownList>

                        </div>
                    <div class="mb-3">
                        <asp:Label ID="Label1"
                            runat="server"
                            CssClass="form-label"
                            Text="Danh Mục Lọai" />
                        <asp:DropDownList ID="ddlLoai" runat="server"
                            CssClass="form-select"
                            DataSourceID="dsLoai"
                            DataTextField="TenLoai"
                            DataValueField="MaLoai"
                            AppendDataBoundItems="true">
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="Label2"
                            runat="server"
                            CssClass="form-label"
                            Text="Nhà Sản Xuất" />
                        <asp:DropDownList ID="ddlNSX" runat="server"
                            CssClass="form-select"
                            DataSourceID="dsNSX"
                            DataTextField="TenNSX"
                            DataValueField="MaNSX"
                            AppendDataBoundItems="true">
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="Label5"
                            runat="server"
                            CssClass="form-label"
                            Text="Ngày Mở Bán" />
                        <asp:RequiredFieldValidator ID="refNgayPH"
                            runat="server" ControlToValidate="txtNgayPhatHanh"
                            Display="Dynamic" ErrorMessage="Vui lòng không nhập phát hành" ForeColor="Red">*</asp:RequiredFieldValidator>
                        <asp:TextBox ID="txtNgayPhatHanh"
                            runat="server"
                            CssClass="form-control"
                            TextMode="Date"
                            Placeholder="" />
                    </div>
                    <hr />
                    <h5 class="mt-3">Phiên bản & Giá</h5>

                    <table class="table table-bordered" id="tblGia">
                        <thead class="table-light">
                            <tr>
                                <th>RAM</th>
                                <th>ROM</th>
                                <th>Giá</th>
                                <th width="60"></th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <button type="button" class="btn btn-sm btn-primary" onclick="addGiaRow()">+ Thêm phiên bản</button>


                    <hr />
                    <h5 class="mt-3">Màu sắc</h5>
                    <asp:DropDownList
                        ID="ddlColor"
                        runat="server" DataSourceID="dsMau" DataTextField="TenMau" DataValueField="MaMau"
                        CssClass="form-control d-flex flex-wrap gap-2">
</asp:DropDownList>
                   <button type="button" class="btn btn-dark mt-2" onclick="addColor()">Thêm màu</button>

<div id="colorBox" class="mt-2"></div>
                    <hr />
                    <h5 class="mt-3">Cấu hình</h5>

                   <div class="row g-2">

    <div class="col-md-4">
        <asp:TextBox ID="txtCPU" runat="server"
            CssClass="form-control"
            placeholder="CPU (Snapdragon 8 Gen 3)" />
    </div>

    <div class="col-md-4">
        <asp:TextBox ID="txtGPU" runat="server"
            CssClass="form-control"
            placeholder="GPU" />
    </div>

    <div class="col-md-4">
        <asp:TextBox ID="txtRamChuan" runat="server"
            CssClass="form-control"
            placeholder="RAM chuẩn" />
    </div>

    <div class="col-md-4">
        <asp:TextBox ID="txtManHinh" runat="server"
            CssClass="form-control"
            placeholder="Màn hình" />
    </div>

    <div class="col-md-4">
        <asp:TextBox ID="txtPin" runat="server"
            CssClass="form-control"
            placeholder="Pin" />
    </div>

    <div class="col-md-4">
        <asp:TextBox ID="txtHDH" runat="server"
            CssClass="form-control"
            placeholder="Hệ điều hành" />
    </div>

</div>



                    <div class="mb-3">
                        <asp:Label runat="server" CssClass="form-label" Text="Ảnh sản phẩm" />
                        <asp:FileUpload ID="multiImg" runat="server" AllowMultiple="true"
    CssClass="form-control" />

                    </div>

                    <div id="previewImg" class="d-flex flex-wrap gap-2 mt-2"></div>

                    <div class="d-grid mb-3 ">
                        <asp:ValidationSummary ID="vsLoi" runat="server" DisplayMode="List" ForeColor="Red" />
                    </div>
                    <hr class="my-4"/>

<h5 class="fw-bold text-primary">Album ảnh chi tiết</h5>

<div class="mb-3">
    <label class="form-label">Thêm nhiều ảnh</label>
     <asp:FileUpload ID="fuAlbum"
        runat="server"
        AllowMultiple="true"
        CssClass="form-control"
        accept="image/*" />

</div>

<div id="albumPreview" class="d-flex flex-wrap gap-3"></div>

                </div>

                <div class="text-center mb-3">
                    <asp:Button ID="btnThemMoi"
                        runat="server"
                        CssClass="btn btn-info btn-lg px-4 shadow-sm"
                        Text="Thêm Mới" OnClick="btnThemMoi_Click" />
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

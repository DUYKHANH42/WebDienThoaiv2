<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="WebDienThoai.Admin.AddProduct" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Thêm Sản Phẩm Mới</h2>
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
                  <div class="mb-3">
                        <asp:Label ID="Label4"
                            runat="server"
                            CssClass="form-label"
                            Text="Hình Sản Phẩm: " />
                      <asp:FileUpload ID="HinhUpload" runat="server" />
                    </div>
                  <div class="d-grid mb-3 ">
                      <asp:ValidationSummary ID="vsLoi" runat="server" DisplayMode="List" ForeColor="Red" />
                  </div>
              </div>
                  <div class="text-center mb-3">
                      <asp:Button ID="btnThemMoi"
                          runat="server"
                          CssClass="btn btn-info btn-lg px-4 shadow-sm"
                          Text="Thêm Mới" />
                  </div>
          </div>

      </div>
  </div>
     <asp:SqlDataSource ID="dsLoai" runat="server"
     ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
     SelectCommand="SELECT * FROM LoaiSP" />
     <asp:SqlDataSource ID="dsNSX" runat="server"
     ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>"
     SelectCommand="SELECT * FROM NhaSanXuat" />
</asp:Content>

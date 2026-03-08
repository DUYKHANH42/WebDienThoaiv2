<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master"
    AutoEventWireup="true" CodeBehind="Categories.aspx.cs"
    Inherits="WebDienThoai.Admin.Categories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-title {
            font-weight: 800;
            color: #1e293b;
            margin: 0;
        }
        /* Filter Card */

        .filter-card {
            background: #fff;
            border-radius: 20px;
            padding: 25px;
            border: none;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
            margin-bottom: 30px;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px 18px;
            border: 1px solid #e2e8f0;
            background: #fbfbfb;
            transition: 0.3s;
        }

            .form-control:focus {
                background: #fff;
                border-color: #3b82f6;
                box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
            }
        /* Table Styles */

        .table-container {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }

        .table-modern {
            margin-bottom: 0;
        }

            .table-modern thead th {
                background: #f8fafc;
                color: #64748b;
                font-size: 0.75rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1px;
                padding: 18px 25px;
                border: none;
            }

            .table-modern tbody td {
                padding: 15px 25px;
                vertical-align: middle;
                border-bottom: 1px solid #f1f5f9;
                color: #475569;
                font-size: 0.95rem;
            }
        /* Buttons & Badges */

        .btn-pill {
            border-radius: 50px;
            padding: 8px 25px;
            font-weight: 700;
            transition: 0.3s;
        }

        .btn-add {
            background: #3b82f6;
            color: #fff;
            box-shadow: 0 10px 15px rgba(59, 130, 246, 0.2);
        }

            .btn-add:hover {
                transform: translateY(-2px);
                box-shadow: 0 15px 20px rgba(59, 130, 246, 0.3);
                color: #fff;
            }

        .cat-id-badge {
            background: #eff6ff;
            color: #3b82f6;
            padding: 5px 12px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.8rem;
        }
        /* Modal Modern */

        .modal-content-modern {
            border-radius: 25px;
            border: none;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.15);
        }

        .modal-header-modern {
            border-bottom: 1px solid #f1f5f9;
            padding: 25px 30px;
        }

        .modal-title-modern {
            font-weight: 800;
            color: #1e293b;
        }
    </style>
    <div class="page-header">
        <h3 class="page-title">Quản Lý Danh Mục</h3>
        <asp:HyperLink runat="server" ID="hplAdd" CssClass="btn btn-pill btn-add shadow-sm" NavigateUrl="AddCategory.aspx"><i class="fas fa-plus me-2"></i>Thêm Danh Mục Mới </asp:HyperLink>
    </div>
    <!-- Filter Section -->
    <div class="filter-card shadow-sm">
        <div class="row align-items-center">
            <div class="col-md-5">
                <div class="input-group"><span class="input-group-text bg-transparent border-end-0 pe-0 text-muted" style="border-radius: 12px 0 0 12px;"><i class="fas fa-search"></i></span>
                    <asp:TextBox ID="txtTenLoai" runat="server" CssClass="form-control border-start-0" placeholder="Tìm kiếm tên danh mục..." style="border-radius: 0 12px 12px 0;" />
                </div>
            </div>
            <div class="col-md-2">
                <asp:Button ID="btnSearch" runat="server" Text="Tìm kiếm" CssClass="btn btn-dark btn-pill w-100" />
            </div>
        </div>
    </div>
    <asp:UpdatePanel ID="upCategory" runat="server">
        <contenttemplate>
            <!-- Data Table -->
            <div class="table-container shadow-sm">
                <asp:ListView ID="lvLoai" OnItemCommand="lvLoai_ItemCommand" runat="server" DataSourceID="dsLoai">
                    <layouttemplate>
                        <table class="table table-modern text-center align-middle">
                            <thead>
                                <tr>
                                    <th style="width: 150px;">Mã Loại</th>
                                    <th class="text-start">Tên Danh Mục Sản Phẩm</th>
                                    <th style="width: 250px;">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                            </tbody>
                        </table>
                    </layouttemplate>
                    <itemtemplate>
                        <tr>
                            <td><span class="cat-id-badge">#<%# Eval("MaLoai") %></span></td>
                            <td class="text-start fw-bold text-dark"><%# Eval("TenLoai") %></td>
                            <td>
                                <div class="d-flex justify-content-center gap-2">
                                    <asp:LinkButton runat="server"  CssClass="btn btn-outline-success btn-pill btn-sm" CommandName="editLoai" CommandArgument='<%# Eval("MaLoai") %>'><i class="fas fa-edit me-1"></i>Sửa </asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </itemtemplate>
                </asp:ListView>
            </div>
               <div class="modal fade" id="modalEditDM" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 25px;">
            <div class="modal-header border-0 px-4 pt-4 pb-0">
                <h5 class="modal-title fw-bold text-dark fs-5" id="modalLabel">
                    <i class="fas fa-edit text-primary me-2"></i>Cập Nhật Danh Mục
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <div class="modal-body p-4">
                <asp:HiddenField ID="hfMaLoai" runat="server" />
                <div class="mb-4">
                    <label class="form-label small fw-bold text-muted text-uppercase mb-2" style="letter-spacing: 0.5px;">
                        Tên danh mục sản phẩm
                    </label>
                    <asp:TextBox ID="txtTenDanhMuc" runat="server" 
                        CssClass="form-control border-light shadow-none py-3 px-3" 
                        style="background: #f8fafc; border-radius: 12px;"
                        placeholder="" />
                </div>
            </div>
            
            <div class="modal-footer border-0 px-4 pb-4 pt-0 d-flex gap-2">
                <button type="button" class="btn btn-light rounded-pill px-4 fw-bold text-muted border-0" data-bs-dismiss="modal" style="background: #f1f5f9;">
                    Hủy bỏ
                </button>
                <asp:Button ID="btnUpdate" OnClick="btnUpdate_Click" runat="server" 
                    Text="Lưu thay đổi" 
                    CssClass="btn btn-primary rounded-pill px-4 fw-bold shadow-sm"
                    style="background: #3b82f6; border: none;" />
            </div>
        </div>
    </div>
</div>
        </contenttemplate>
        <triggers>
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
            <asp:PostBackTrigger ControlID="btnUpdate" />
        </triggers>
    </asp:UpdatePanel>
  
    <!-- Keep DataSources & Scripts -->
    <asp:SqlDataSource ID="dsLoai" runat="server" ConnectionString="<%$ ConnectionStrings:DienThoaiDBConnectionString %>" SelectCommand="SELECT * FROM LoaiSP"></asp:SqlDataSource>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>

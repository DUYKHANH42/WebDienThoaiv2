<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="customer.aspx.cs" Inherits="WebDienThoai.Admin.customer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <script id="tailwind-config">
        
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }
        /* Tối ưu hóa cho bảng dữ liệu */
        .custom-scrollbar::-webkit-scrollbar {
            width: 4px;
            height: 4px;
        }

        .custom-scrollbar::-webkit-scrollbar-track {
            background: transparent;
        }

        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #e2e8f0;
            border-radius: 10px;
        }
    </style>

    <div class="space-y-6 p-4 sm:p-6 lg:p-8 bg-slate-50/50 min-h-screen">
        <!-- Header -->
        <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
            <div>
                <nav class="flex mb-2" aria-label="Breadcrumb">
                    <ol class="inline-flex items-center space-x-1 md:space-x-3 text-xs text-slate-500">
                        <li>Admin</li>
                        <li class="flex items-center">
                            <span class="material-symbols-outlined text-sm mx-1">chevron_right</span>
                            <span class="font-semibold text-primary">Khách hàng</span>
                        </li>
                    </ol>
                </nav>
                <h1 class="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">Quản Lý Khách Hàng</h1>
                <p class="text-slate-500 mt-1 text-sm sm:text-base">Hệ thống quản lý 1,284 khách hàng đang sử dụng dịch vụ.</p>
            </div>
            <button class="bg-primary hover:bg-primary/90 text-white px-5 py-2.5 rounded-xl font-bold flex items-center justify-center gap-2 transition-all shadow-lg shadow-primary/20 active:scale-95">
                <span class="material-symbols-outlined text-xl">person_add</span>
                Thêm khách hàng mới
            </button>
        </div>
        <asp:UpdatePanel ID="updKhachHang" runat="server">
            <ContentTemplate>
                <!-- Filters Section -->
                <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-100">
                    <div class="flex flex-wrap items-end gap-4">

                        <div class="flex-1 min-w-[240px]">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-widest mb-1.5 ml-1">
                                Tìm kiếm khách hàng
                            </label>

                            <div class="relative group">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">search</span>

                                <asp:TextBox
                                    ID="txtSearch"
                                    runat="server"
                                    CssClass="w-full pl-10 pr-4 py-2.5 rounded-xl border-slate-200 bg-slate-50 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-sm outline-none"
                                    placeholder="Họ tên, email, số điện thoại..." />

                            </div>
                        </div>


                        <div class="w-full sm:w-auto min-w-[180px]">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-widest mb-1.5 ml-1">
                                Trạng thái
                            </label>

                            <asp:DropDownList
                                ID="ddlTrangThai"
                                runat="server"
                                CssClass="w-full px-4 py-2.5 rounded-xl border-slate-200 bg-slate-50 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-sm outline-none cursor-pointer">
                                <asp:ListItem Value="">Tất cả trạng thái</asp:ListItem>
                                <asp:ListItem Value="1">Đang hoạt động</asp:ListItem>
                                <asp:ListItem Value="0">Đã khóa</asp:ListItem>

                            </asp:DropDownList>

                        </div>


                        <div class="w-full sm:w-auto min-w-[180px]">
                            <label class="block text-[11px] font-bold text-slate-500 uppercase tracking-widest mb-1.5 ml-1">
                                Ngày gia nhập
                            </label>

                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">calendar_month</span>

                                <asp:TextBox
                                    ID="txtNgay"
                                    runat="server"
                                    TextMode="Date"
                                    CssClass="w-full pl-10 pr-4 py-2.5 rounded-xl border-slate-200 bg-slate-50 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-sm outline-none" />

                            </div>
                        </div>


                        <div class="flex gap-2 w-full lg:w-auto">

                            <asp:Button
                                ID="btnFilter"
                                runat="server"
                                Text="Lọc kết quả"
                                OnClick="btnFilter_Click"
                                CssClass="flex-1 lg:px-6 py-2.5 bg-primary text-white font-bold rounded-xl transition-all shadow-md shadow-primary/20 active:scale-95" />

                            <asp:Button
                                ID="btnReset"
                                runat="server"
                                Text="↺"
                                OnClick="btnReset_Click"
                                CssClass="p-2.5 bg-slate-100 text-slate-600 rounded-xl hover:bg-slate-200 transition-all active:scale-95" />

                        </div>

                    </div>
                </div>

                <!-- Data Table Section -->
                <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
                    <div class="overflow-x-auto custom-scrollbar">
                        <asp:Repeater ID="rpKhachHang" runat="server" OnItemCommand="rpKhachHang_ItemCommand">
                            <HeaderTemplate>

                                <table class="w-full text-left border-separate border-spacing-0">
                                    <thead>
                                        <tr class="bg-slate-50/50">
                                            <th class="px-6 py-4 text-xs">Mã KH</th>
                                            <th class="px-6 py-4 text-xs">Thông tin khách hàng</th>
                                            <th class="px-6 py-4 text-xs">Liên hệ</th>
                                            <th class="px-6 py-4 text-xs text-center">Đơn</th>
                                            <th class="px-6 py-4 text-xs text-right">Tổng chi</th>
                                            <th class="px-6 py-4 text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Ngày tham gia</th>
                                            <th class="px-6 py-4 text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Trạng thái</th>
                                            <th class="px-6 py-4 text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider text-right">Thao tác</th>
                                        </tr>
                                    </thead>

                                    <tbody class="divide-y divide-slate-100">
                            </HeaderTemplate>

                            <ItemTemplate>

                                <tr class="hover:bg-slate-50 group">

                                    <td class="px-6 py-4 text-xs whitespace-nowrap">
                                        <%# Eval("MaKH") %>
                                    </td>

                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <%# Eval("TenKH") %>
                                    </td>

                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <%# Eval("DienThoai") %>
                                    </td>

                                    <td class="px-6 py-4 text-center whitespace-nowrap">
                                        <%# Eval("SoDonHang") %>
                                    </td>

                                    <td class="px-6 py-4 text-right whitespace-nowrap">
                                        <%# Eval("TongChiTieu","{0:N0}") %> đ
                                    </td>

                                    <td class="px-6 py-5 text-sm text-slate-500 whitespace-nowrap">
                                        <%# Eval("NgayTao","{0:dd/MM/yyyy}") %>
                                    </td>

                                    <td class="px-6 py-5 whitespace-nowrap">

                                        <div class="toggle-switch-container flex justify-center">
                                            <asp:CheckBox ID="chkTrangThai" runat="server"
                                                Checked='<%# (bool)Eval("TrangThai") %>'
                                                AutoPostBack="true"
                                                OnCheckedChanged="chkTrangThai_CheckedChanged" />
                                            <asp:HiddenField ID="hdMaKH" runat="server" Value='<%# Eval("MaKH") %>' />
                                        </div>

                                    </td>
                                    <td class="px-6 py-5 text-right whitespace-nowrap">

                                        <div class="flex items-center justify-end gap-2">

                                            <asp:LinkButton
                                                ID="btnView"
                                                runat="server"
                                                CssClass="p-2 hover:bg-white dark:hover:bg-slate-700 rounded-lg text-slate-600 dark:text-slate-300 border border-transparent hover:border-slate-200 dark:hover:border-slate-600 shadow-sm transition"
                                                CommandName="viewKH"
                                                CommandArgument='<%# Eval("MaKH") %>'
                                                ToolTip="Xem chi tiết">

        <span class="material-symbols-outlined text-[20px]">visibility</span>

    </asp:LinkButton>

                                        </div>

                                    </td>


                                </tr>

                            </ItemTemplate>

                            <FooterTemplate>
                                </tbody>
                                      </table>
       
                            </FooterTemplate>

                        </asp:Repeater>
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
                            khách hàng
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
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</asp:Content>

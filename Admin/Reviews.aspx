<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Layout.Master" AutoEventWireup="true" CodeBehind="Reviews.aspx.cs" Inherits="WebDienThoai.Admin.Reviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style data-purpose="custom-layout">
        /* Mimicking ASP.NET Master Page Layout */
        body {
            background-color: #f8fafc;
            font-family: 'Public Sans', sans-serif;
        }

        .master-wrapper {
            display: flex;
            min-height: 100vh;
        }

        .side-nav {
            width: 260px;
            background-color: #ffffff;
            border-right: 1px solid #e2e8f0;
        }

        .content-wrapper {
            flex: 1;
            max-width: 1280px;
            margin: 0 auto;
            padding: 2rem;
        }

        .star-filled {
            color: #fbbf24;
            font-variation-settings: 'FILL' 1;
        }
    </style>
    <main class="flex-1 overflow-y-auto">
        <!-- BEGIN: ContentPlaceHolder_Main -->
        <div class="content-wrapper">
            <!-- Header Info -->
            <div class="mb-8">
                <h1 class="text-2xl font-bold text-gray-900">Đánh Giá Sản Phẩm</h1>
            </div>
            <asp:UpdatePanel ID="updKhachHang" runat="server">
                <ContentTemplate>
                    <div class="bg-white p-4 rounded-xl border border-gray-100 shadow-sm mb-6 flex flex-wrap items-center gap-4" data-purpose="filters">
                        <div class="flex-1 min-w-[240px] relative">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xl">search</span>
                            <asp:TextBox
                                ID="txtSearch"
                                runat="server"
                                CssClass="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-lg text-sm"
                                placeholder="Tìm đánh giá, sản phẩm hoặc người dùng..." />
                        </div>
                        <asp:DropDownList ID="ddlSao" runat="server"
                            CssClass="border border-gray-200 rounded-lg py-2 pl-3 pr-10 text-sm bg-white">

                            <asp:ListItem Value="">Tất cả sao</asp:ListItem>
                            <asp:ListItem Value="5">5 Sao</asp:ListItem>
                            <asp:ListItem Value="4">4 Sao</asp:ListItem>
                            <asp:ListItem Value="3">3 Sao</asp:ListItem>
                            <asp:ListItem Value="2">2 Sao</asp:ListItem>
                            <asp:ListItem Value="1">1 Sao</asp:ListItem>

                        </asp:DropDownList>
                        <asp:LinkButton
                            ID="btnFilter"
                            runat="server"
                            OnClick="btnFilter_Click"
                            CssClass="bg-primary text-white px-6 py-2 rounded-lg font-semibold text-sm hover:bg-orange-600 transition-colors flex items-center gap-2">

    <span class="material-symbols-outlined text-lg">filter_list</span>
    Apply Filters

</asp:LinkButton>
                    </div>
                    <!-- END: FilterBar -->
                    <!-- BEGIN: ReviewCardsGrid -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6" data-purpose="reviews-container">
                        <!-- Card 1: Pending -->
                        <asp:Repeater ID="rptReview" runat="server">
                            <ItemTemplate>

                                <div class="bg-white rounded-xl border border-gray-100 border-l-4 border-l-amber-400 shadow-sm p-6 flex flex-col gap-4">

                                    <div class="flex justify-between items-start">

                                        <div class="flex items-center gap-3">

                                            <div class="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center text-gray-600 font-bold">
                                                <img src='/imgs/<%# Eval("AvtUrl") %>' class="w-10 h-10 rounded-full object-cover" />
                                            </div>

                                            <div>
                                                <h4 class="font-semibold text-gray-900">
                                                    <%# Eval("TenKH") %>
                                                </h4>

                                                <p class="text-xs text-gray-500">
                                                    <%# Eval("NgayDG","{0:dd/MM/yyyy HH:mm}") %> • Mã Sản Phẩm: <%# Eval("MaSP") %>
                                                </p>
                                            </div>

                                        </div>

                                    </div>

                                    <div class="flex gap-0.5 text-amber-400">
                                        <%# RenderStar(Eval("SoSao")) %>
                                    </div>

                                    <p class="text-sm text-gray-600 leading-relaxed italic">
                                        "<%# Eval("NoiDung") %>"
                                    </p>

                                </div>

                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <!-- END: ReviewCardsGrid -->
                    <!-- BEGIN: Pagination -->
                    <div class="mt-8 flex items-center justify-between border-t border-gray-200 pt-6">

                        <p class="text-sm text-gray-600">
                            Showing 
                            <span class="font-semibold">
                                <asp:Literal ID="ltrStart" runat="server"></asp:Literal></span>
                            to 
                            <span class="font-semibold">
                                <asp:Literal ID="ltrEnd" runat="server"></asp:Literal></span>
                            of 
                            <span class="font-semibold">
                                <asp:Literal ID="ltrTotal" runat="server"></asp:Literal></span> reviews
                        </p>

                        <div class="flex gap-2">

                            <asp:LinkButton ID="btnPrev" runat="server"
                                OnClick="btnPrev_Click"
                                CssClass="px-3 py-1 border border-gray-200 rounded-md text-gray-400 bg-white hover:bg-gray-50">

<span class="material-symbols-outlined text-base align-middle">chevron_left</span>

                            </asp:LinkButton>


                            <asp:Repeater ID="rptPaging" runat="server" OnItemCommand="rptPaging_ItemCommand">

                                <ItemTemplate>

                                    <asp:LinkButton runat="server"
                                        CommandName="page"
                                        CommandArgument='<%# Eval("PageNumber") %>'
                                        CssClass='<%# Convert.ToBoolean(Eval("IsCurrent")) 
? "px-3 py-1 bg-primary text-white rounded-md text-sm font-semibold"
: "px-3 py-1 border border-gray-200 rounded-md text-gray-600 bg-white hover:bg-gray-50 text-sm font-semibold" %>'>

<%# Eval("PageNumber") %>

                                    </asp:LinkButton>

                                </ItemTemplate>

                            </asp:Repeater>


                            <asp:LinkButton ID="btnNext" runat="server"
                                OnClick="btnNext_Click"
                                CssClass="px-3 py-1 border border-gray-200 rounded-md text-gray-600 bg-white hover:bg-gray-50">

<span class="material-symbols-outlined text-base align-middle">chevron_right</span>

                            </asp:LinkButton>

                        </div>

                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <!-- END: ContentPlaceHolder_Main -->
    </main>
</asp:Content>

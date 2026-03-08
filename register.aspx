<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="WebDienThoai.register" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">

    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Đăng ký | 113 Mobile</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <style>
        body {
            font-family: 'Plus Jakarta Sans',sans-serif;
            background: #ffffff;
        }

        .input-style {
            height: 60px;
            padding: 0 24px;
            border-radius: 18px;
            background: #f8fafc;
            border: none;
            width: 100%;
        }

            .input-style:focus {
                outline: none;
                border: 1px solid #0f172a;
                box-shadow: 0 0 0 1px #0f172a;
            }
    </style>

</head>

<body class="min-h-screen flex items-center justify-center p-6">

    <form id="form1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <main class="w-full max-w-2xl">

            <!-- Logo -->

            <div class="text-center mb-8">

                <h1 class="text-3xl font-bold mb-2">113 MOBILE</h1>

                <p class="text-slate-500 font-medium">
                    Trải nghiệm công nghệ đẳng cấp
                </p>

            </div>

            <!-- Card -->

            <div class="bg-white rounded-[32px] shadow-[0_20px_50px_rgba(0,0,0,0.05)] border border-slate-100 p-10">

                <div class="mb-10">

                    <h2 class="text-2xl font-bold">Tạo tài khoản mới
                    </h2>

                    <p class="text-slate-400 mt-1">
                        Vui lòng điền đầy đủ thông tin bên dưới
                    </p>

                </div>

                <div class="space-y-6">

                    <!-- Họ tên + Username -->

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                        <div>

                            <label class="text-sm font-semibold ml-1">
                                Họ và Tên
                            </label>

                            <asp:RequiredFieldValidator
                                ID="RequiredFieldValidator1"
                                runat="server"
                                ControlToValidate="txtHoten"
                                Display="Dynamic"
                                ErrorMessage="Vui lòng nhập họ tên"
                                ForeColor="Red">*</asp:RequiredFieldValidator>

                            <asp:TextBox
                                ID="txtHoten"
                                runat="server"
                                CssClass="input-style"
                                Placeholder="Nguyễn Văn A" />

                        </div>

                        <div>

                            <label class="text-sm font-semibold ml-1">
                                Tên đăng nhập
                            </label>

                            <asp:RequiredFieldValidator
                                ID="refTenDN"
                                runat="server"
                                ControlToValidate="txtTenDN"
                                Display="Dynamic"
                                ErrorMessage="Vui lòng nhập tên đăng nhập"
                                ForeColor="Red">*</asp:RequiredFieldValidator>

                            <asp:TextBox
                                ID="txtTenDN"
                                runat="server"
                                CssClass="input-style"
                                Placeholder="username123" />

                        </div>

                    </div>

                    <!-- Password -->

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                        <div>

                            <label class="text-sm font-semibold ml-1">
                                Mật khẩu
                            </label>

                            <asp:RequiredFieldValidator
                                ID="refPassword"
                                runat="server"
                                ControlToValidate="txtPassword"
                                Display="Dynamic"
                                ErrorMessage="Vui lòng nhập mật khẩu"
                                ForeColor="Red">*</asp:RequiredFieldValidator>

                            <asp:TextBox
                                ID="txtPassword"
                                runat="server"
                                CssClass="input-style"
                                TextMode="Password" />

                        </div>

                        <div>

                            <label class="text-sm font-semibold ml-1">
                                Xác nhận mật khẩu
                            </label>

                            <asp:RequiredFieldValidator
                                ID="reftxtnhaplaiPass"
                                runat="server"
                                ControlToValidate="txtNhapLaiPass"
                                Display="Dynamic"
                                ErrorMessage="Vui lòng nhập lại mật khẩu"
                                ForeColor="Red">*</asp:RequiredFieldValidator>

                            <asp:CompareValidator
                                ID="cvMatKhau"
                                runat="server"
                                ErrorMessage="Mật khẩu không khớp"
                                ControlToCompare="txtNhapLaiPass"
                                ControlToValidate="txtPassword"
                                Display="Dynamic"
                                ForeColor="Red">*</asp:CompareValidator>

                            <asp:TextBox
                                ID="txtNhapLaiPass"
                                runat="server"
                                CssClass="input-style"
                                TextMode="Password" />

                        </div>

                    </div>

                    <!-- Email + Phone -->

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                        <div>

                            <label class="text-sm font-semibold ml-1">
                                Email
                            </label>

                            <asp:RequiredFieldValidator
                                ID="refEmail"
                                runat="server"
                                ControlToValidate="txtEmail"
                                Display="Dynamic"
                                ErrorMessage="Vui lòng nhập email"
                                ForeColor="Red">*</asp:RequiredFieldValidator>

                            <asp:TextBox
                                ID="txtEmail"
                                runat="server"
                                CssClass="input-style"
                                TextMode="Email" />

                        </div>

                        <div>

                            <label class="text-sm font-semibold ml-1">
                                Số điện thoại
                            </label>

                            <asp:TextBox
                                ID="txtSDT"
                                runat="server"
                                CssClass="input-style"
                                TextMode="Number" />

                        </div>

                    </div>

                    <!-- Address -->

                    <div>

                        <label class="text-sm font-semibold ml-1">
                            Địa chỉ
                        </label>

                        <asp:TextBox
                            ID="txtDiaChi"
                            runat="server"
                            CssClass="input-style" />

                    </div>

                    <!-- Error summary -->

                    <div>

                        <asp:ValidationSummary
                            ID="vsLoi"
                            runat="server"
                            DisplayMode="List"
                            ForeColor="Red" />

                    </div>

                    <!-- Button -->

                    <div class="pt-4">

                        <asp:Button
                            ID="btnDangKy"
                            runat="server"
                            Text="ĐĂNG KÝ"
                            OnClick="btnDangKy_Click"
                            CssClass="w-full h-[64px] bg-black text-white font-bold text-lg rounded-[18px] hover:opacity-90 active:scale-95" />

                    </div>

                    <!-- Login link -->

                    <div class="text-center pt-4">

                        <span class="text-slate-500">Bạn đã có tài khoản?
                        </span>

                        <asp:HyperLink
                            ID="lnkDangNhap"
                            runat="server"
                            NavigateUrl="login.aspx"
                            CssClass="font-bold ml-1 text-black">
Đăng nhập
                        </asp:HyperLink>

                    </div>

                </div>

            </div>

            <footer class="mt-8 text-center text-slate-400 text-xs">
                © 2023 113 MOBILE. ALL RIGHTS RESERVED.
            </footer>

        </main>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </form>
</body>
</html>

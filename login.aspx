<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WebDienThoai.login" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - 113Mobile</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #3b82f6;
            --dark: #0f172a;
            --slate-800: #1e293b;
        }

        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #ffffff;
            overflow: hidden;
        }

        .login-container {
            display: flex;
            height: 100vh;
            width: 100vw;
        }
        /* --- CỘT TRÁI: VISUAL NGHỆ THUẬT --- */

        .visual-side {
            flex: 1.2;
            position: relative;
            display: flex;
            align-items: center;
            background: linear-gradient(270deg, #0f172a, #1e293b, #0f1c2e, #1e1b4b);
            background-size: 400% 400%;
            animation: gradientMove 12s ease infinite;
            justify-content: center;
            overflow: hidden;
        }

        @keyframes gradientMove {

            0% {
                background-position: 0% 50%;
            }

            50% {
                background-position: 100% 50%;
            }

            100% {
                background-position: 0% 50%;
            }
        }

        #particles-js {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            opacity: 0.4;
        }

        .phone-wrapper {
            position: relative;
            z-index: 5;
            width: 100%;
            max-width: 500px;
            filter: drop-shadow(0 20px 80px rgba(59, 130, 246, 0.4));
        }

        .floating-phone {
            width: 500px;
            height: auto;
            transform-style: preserve-3d;
        }

        .brand-overlay {
            position: absolute;
            bottom: 60px;
            left: 60px;
            z-index: 10;
            color: white;
            text-align: left;
        }

            .brand-overlay h2 {
                font-weight: 800;
                font-size: 3.5rem;
                margin: 0;
                letter-spacing: -2px;
                background: linear-gradient(to right, #ffffff, #94a3b8);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }
        /* --- CỘT PHẢI: FORM ĐĂNG NHẬP --- */

        .form-side {
            flex: 0.8;
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px;
            position: relative;
        }

        .login-card {
            width: 100%;
            max-width: 420px;
        }

        .welcome-badge {
            display: inline-block;
            background: #eff6ff;
            color: #3b82f6;
            padding: 8px 20px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 20px;
        }

        .title-main {
            font-size: 3rem;
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 8px;
            letter-spacing: -2px;
        }

        .title-sub {
            color: #94a3b8;
            font-size: 1.1rem;
            margin-bottom: 45px;
        }

        .form-group-custom {
            margin-bottom: 25px;
        }

        .label-custom {
            font-size: 0.75rem;
            font-weight: 800;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 10px;
            display: block;
        }

        .form-control-premium {
            width: 100%;
            height: 64px;
            border-radius: 20px;
            border: 2px solid #f1f5f9;
            background: #f8fafc;
            padding: 0 25px;
            font-size: 1rem;
            font-weight: 600;
            color: var(--dark);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

            .form-control-premium:focus {
                background: #ffffff;
                border-color: var(--primary);
                box-shadow: 0 15px 30px rgba(59, 130, 246, 0.12);
                outline: none;
                transform: translateY(-2px);
            }

        .btn-login-premium {
            width: 100%;
            height: 68px;
            border-radius: 20px;
            background: var(--dark);
            color: white;
            font-weight: 800;
            font-size: 1.1rem;
            border: none;
            cursor: pointer;
            transition: all 0.4s;
            margin-top: 20px;
            letter-spacing: 1px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.2);
        }

            .btn-login-premium:hover {
                background: var(--primary);
                transform: translateY(-4px);
                box-shadow: 0 20px 40px rgba(59, 130, 246, 0.3);
            }

        .footer-action {
            margin-top: 40px;
            text-align: center;
            border-top: 1px solid #f1f5f9;
            padding-top: 30px;
        }

        .register-link {
            color: var(--primary);
            font-weight: 800;
            text-decoration: none;
            margin-left: 5px;
        }

            .register-link:hover {
                text-decoration: underline;
            }
        /* Animation Classes for Anime.js */

        .stagger-item {
            opacity: 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <!-- PHẦN HÌNH ẢNH (VISUAL) -->
            <div class="visual-side">
                <div id="particles-js"></div>
                <div class="phone-wrapper">
                    <img src="imgs/iPhone.png" class="floating-phone" alt="iPhone 15 Pro" id="phone-img">
                </div>
                <div class="brand-overlay stagger-item">
                    <h2>113 MOBILE.</h2>
                    <p class="fs-5 opacity-75">Định nghĩa lại trải nghiệm công nghệ cao.</p>
                </div>
            </div>
            <!-- PHẦN BIỂU MẪU (FORM) -->
            <div class="form-side">
                <div class="login-card">
                    <h1 class="title-main stagger-item">Đăng nhập</h1>
                    <p class="title-sub stagger-item">Nhập tài khoản để khám phá đặc quyền thành viên.</p>
                    <div class="form-group-custom stagger-item">

                        <div class="d-flex align-items-center gap-1">
                            <label class="label-custom mb-0">Tên đăng nhập</label>

                            <asp:RequiredFieldValidator
                                ID="refTenDN"
                                runat="server"
                                ControlToValidate="txtTenDN"
                                Display="Dynamic"
                                ErrorMessage="Vui lòng nhập tên đăng nhập"
                                Text="*"
                                ForeColor="Red"
                                Font-Bold="true" />
                        </div>

                        <asp:TextBox
                            ID="txtTenDN"
                            runat="server"
                            CssClass="form-control-premium"
                            placeholder="Tên tài khoản của bạn..." />

                    </div>
                    <div class="form-group-custom stagger-item">

                        <div class="d-flex justify-content-between align-items-center mb-2">

                            <div class="d-flex align-items-center gap-1">
                                <label class="label-custom mb-0">Mật khẩu</label>

                                <asp:RequiredFieldValidator
                                    ID="refPassword"
                                    runat="server"
                                    ControlToValidate="txtPassword"
                                    Display="Dynamic"
                                    ErrorMessage="Vui lòng nhập mật khẩu"
                                    Text="*"
                                    ForeColor="Red"
                                    Font-Bold="true" />
                            </div>

                            <a href="#" class="small text-muted text-decoration-none fw-bold">Quên mật khẩu?
                            </a>

                        </div>

                        <asp:TextBox
                            ID="txtPassword"
                            runat="server"
                            CssClass="form-control-premium"
                            TextMode="Password"
                            placeholder="••••••••" />

                        <asp:CustomValidator
                            ID="cvLogin"
                            runat="server"
                            ErrorMessage="Sai tên đăng nhập hoặc mật khẩu"
                            Display="None" />

                    </div>
                    <div class="stagger-item">
                        <asp:ValidationSummary ID="vsLoi" runat="server" DisplayMode="List" ForeColor="Red" CssClass="alert alert-danger border-0 rounded-4 small py-2 px-3 mb-4" />
                        <asp:Button ID="btnDangNhap" runat="server" CssClass="btn btn-login-premium" Text="ĐĂNG NHẬP NGAY" OnClick="btnDangNhap_Click" />
                    </div>
                    <div class="footer-action stagger-item">
                        <span class="text-muted">Bạn mới sử dụng PhoneStore?</span>
                        <asp:HyperLink ID="lnkDangKy" runat="server" NavigateUrl="register.aspx" CssClass="register-link">Tạo tài khoản</asp:HyperLink>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/animejs/3.2.1/anime.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/tsparticles@3/tsparticles.bundle.min.js"></script>
    <script> // 1. Particle Background Effect
        document.addEventListener("DOMContentLoaded", function () {

            tsParticles.load("particles-js", {
                background: {
                    color: "transparent"
                },

                particles: {

                    number: {
                        value: 80,
                        density: {
                            enable: true,
                            area: 800
                        }
                    },

                    color: {
                        value: ["#38bdf8", "#60a5fa", "#fbbf24"]
                        // cyan + blue + gold
                    },

                    shape: {
                        type: "circle"
                    },

                    opacity: {
                        value: 0.7,
                        random: true
                    },

                    size: {
                        value: { min: 1, max: 3 }
                    },

                    links: {
                        enable: true,
                        distance: 150,
                        color: "#38bdf8",
                        opacity: 0.25,
                        width: 1
                    },

                    move: {
                        enable: true,
                        speed: 1.2,
                        outModes: {
                            default: "out"
                        }
                    }
                },

                interactivity: {

                    events: {
                        onHover: {
                            enable: true,
                            mode: "grab"
                        },

                        onClick: {
                            enable: true,
                            mode: "push"
                        }
                    },

                    modes: {

                        grab: {
                            distance: 200,
                            links: {
                                opacity: 0.7
                            }
                        },

                        push: {
                            quantity: 4
                        }
                    }
                },

                detectRetina: true
            });


            /* animation form */

            const items = document.querySelectorAll(".stagger-item");

            items.forEach((el, i) => {
                el.style.transform = "translateY(40px)";
                el.style.opacity = "0";

                setTimeout(() => {
                    el.style.transition = "all 0.8s ease";
                    el.style.transform = "translateY(0)";
                    el.style.opacity = "1";
                }, i * 120);
            });


            /* floating phone */

            const phone = document.getElementById("phone-img");

            let dir = 1;

            setInterval(() => {

                phone.style.transition = "transform 4s ease-in-out";

                phone.style.transform =
                    `translateY(${dir * 15}px) rotate(${dir * 2}deg)`;

                dir *= -1;

            }, 4000);

        });
    </script>
</body>
</html>

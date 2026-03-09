$(document).ready(function () {
    const urlParams = new URLSearchParams(window.location.search);
    // ==== Slide ảnh sản phẩm tự động ====
    $('.col-lg-5').each(function () {
        const $col = $(this);
        const $thumbs = $col.find('.thumb-img');
        const $mainImg = $col.find('.main-img');

        if ($thumbs.length <= 1 || !$mainImg.length) return;

        let index = 0;

        setInterval(function () {
            index = (index + 1) % $thumbs.length;
            slideChange($mainImg, $thumbs, index);
        }, 10000); // 10 giây (thay vì 100000ms)
    });

    function slideChange($mainImg, $thumbs, index) {
        $mainImg.addClass('slide-out');

        setTimeout(function () {
            $mainImg.attr('src', $thumbs.eq(index).attr('src'));

            $thumbs.removeClass('active');
            $thumbs.eq(index).addClass('active');

            $mainImg.removeClass('slide-out').addClass('slide-in');

            setTimeout(function () {
                $mainImg.removeClass('slide-in');
            }, 400);

        }, 300);
    }

    // ==== Click vào ảnh thumb ====
    $('.thumb-img').click(function () {
        const $col = $(this).closest('.col-lg-5');
        const $mainImg = $col.find('.main-img');
        const $thumbs = $col.find('.thumb-img');

        const index = $thumbs.index(this);
        slideChange($mainImg, $thumbs, index);
    });

    // ==== Chọn màu ====
    $('.color-dot').click(function () {
        $('.color-dot').removeClass('active');
        $(this).addClass('active');

        var mamau = $(this).data('mamau');
        $('#selectedMaMau').val(mamau);

        const url = new URL(window.location);
        url.searchParams.set("mamau", mamau);
        window.location.href = url.toString();
    });

    // ==== Lấy màu từ URL khi load trang ====
    var mamau = urlParams.get("mamau");

    if (mamau) {
        const $dot = $(`.color-dot[data-mamau='${mamau}']`);
        if ($dot.length) $dot.addClass('active');
    }

    // ==== Thêm vào giỏ hàng ====
    $(document).on("click", "#btnAddToCart", function (e) {
        e.preventDefault();
        var mamau = urlParams.get("mamau");
        var masp = urlParams.get("masp");
        console.log("mã màu: " + mamau + " mã sp: " + masp);
        if (!mamau || !masp) {
            Swal.fire({
                title: 'Thất bại!',
                text: 'Vui lòng chọn màu sắc',
                icon: 'error',
                confirmButtonText: 'OK'
            });
            return;
        }
        $.ajax({
            type: "POST",
            url: "Detail.aspx/AddToCart",
            data: JSON.stringify({
                maSP: parseInt(masp),
                maMau: parseInt(mamau)
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (res) {
                if (res.d > 0) {
                    $("#cartCount").text(res.d);

                    Swal.fire({
                        icon: 'success',
                        title: 'Thành công',
                        text: 'Đã thêm sản phẩm vào giỏ hàng'
                    });
                }
            },
            error: function () {
                Swal.fire("Lỗi", "Không thể thêm vào giỏ hàng", "error");
            }
        });
    });
    $('.product-slider').slick({
        dots: false,
        infinite: true, // Chạy vô tận 
        speed: 500, // Tốc độ chuyển động (ms) 
        slidesToShow: 4, // Hiện 4 sản phẩm cùng lúc trên Desktop 
        slidesToScroll: 1, // Mỗi lần bấm mũi tên nhảy 1 sản phẩm 
        autoplay: true, // Tự động chạy 
        autoplaySpeed: 3000, // 3 giây chuyển 1 lần 
        arrows: true, // Hiện 2 mũi tên 
        responsive: [ // Cấu hình hiển thị trên các thiết bị khác nhau 
            { breakpoint: 1024, settings: { slidesToShow: 3, slidesToScroll: 1 } },
            { breakpoint: 768, settings: { slidesToShow: 2, slidesToScroll: 1 } },
            { breakpoint: 480, settings: { slidesToShow: 1, slidesToScroll: 1 } }]
    });

    $("#txtSearch").keyup(function () {

        let keyword = $(this).val();

        if (keyword.length < 2) {
            $("#suggestBox").hide();
            return;
        }

        $.ajax({
            url: "/customer/Handler/SearchSuggest.ashx",
            type: "GET",
            data: { q: keyword },

            success: function (res) {
                console.log(res);
                let html = "";

                res.forEach(function (sp) {

                    html += `
<a href="/Customer/Detail.aspx?masp=${sp.MaSP}&mansx=${sp.MaNhaSX}" class="suggest-item">
    <img src="/imgs/${sp.Hinh}" width="40">
    <div>
        <div>${sp.TenSP}</div>
        <small>${Number(sp.Gia).toLocaleString()} ₫</small>
    </div>
</a>
`;

                });

                $("#suggestBox").html(html).show();
            }
        });

    });
    $("#btnSearch").click(function () {

        let keyword = $("#txtSearch").val().trim();
        
        if (keyword !== "") {
            window.location.href = "/Customer/Product.aspx?keyword=" + encodeURIComponent(keyword);
            console.log("Không có điều hướng");
        }

    });

    $('#btnThongBao').parent().on('hidden.bs.dropdown', function () {

        $.ajax({
            type: "POST",
            url: "/Admin/Handler/DanhDauThongBao.ashx",
            contentType: "application/json; charset=utf-8",
            data: "{}",
            success: function () {
                $("#spnThongBaoDot").fadeOut();
            },
            error: function (err) {
                console.log(err);
            }
        });

    });
});

function previewImage(input) {
    var file = input.files[0];

    if (!file) return;

    var maxSize = 5 * 1024 * 1024; // 5MB
    var allowedTypes = ["image/jpeg", "image/png", "image/gif"];

    // kiểm tra dung lượng
    if (file.size > maxSize) {
        alert("File không được vượt quá 5MB!");
        $(input).val("");
        return;
    }

    // kiểm tra định dạng
    if ($.inArray(file.type, allowedTypes) === -1) {
        alert("Chỉ cho phép file JPG, JPEG, PNG, GIF!");
        $(input).val("");
        return;
    }

    var reader = new FileReader();
    reader.onload = function (e) {
        $("#imgPreview").attr("src", e.target.result);
    };
    reader.readAsDataURL(file);
}

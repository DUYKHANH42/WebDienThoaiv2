$(document).ready(function () {
    const urlParams = new URLSearchParams(window.location.search);
    // ==== Slide ảnh sản phẩm tự động ====
    $('.col-md-4').each(function () {
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
        const $col = $(this).closest('.col-md-4');
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
    $(document).on("click", ".btnAddToCart", function (e) {
        e.preventDefault();
        var mamau = urlParams.get("mamau");
        var masp = urlParams.get("masp");
        //console.log("mã màu: " + mamau + " mã sp: " + masp);
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
});

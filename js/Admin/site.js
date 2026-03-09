$(function () {


    const $body = $('body');
    const $sidebar = $('#adminSidebar');
    const $toggleBtn = $('#btnToggleSidebar');
    const desktopWidth = 992; // chuẩn Bootstrap lg

    /* =====================================================
       SIDEBAR TOGGLE
    ===================================================== */

    function handleSidebarState() {
        const isDesktop = $(window).width() >= desktopWidth;

        if (isDesktop) {
            $body.removeClass('sidebar-open');
            const saved = localStorage.getItem('sidebarCollapsed');
            if (saved === 'true') {
                $body.addClass('sidebar-collapsed');
            }
        } else {
            $body.removeClass('sidebar-collapsed');
        }
    }

    // Toggle click
    $toggleBtn.on('click', function () {

        const isDesktop = $(window).width() >= desktopWidth;

        if (isDesktop) {
            $body.toggleClass('sidebar-collapsed');

            const collapsed = $body.hasClass('sidebar-collapsed');
            localStorage.setItem('sidebarCollapsed', collapsed);

        } else {
            $body.toggleClass('sidebar-open');
        }

    });

    // Restore on load
    handleSidebarState();

    // On resize (debounce nhẹ cho mượt)
    let resizeTimeout;
    $(window).on('resize', function () {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(handleSidebarState, 150);
    });


    /* =====================================================
       ACTIVE MENU HIGHLIGHT
    ===================================================== */

    const currentPath = window.location.pathname.toLowerCase();
    const currentPage = currentPath.split('/').pop();
    $('.sidebar-nav .nav-link').each(function () {

        const $link = $(this);
        const href = $link.attr('href');

        if (!href || href === '#' || href.startsWith('#')) return;

        const linkPage = href.split('/').pop().toLowerCase();

        if (currentPage === linkPage) {

            $link.addClass('active');

            // Nếu nằm trong submenu collapse
            const $collapse = $link.closest('.collapse');

            if ($collapse.length) {
                $collapse.addClass('show');

                const parentTrigger = $(`[href="#${$collapse.attr('id')}"]`);
                parentTrigger.addClass('active');
            }

        }

    });


    /* =====================================================
       CLOSE SIDEBAR MOBILE WHEN CLICK OUTSIDE
    ===================================================== */

    $(document).on('click', function (e) {

        const isMobile = $(window).width() < desktopWidth;

        if (
            isMobile &&
            $body.hasClass('sidebar-open') &&
            !$sidebar.is(e.target) &&
            $sidebar.has(e.target).length === 0 &&
            !$(e.target).closest('#btnToggleSidebar').length
        ) {
            $body.removeClass('sidebar-open');
        }

    });


    /* =====================================================
       SMOOTH SCROLL (TRỪ BOOTSTRAP COLLAPSE)
    ===================================================== */
    $('a[href^="#"]').on('click', function (e) {

        if ($(this).attr('data-bs-toggle')) return;

        const target = $($(this).attr('href'));

        if (target.length) {
            e.preventDefault();

            $('html, body').animate({
                scrollTop: target.offset().top - 80
            }, 400);
        }

    });

});

$(document).ready(function () {

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

})
tailwind.config = {
    darkMode: "class",
    theme: {
        extend: {
            colors: {
                "primary": "#ec5b13",
                "background-light": "#f8f6f6",
                "background-dark": "#221610",
            },
            fontFamily: {
                "display": ["Public Sans", "sans-serif"]
            },
            borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
        },
    },
}

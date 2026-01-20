// ==================== SIDEBAR TOGGLE ====================
document.addEventListener('DOMContentLoaded', function () {
    const sidebarToggle = document.getElementById('sidebarToggle');
    const body = document.body;

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function () {
            // For desktop - collapse sidebar
            if (window.innerWidth > 768) {
                body.classList.toggle('sidebar-collapsed');
                // Save state to localStorage
                const isCollapsed = body.classList.contains('sidebar-collapsed');
                localStorage.setItem('sidebarCollapsed', isCollapsed);
            } else {
                // For mobile - show/hide sidebar
                body.classList.toggle('sidebar-open');
            }
        });
    }

    // Restore sidebar state from localStorage on page load
    const savedState = localStorage.getItem('sidebarCollapsed');
    if (savedState === 'true' && window.innerWidth > 768) {
        body.classList.add('sidebar-collapsed');
    }

    // Handle window resize
    window.addEventListener('resize', function () {
        if (window.innerWidth > 768) {
            body.classList.remove('sidebar-open');
            // Restore collapsed state for desktop
            const savedState = localStorage.getItem('sidebarCollapsed');
            if (savedState === 'true') {
                body.classList.add('sidebar-collapsed');
            }
        } else {
            body.classList.remove('sidebar-collapsed');
        }
    });
});

// ==================== ACTIVE MENU HIGHLIGHT ====================
document.addEventListener('DOMContentLoaded', function () {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.sidebar-nav .nav-link');

    navLinks.forEach(link => {
        const href = link.getAttribute('href');

        // Remove ~ from href if present for comparison
        const cleanHref = href ? href.replace('~', '') : '';

        if (currentPath.includes(cleanHref) && cleanHref !== '#') {
            link.classList.add('active');

            // If link is inside a collapse menu, expand it
            const collapse = link.closest('.collapse');
            if (collapse) {
                collapse.classList.add('show');
                // Add active class to parent menu item
                const parentLink = document.querySelector(`[href="#${collapse.id}"]`);
                if (parentLink) {
                    parentLink.classList.add('active');
                }
            }
        } else {
            link.classList.remove('active');
        }
    });
});

// ==================== CLOSE SIDEBAR ON MOBILE WHEN CLICKING OUTSIDE ====================
document.addEventListener('DOMContentLoaded', function () {
    const sidebar = document.getElementById('adminSidebar');
    const body = document.body;

    document.addEventListener('click', function (event) {
        if (window.innerWidth <= 768 && body.classList.contains('sidebar-open')) {
            // Check if click is outside sidebar and toggle button
            if (!sidebar.contains(event.target) &&
                !event.target.closest('#sidebarToggle')) {
                body.classList.remove('sidebar-open');
            }
        }
    });
});

// ==================== SMOOTH SCROLL FOR ANCHOR LINKS ====================
document.addEventListener('DOMContentLoaded', function () {
    const anchorLinks = document.querySelectorAll('a[href^="#"]');

    anchorLinks.forEach(link => {
        link.addEventListener('click', function (e) {
            const href = this.getAttribute('href');

            // Skip if it's a Bootstrap collapse toggle
            if (this.hasAttribute('data-bs-toggle')) {
                return;
            }

            if (href !== '#' && document.querySelector(href)) {
                e.preventDefault();
                const target = document.querySelector(href);
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

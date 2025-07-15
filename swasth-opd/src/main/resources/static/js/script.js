document.addEventListener('DOMContentLoaded', function () {
    console.log("Script loaded and DOM ready.");

    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.getElementById('sidebar');
    const wrapper = document.querySelector('.wrapper');

    if (!sidebarToggle || !sidebar || !wrapper) {
        console.error("Sidebar toggle or wrapper not found.");
        return;
    }

    // Sidebar toggle logic
    sidebarToggle.addEventListener('click', function () {
        wrapper.classList.toggle('sidebar-collapsed');
        localStorage.setItem('sidebarState', wrapper.classList.contains('sidebar-collapsed') ? 'collapsed' : 'expanded');
    });

    // Restore sidebar state from localStorage
    const savedState = localStorage.getItem('sidebarState');
    if (savedState === 'collapsed') {
        wrapper.classList.add('sidebar-collapsed');
    }

    // Mark active link
    const currentPath = window.location.pathname.replace(/\/$/, '');
    wrapper.querySelectorAll('#sidebar a').forEach(link => {
        const href = link.getAttribute('href').replace(/\/$/, '');
        if (href === currentPath || (currentPath.startsWith(href) && href !== '/')) {
            link.classList.add('active');
        }
    });
});

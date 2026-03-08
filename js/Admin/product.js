// ========================
// IMAGE DELETE TOGGLE
// ========================
window.toggleDelete = function (btn) {

    var $box = $(btn).closest(".img-item");
    var $chk = $box.find("input[type=checkbox]");

    $chk.prop("checked", !$chk.prop("checked"));

    if ($chk.prop("checked")) {
        $box.addClass("border-danger border-3 opacity-50");
        $(btn).addClass("active");
    } else {
        $box.removeClass("border-danger border-3 opacity-50");
        $(btn).removeClass("active");
    }
};
function getModal() {
    const el = document.getElementById('modalEdit');
    if (!el || typeof bootstrap === "undefined") return null;
    return bootstrap.Modal.getOrCreateInstance(el);
}

window.openEditModal = function () {
    const modal = getModal();
    if (modal) modal.show();
};

window.closeEditModal = function () {
    const modal = getModal();
    if (modal) modal.hide();
};

// QUAN TRỌNG NHẤT
if (typeof (Sys) !== "undefined") {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        window.openEditModal = window.openEditModal;
        window.closeEditModal = window.closeEditModal;
    });
}
function deleteSP(id) {

    Swal.fire({
        title: 'Bạn có muốn ẩn sản phẩm khỏi Website',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Ẩn',
        cancelButtonText: 'Quay lại',
        confirmButtonColor: '#d33'
    }).then((result) => {

        if (!result.isConfirmed) return;

        fetch('Product.aspx/DeleteSP', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: id })
        })
            .then(res => res.json())
            .then(data => {

                if (data.d.success) {

                    const row = document.querySelector(`tr[data-id="${id}"]`);

                    if (row) {
                        row.style.transition = "all .3s ease";
                        row.style.opacity = "0";
                        row.style.transform = "translateX(-10px)";

                        setTimeout(() => row.remove(), 300);
                    }

                    Toast.fire({
                        icon: 'success',
                        title: 'Đã xóa sản phẩm'
                    });

                } else {
                    Toast.fire({
                        icon: 'error',
                        title: data.d.message || 'Xóa thất bại'
                    });
                }

            })
            .catch(() => {
                Toast.fire({
                    icon: 'error',
                    title: 'Không kết nối server'
                });
            });

    });

    return false;
}

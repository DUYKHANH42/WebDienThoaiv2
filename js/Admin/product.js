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
        title: 'Xóa sản phẩm?',
        text: 'Toàn bộ hình ảnh & cấu hình sẽ mất vĩnh viễn',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy',
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
                    if (row) row.remove();
                } else {
                    Swal.fire('Lỗi', data.d.message, 'error');
                }
            })
            .catch(() => Swal.fire('Lỗi', 'Không kết nối server', 'error'));
    });
}

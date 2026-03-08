function initProductPage() {
    // ========================
    // THÊM DÒNG GIÁ (Table Row)
    // ========================
    window.addGiaRow = function () {
        const tr = `
    <tr class="align-middle">
        <td><input class="form-control form-control-sm border-light bg-light rounded-3 ram" name="ram" placeholder="Ví dụ: 8GB"></td>
        <td><input class="form-control form-control-sm border-light bg-light rounded-3 rom" name="rom" placeholder="Ví dụ: 256GB"></td>
        <td><input class="form-control form-control-sm border-light bg-light rounded-3 fw-bold text-primary gia" name="gia" type="number" placeholder="0"></td>
        <td class="text-center">
            <button type="button" class="btn btn-outline-danger btn-sm rounded-circle border-0 btn-del-row" title="Xóa dòng">
                <i class="fas fa-times-circle"></i>
            </button>
        </td>
    </tr>`;
        $("#tblGia tbody").append(tr);
    };

    // XÓA DÒNG
    $(document).off("click", ".btn-del-row")
        .on("click", ".btn-del-row", function () {
            $(this).closest("tr").fadeOut(300, function () { $(this).remove(); });
        });

    // ========================
    // THÊM MÀU SẮC (Badges)
    // ========================
    window.addColor = function () {
        const id = $("#" + ddlColorID).val();
        const text = $("#" + ddlColorID + " option:selected").text();
        if (!id) return;
        if ($(`input[name='colors'][value='${id}']`).length > 0) {
            Swal.fire('Thông báo', 'Màu sắc này đã được thêm vào danh sách!', 'warning');
            return;
        }

        // Giao diện Badge màu sắc cao cấp
        const tag = `
    <span class="badge bg-primary-subtle text-primary border border-primary-subtle p-2 px-3 rounded-pill color-tag d-flex align-items-center me-2 mb-2 shadow-sm transition">
        <i class="fas fa-palette me-2"></i>
        ${text}
        <i class="fas fa-times-circle ms-2 remove-color text-danger" style="cursor:pointer; opacity: 0.7;"></i>
    </span>`;

        const hiddenInput = `<input type="hidden" name="colors" value="${id}">`;
        const $tagContainer = $('<div class="d-inline-block"></div>').append(hiddenInput).append(tag);

        $("#colorBox").append($tagContainer);
    };

    $(document).on("click", ".remove-color", function () {
        $(this).closest(".d-inline-block").fadeOut(200, function () { $(this).remove(); });
    });

    // ========================
    // PREVIEW ẢNH ĐẠI DIỆN
    // ========================
    $(document).off("change", "#multiImg")
        .on("change", "#multiImg", function () {
            const box = $("#previewImg");
            box.empty();
            const files = this.files;
            if (!files || files.length === 0) return;
            $.each(files, function (_, file) {
                const url = URL.createObjectURL(file);
                const img = `<div class="position-relative shadow-sm rounded-3 overflow-hidden border m-1" style="width: 100px; height: 100px;">
                                <img src="${url}" class="w-100 h-100 object-fit-cover">
                             </div>`;
                box.append(img);
            });
        });

    // ========================
    // THÊM ẢNH VÀO ALBUM (Nội dung)
    // ========================
    $(document).off("change", "#fuAlbum") // Sửa đúng ID fuAlbum của bạn
        .on("change", "#fuAlbum", function () {
            const files = this.files;
            if (!files || files.length === 0) return;
            $.each(files, function (_, file) {
                const url = URL.createObjectURL(file);
                const item = `
                <div class="album-item position-relative shadow-sm rounded-4 border p-1 m-1 bg-white transition" style="width: 110px; height: 110px;">
                    <img src="${url}" class="w-100 h-100 rounded-3 object-fit-cover">
                    <button type="button" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle p-1 album-remove shadow" style="width: 24px; height: 24px; font-size: 10px;">
                        <i class="fas fa-times"></i>
                    </button>
                </div>`;
                $("#albumPreview").append(item);
            });
            $(this).val("");
        });

    // XÓA ẢNH KHỎI ALBUM
    $(document).off("click", ".album-remove")
        .on("click", ".album-remove", function () {
            $(this).closest(".album-item").fadeOut(300, function () { $(this).remove(); });
        });
}

// ===== CSS Bổ sung cho hiệu ứng =====
$("<style>")
    .prop("type", "text/css")
    .html(`
        .transition { transition: all 0.3s ease; }
        .transition:hover { transform: translateY(-3px); }
        .album-item:hover { border-color: #3b82f6 !important; }
        .color-tag:hover { border-color: #3b82f6 !important; background: #fff !important; }
    `)
    .appendTo("head");

// ===== CHẠY LẦN ĐẦU =====
$(document).ready(initProductPage);

// ===== CHẠY SAU UPDATEPANEL POSTBACK =====
if (typeof (Sys) !== "undefined") {
    Sys.Application.add_load(initProductPage);
}
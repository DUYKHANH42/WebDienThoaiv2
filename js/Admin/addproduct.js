
function initProductPage() {

    // ========================
    // THÊM DÒNG GIÁ
    // ========================
    window.addGiaRow = function () {

        const tr = `
    <tr>
        <td><input class="form-control ram" name="ram"></td>
        <td><input class="form-control rom" name="rom"></td>
        <td><input class="form-control gia" name="gia" type="number"></td>
        <td>
            <button type="button" class="btn btn-danger btn-sm btn-del-row">X</button>
        </td>
    </tr>`;

        $("#tblGia tbody").append(tr);
    };


    // XÓA DÒNG
    $(document).off("click", ".btn-del-row")
        .on("click", ".btn-del-row", function () {
            $(this).closest("tr").remove();
        });


    window.addColor = function () {

        const id = $("#" + ddlColorID).val();
        const text = $("#" + ddlColorID + " option:selected").text();

        if (!id) return;

        if ($(`input[name='colors'][value='${id}']`).length > 0) {
            alert("Màu đã tồn tại");
            return;
        }

        const tag = `
    <span class="badge bg-dark p-2 color-tag me-1">
        ${text}
        <span class="ms-1 text-warning remove-color" style="cursor:pointer">✕</span>
    </span>`;

        $("#colorBox").append(`<input type="hidden" name="colors" value="${id}">`);
        $("#colorBox").append(tag);
    };

    $(document).on("click", ".remove-color", function () {

        const tag = $(this).closest(".color-tag");
        tag.prev("input[name='colors']").remove();
        tag.remove();
    });





    // ========================
    // PREVIEW ẢNH
    // ========================
    $(document).off("change", "#multiImg")
        .on("change", "#multiImg", function () {

            const box = $("#previewImg");
            box.empty();

            const files = this.files;
            if (!files || files.length === 0) return;

            $.each(files, function (_, file) {

                const url = URL.createObjectURL(file);

                const img = $("<img>", {
                    src: url,
                    class: "rounded border m-1",
                    css: { width: "100px", height: "100px", objectFit: "cover" }
                });

                box.append(img);
            });
        });
    // thêm ảnh vào album
    $(document).off("change", "#multiAlbum")
        .on("change", "#multiAlbum", function () {

            const files = this.files;
            if (!files || files.length === 0) return;

            $.each(files, function (_, file) {

                const url = URL.createObjectURL(file);

                const item = `
                <div class="album-item">
                    <img src="${url}">
                    <button type="button" class="album-remove">×</button>
                </div>`;

                $("#albumPreview").append(item);
            });

            // reset input -> cho phép chọn lại cùng file
            $(this).val("");
        });


    // xóa ảnh khỏi album
    $(document).off("click", ".album-remove")
        .on("click", ".album-remove", function () {
            $(this).closest(".album-item").remove();
        });

}
// ===== CHẠY LẦN ĐẦU =====
$(document).ready(initProductPage);

// ===== CHẠY SAU UPDATEPANEL POSTBACK =====
if (typeof (Sys) !== "undefined") {
    Sys.Application.add_load(initProductPage);
}
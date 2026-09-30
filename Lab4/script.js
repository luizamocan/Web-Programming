$(document).ready(function () {

    const sortAsc = [true, true, true, true];

    $("#myTable thead th").click(function () {
        const index = $(this).index();
        const rows = $("#myTable tbody tr").toArray();

        rows.sort(function (a, b) {
            const A = $(a).children().eq(index).text();
            const B = $(b).children().eq(index).text();

            return sortAsc[index] ? A - B : B - A;
        });

        sortAsc[index] = !sortAsc[index];
        $("#myTable tbody").append(rows);
    });

    $("#myTable tfoot td").click(function () {
        const index = $(this).index();
        const next = (index + 1) % 4;

        $("#myTable tbody tr").each(function () {
            const cells = $(this).children();
            const temp = cells.eq(index).text();

            cells.eq(index).text(cells.eq(next).text());
            cells.eq(next).text(temp);
        });
    });

});
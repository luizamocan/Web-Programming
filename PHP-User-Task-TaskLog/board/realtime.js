function refreshBoard()
{
    let xhr =
        new XMLHttpRequest();

    xhr.onreadystatechange =
    function()
    {
        if(xhr.readyState == 4
           &&
           xhr.status == 200)
        {
            document.getElementById(
                "board-container"
            ).innerHTML =
                xhr.responseText;
        }
    };

    xhr.open(
        "GET",
        "board_refresh.php",
        true
    );

    xhr.send();
}

setInterval(
    refreshBoard,
    3000
);
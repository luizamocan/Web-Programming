<?php

session_start();

if(!isset($_SESSION['name']))
{
    header("Location: login.php");
    exit();
}

?>

<!DOCTYPE html>

<html>

<head>

    <title>

        Instant Search

    </title>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>

    Search Players

</h2>

<input type="text"

       id="search"

       onkeyup="searchPlayers()"

       placeholder="Type a name">

<br><br>

<ul id="results">

</ul>

<br><br>

<a href="dashboard.php">

    Back to dashboard

</a>

<script>

function searchPlayers()
{
    let text =
        document.getElementById(
            "search"
        ).value;

    let xhr =
        new XMLHttpRequest();

    xhr.onreadystatechange =
    function()
    {
        if(xhr.readyState == 4
           &&
           xhr.status == 200)
        {
            let players =
                xhr.responseText
                .trim()
                .split("\n");

            players.sort();

            let html = "";

            for(let i = 0;
                i < players.length;
                i++)
            {
                if(players[i] != "")
                {
                    html +=
                        "<li>"
                        + players[i]
                        + "</li>";
                }
            }

            document.getElementById(
                "results"
            ).innerHTML = html;
        }
    };

    xhr.open(
        "GET",
        "search_ajax.php?text="
        + encodeURIComponent(text),
        true
    );

    xhr.send();
}

</script>

</body>

</html>

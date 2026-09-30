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

    Search Patients

</h2>

<input type="text"

       id="search"

       onkeyup="searchPatients()"

       placeholder="Type a name">

<br><br>

<ul id="results">

</ul>

<br><br>

<a href="dashboard.php">

    Back to dashboard

</a>

<script>

function searchPatients()
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
            let patients =
                xhr.responseText
                .trim()
                .split("\n");

            patients.sort();

            let html = "";

            for(let i = 0;
                i < patients.length;
                i++)
            {
                if(patients[i] != "")
                {
                    html +=
                        "<li>"
                        + patients[i]
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

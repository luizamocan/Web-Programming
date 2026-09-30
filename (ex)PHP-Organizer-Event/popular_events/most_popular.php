<?php

session_start();

if(!isset($_SESSION['username']))
{
    header("Location: login/login.php");
    exit();
}

?>

<!DOCTYPE html>

<html>

<head>

    <title>

        Popular Events

    </title>

    <link rel="stylesheet"
          href="../style.css">

</head>

<body>

<h2>

    Top 3 Popular Events

</h2>

Filter by remaining capacity:

<input type="number"

       id="threshold"

       onkeyup="filterEvents()"

       placeholder="e.g. 10">

<br><br>

<?php

include(
    "popular_events_table.php"
);

?>

<br><br>

<a href="../dashboard.php">

    Back to dashboard

</a>

<script src="filter_events.js"></script>

</body>

</html>
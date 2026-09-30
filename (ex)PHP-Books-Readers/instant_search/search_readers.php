<?php

session_start();

if(!isset($_SESSION['name']))
{
    header("Location: ../login.php");
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
          href="../style.css">

</head>

<body>

<h2>

    Search Readers

</h2>

<input type="text"

       id="search"

       onkeyup="searchReaders()"

       placeholder="Type a name">

<br><br>

<ul id="results">

</ul>

<br><br>

<a href="../dashboard.php">

    Back to dashboard

</a>

<script src = "search.js"></script>
</body>

</html>

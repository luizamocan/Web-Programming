<?php

session_start();
include "db.php";

if(!isset($_SESSION['name'])){
    header("Location: login.php");
    exit();
}

//echo "<h2> Welcome, " . $_SESSION['name'] . "! </h2>";

?>

<!DOCTYPE html>

<html>

<head>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>
    Main Dashboard
</h2>




<a href="instant_search/search_readers.php">

   Search patients

</a>

<br><br>

<a href="display_degree.php">

   Display the N-th degree
</a>

<br><br>

<a href="logout.php">
    Logout
</a>


</body>
</html>
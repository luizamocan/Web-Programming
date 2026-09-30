<?php

session_start();
include ("db.php");

if(!isset($_SESSION['username'])){
    header("Location: login/login.php");
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




<a href="display_events.php">

  Display all events

</a>

<br><br>

<a href="my_events.php">

   Display My registered Events
</a>

<br><br>

<a href="register_participants.php">

  Register Partcipants
</a>

<br><br>

<a href="popular_events/most_popular.php">

   Display Post Popular Events
</a>

<br><br>

<a href="logout.php">
    Logout
</a>


</body>
</html>
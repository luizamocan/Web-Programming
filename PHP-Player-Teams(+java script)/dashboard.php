<?php

session_start();
include "db.php";

if(!isset($_SESSION['name'])){
    header("Location: login.php");
    exit();
}
?>
<!DOCTYPE html>

<html>

<head>


    <link rel="stylesheet"
          href="style.css">

</head>

<body>
<?php
echo "<h2> Welcome, " . $_SESSION['name'] . "! </h2>";

?>

<a href="search_player.php">
    Search for players
</a>

<br><br>

<a href="display_degree.php">
    Display the N-th degree teammate
</a>

<br><br>


<a href="logout.php">
    Logout
</a>


</body>
</html>


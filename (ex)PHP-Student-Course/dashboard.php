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



<a href="all_courses.php">
    All courses
</a>

<br><br>

<a href="my_courses.php">
    My courses
</a>

<br><br>


<a href="assign_student.php">

    Assign Student to Course

</a>

<br><br>
<a href="logout.php">
    Logout
</a>


</body>
</html>
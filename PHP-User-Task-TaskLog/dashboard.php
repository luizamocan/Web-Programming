<?php

session_start();

if(!isset(
    $_SESSION['username']
))
{
    header(
        "Location: login/login.php"
    );

    exit();
}

?>

<!DOCTYPE html>

<html>

<head>

    <title>

        Dashboard

    </title>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>

    Welcome,

    <?= $_SESSION['username'] ?>

</h2>

<p>

    Tasks moved
    during this session:

    <strong>

        <?= $_SESSION['moves'] ?>

    </strong>

</p>

<a href="board/board.php">

    View Task Board

</a>

<br><br>

<a href="move_task/move_task.php">

    Move Tasks

</a>

<br><br>

<a href="logout/logout.php">

    Logout

</a>

</body>

</html>
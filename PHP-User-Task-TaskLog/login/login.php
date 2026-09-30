<?php

session_start();

include("../db.php");

if(isset($_POST['username']))
{
    $username =
        $_POST['username'];

    $result =
        $conn->query(

        "SELECT *

         FROM users

         WHERE username='$username'"

        );

    $user =
        $result->fetch_assoc();

    if($user)
    {
        $_SESSION['userId']
            =
            $user['id'];

        $_SESSION['username']
            =
            $user['username'];

        if(!isset(
            $_SESSION['moves']
        ))
        {
            $_SESSION['moves']
                = 0;
        }

        header(
            "Location: ../dashboard.php"
        );

        exit();
    }
    else
    {
        echo
        "<p>

        User not found.

        </p>";
    }
}

include(
    "login_form.php"
);

?>
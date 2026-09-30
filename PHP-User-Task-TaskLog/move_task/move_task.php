<?php

session_start();

include("../db.php");

if(!isset($_SESSION['userId']))
{
    header("Location: ../login/login.php");
    exit();
}

if(isset($_POST['taskId']))
{
    $taskId =
        $_POST['taskId'];

    $newStatus =
        $_POST['newStatus'];

    /*
    |--------------------------------
    | Get old task data
    |--------------------------------
    */

    $task =
        $conn->query(

        "SELECT *

         FROM tasks

         WHERE id='$taskId'"

        )->fetch_assoc();

    $oldStatus =
        $task['status'];

    /*
    |--------------------------------
    | Update task
    |--------------------------------
    */

    $conn->query(

    "UPDATE tasks

     SET

     status='$newStatus',

     assignedTo='"
     . $_SESSION['userId']
     . "',

     lastUpdated=NOW()

     WHERE id='$taskId'"

    );

    /*
    |--------------------------------
    | Save log
    |--------------------------------
    */

    $conn->query(

    "INSERT INTO tasklog(

        taskId,

        userId,

        oldStatus,

        newStatus,

        timestamp

    )

    VALUES(

        '$taskId',

        '"
        . $_SESSION['userId']
        . "',

        '$oldStatus',

        '$newStatus',

        NOW()

    )"

    );

    /*
    |--------------------------------
    | Session counter
    |--------------------------------
    */

    $_SESSION['moves']++;

    echo

    "<p>

    Task moved successfully.

    </p>";
}

include(
    "move_task_form.php"
);

?>

<br><br>

<a href="../dashboard.php">

    Back to dashboard

</a>
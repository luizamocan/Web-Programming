<!DOCTYPE html>

<html>

<head>

    <title>

        Move Task

    </title>

    <link rel="stylesheet"
          href="../style.css">

</head>

<body>

<h2>

    Move Task

</h2>

<form method="POST">

    Task:

    <select name="taskId">

    <?php

    $result =
        $conn->query(

        "SELECT *

         FROM tasks"

        );

    while($task =
          $result->fetch_assoc())
    {
    ?>

        <option

            value="<?= $task['id'] ?>">

            <?= $task['title'] ?>

            (

            <?= $task['status'] ?>

            )

        </option>

    <?php
    }

    ?>

    </select>

    <br><br>

    New Status:

    <select name="newStatus">

        <option value="todo">

            TO DO

        </option>

        <option value="in_progress">

            IN PROGRESS

        </option>

        <option value="done">

            DONE

        </option>

    </select>

    <br><br>

    <input type="submit"

           value="Move Task">

</form>

</body>

</html>
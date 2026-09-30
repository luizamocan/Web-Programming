<?php

include("../db.php");

$statuses = [

    'todo' => 'TO DO',

    'in_progress' => 'IN PROGRESS',

    'done' => 'DONE'

];

echo "<div style='display:flex;gap:30px;'>";

foreach($statuses as $key => $title)
{
    echo "<div>";

    echo "<h3>$title</h3>";

    $result =
        $conn->query(

        "SELECT

            t.*,

            u.username

         FROM tasks t

         LEFT JOIN users u

         ON t.assignedTo=u.id

         WHERE status='$key'"

        );

    while($task =
          $result->fetch_assoc())
    {
        echo "

        <div

            title='Last updated by:
                {$task['username']}'

            style='
                border:1px solid black;
                padding:10px;
                margin-bottom:10px;
            '>

            <strong>

                {$task['title']}

            </strong>

            <br>

            Assigned:

            {$task['username']}

            <br>

            Updated:

            {$task['lastUpdated']}

        </div>

        ";
    }

    echo "</div>";
}

echo "</div>";

?>
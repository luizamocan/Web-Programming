<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

include("db.php");

$result = $conn->query(
    "SELECT * FROM events"
);

?>

<!DOCTYPE html>

<html>

<head>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>
    Here are all events
</h2>

<table>

<tr>

    <th>Event title</th>

    <th>Event location</th>

    <th>Number of remaining capacity</th>

</tr>

<?php

while($row = $result->fetch_assoc())
{
    $eventId = $row['id'];

    $capacityTaken = $conn->query(
        " select count(*) as total from registrations where event_id= '$eventId'"
    );

    $count =
        $capacityTaken->fetch_assoc();

    $remaining = $row['capacity'] - $count['total'];

    echo "

    <tr>

        <td>

            {$row['title']}

        </td>

        <td>

            {$row['location']}

        </td>

        <td>

            {$remaining}

        </td>

    </tr>

    ";
}

?>

</table>

<br><br>

<a href="dashboard.php">

    Go back to the dashboard

</a>


</body>

</html>


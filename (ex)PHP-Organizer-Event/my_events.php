<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

include("db.php");

$organizerId= $_SESSION['userId'];
$result = $conn->query(
    "SELECT e.title, r.registration_date
    from events e
    join registrations r on e.id=r.event_id
    where r.organizer_id= '$organizerId' "
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
    Here are your events
</h2>

<table>

<tr>

    <th>Event title</th>


    <th>Registered date</th>

</tr>

<?php

while($row = $result->fetch_assoc())
{


    echo "

    <tr>

        <td>

            {$row['title']}

        </td>

        <td>

            {$row['registration_date']}

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


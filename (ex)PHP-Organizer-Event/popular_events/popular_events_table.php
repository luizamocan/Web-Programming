<?php

include("../db.php");

$result =
    $conn->query(

    "SELECT

        e.*,

        COUNT(r.id) AS totalRegistrations

     FROM events e

     LEFT JOIN registrations r

     ON e.id = r.event_id

     GROUP BY e.id

     ORDER BY totalRegistrations DESC

     LIMIT 3"

    );

?>

<table border="1"

       id="eventsTable">

<tr>

    <th>

        Event

    </th>

    <th>

        Location

    </th>

    <th>

        Capacity

    </th>

    <th>

        Occupied

    </th>

    <th>

        Remaining

    </th>

</tr>

<?php

while($event =
      $result->fetch_assoc())
{
    $eventId =
        $event['id'];

    $occupiedResult =
        $conn->query(

        "SELECT COUNT(*) AS total

         FROM registrations

         WHERE event_id='$eventId'"

        );

    $occupied =
        $occupiedResult
        ->fetch_assoc();

    $occupied =
        $occupied['total'];

    $remaining =
        $event['capacity']
        -
        $occupied;

?>

<tr>

    <td>

        <?= $event['title'] ?>

    </td>

    <td>

        <?= $event['location'] ?>

    </td>

    <td>

        <?= $event['capacity'] ?>

    </td>

    <td>

        <?= $occupied ?>

    </td>

    <td class="remaining">

        <?= $remaining ?>

    </td>

</tr>

<?php
}

?>

</table>
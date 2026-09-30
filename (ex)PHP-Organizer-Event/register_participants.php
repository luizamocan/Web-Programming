<?php

session_start();

include("db.php");

if(!isset($_SESSION['username']))
{
    header("Location: login/login.php");
    exit();
}

$organizerId = $_SESSION['userId'];

if(isset($_POST['events'])){
    foreach($_POST['events'] as $eventId){

        $eventResult = $conn->query("select * from events where id='$eventId'");
        $event = $eventResult ->fetch_assoc();

        $capacity = $event['capacity'];

        $occupiedResult= $conn->query(
            "select count(*) as total from registrations where event_id= '$eventId' "
        );

        $occupied = $occupiedResult ->fetch_assoc();
        $occupied = $occupied['total']; 

        $remaining = $capacity - $occupied;

        if($remaining >0){
            $conn->query("insert into registrations(organizer_id,event_id,registration_date)
                        values ('$organizerId','$eventId', NOW())
            ");
            echo "Registration done with succes!";
            echo "<br>";
        }
    }
}

if(isset($_POST['newEvents']) && $_POST['newEvents']!= ' ' ){
    $events = explode(",", $_POST['newEvents']);
    foreach($events as $eventTitle){
        $eventTitle= trim($eventTitle);

        $eventResultNew = $conn->query("select * from events where title= '$eventTitle'");

        if($eventResultNew->num_rows ==0){
            $conn ->query("insert into events(title,location,capacity) values ('$eventTitle','TBD', 50)");
            $eventId = $conn ->insert_id;
        }else{
            $event = $eventResultNew ->fetch_assoc();
            $eventId = $event['id'];
        }

        $conn -> query ("insert into registrations(organizer_id,event_id,registration_date) values ('$organizerId','$eventId', NOW())");
        echo "Registration done with succes!";
        echo "<br>";
    }
}
?>
<!DOCTYPE html>

<html>

<head>

    <title>

        Register Participant to Event

    </title>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>

    Assign Participant
    to Events

</h2>

<form method="POST">


    Existing Events:

    <br>

    <?php

    $result =
        $conn->query(
            "SELECT *
             FROM events"
        );

    while($event =
          $result->fetch_assoc())
    {
    ?>

        <input type="checkbox"

               name="events[]"

               value="<?= $event['id'] ?>">

        <?= $event['title'] ?>

        <br>

    <?php
    }
    ?>

    <br>

    New Event(separated with comma):

    <br>

    <input type="text"

           name="newEvents">

    <br><br>

    <input type="submit"

           value="Assign">

</form>

<br><br>

<a href="dashboard.php">

    Go back to the dashboard

</a>


</body>

</html>

<?php

include("db.php");

if(isset($_GET['text']))
{
    $text = $_GET['text'];

    $result =
        $conn->query(
            "SELECT *
             FROM patients
             WHERE diagnosis
             LIKE '%$text%'"
        );

    while($patients =
          $result->fetch_assoc())
    {
        echo $patients['name']. " - ". $patients['diagnosis']. "\n";
    }
}

?>

<?php

include("../db.php");

if(isset($_GET['text']))
{
    $text = $_GET['text'];

    $result =
        $conn->query(
            "SELECT *
             FROM readers
             WHERE name
             LIKE '%$text%'"
        );

    while($readers =
          $result->fetch_assoc())
    {
        echo $readers['name']. " - ". $readers['city']. "\n";
    }
}

?>

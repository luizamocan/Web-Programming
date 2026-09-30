<?php

include("db.php");

if(isset($_GET['text']))
{
    $text = $_GET['text'];

    $result =
        $conn->query(
            "SELECT *
             FROM players
             WHERE name
             LIKE '%$text%'"
        );

    while($player =
          $result->fetch_assoc())
    {
        echo
            $player['name']
            . "\n";
    }
}

?>

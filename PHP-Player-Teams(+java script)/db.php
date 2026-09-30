<?php

$conn = new mysqli(
    "localhost", 
    "root", 
    "",
    "team_players");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}    

?>
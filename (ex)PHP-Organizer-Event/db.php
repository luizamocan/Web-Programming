<?php

$conn = new mysqli(
    "localhost", 
    "root", 
    "",
    "organizer_event");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}    

?>
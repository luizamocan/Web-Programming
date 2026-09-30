<?php

$conn = new mysqli(
    "localhost", 
    "root", 
    "",
    "doctor_patients");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}    

?>
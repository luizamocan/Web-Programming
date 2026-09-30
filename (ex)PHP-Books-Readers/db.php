<?php

$conn = new mysqli(
    "localhost", 
    "root", 
    "",
    "books_readers");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}    

?>
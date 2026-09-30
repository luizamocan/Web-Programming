<?php
include("../db.php");
header("Content-Type: application/json");

$id=$_GET['id'] ;

$stmt=$conn->prepare("DELETE FROM Reservations WHERE id=?");
$stmt->bind_param("i",$id);
$stmt->execute();

echo json_encode(["success" => true, "message" => "Reservation cancelled"]);
?>
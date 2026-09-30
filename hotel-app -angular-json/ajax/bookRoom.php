<?php
include("../db.php");
header("Content-Type: application/json");

$room_id=$_POST['room_id'] ;
$name=$_POST['name'] ;
$start=$_POST['start'] ;
$end=$_POST['end'] ;

if (empty($name) || empty($start) || empty($end)) {
    die("Error: All fields are required.");
}
$stmt=$conn->prepare(
    "INSERT INTO Reservations (room_id,guest_name,start_date,end_date)
     VALUES (?,?,?,?)"
);

$stmt->bind_param("isss",$room_id,$name,$start,$end);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Booking successful"]);
} else {
    echo json_encode(["success" => false, "error" => $stmt->error]);
}
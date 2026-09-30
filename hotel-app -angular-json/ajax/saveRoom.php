<?php
header("Content-Type: application/json");
include("../db.php");
$id = $_POST['id'];
$hotel = $_POST['hotel'];
$type = $_POST['type'];
$cat = $_POST['category'];
$price = $_POST['price'];

if (!empty($id)) {
    $stmt = $conn->prepare("UPDATE rooms SET hotel_name=?, type=?, category=?, price=? WHERE id=?");
    $stmt->bind_param("sssdi", $hotel, $type, $cat, $price, $id);
    echo "Room Updated!";
} else {
    $stmt = $conn->prepare("INSERT INTO rooms (hotel_name, type, category, price) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("sssd", $hotel, $type, $cat, $price);
    echo "Room Added!";
}
$stmt->execute();
echo json_encode(["success" => true]);
?>
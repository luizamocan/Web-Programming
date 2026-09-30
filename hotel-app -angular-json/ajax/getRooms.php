<?php
header("Content-Type: application/json");
include("../db.php");

$page=$_GET['page'] ?? 0;
$category=$_GET['category'] ?? "";
$price=$_GET['price'] ?? 0;
$type=$_GET['type'] ?? "";
$hotel=$_GET['hotel'] ?? "";

$limit=4;
$offset=$page*$limit;

/*
if($category !="" && $price != "") {
    $stmt=$conn->prepare("SELECT * FROM rooms WHERE category=? AND price<=? LIMIT ? OFFSET ?");
    $stmt->bind_param("sdii",$category,$price,$limit,$offset);
}elseif ($category != "") {
    $stmt=$conn->prepare("SELECT * FROM rooms WHERE category=? LIMIT ? OFFSET ?");
    $stmt->bind_param("sii",$category,$limit,$offset);
}elseif($price != "") {
    $stmt=$conn->prepare("SELECT * FROM rooms WHERE price<=? LIMIT ? OFFSET ?");
    $stmt->bind_param("dii",$price,$limit,$offset);
}else {
    $stmt = $conn->prepare("SELECT * FROM rooms LIMIT ? OFFSET ?");
    $stmt->bind_param("ii", $limit, $offset);
}
*/
$sql=" SELECT * FROM rooms WHERE 1=1 ";
if ($hotel != "") {
    $sql .= " AND hotel_name LIKE '%$hotel%'";
}
if ($category != "") {
    $sql .= " AND category = '$category'";
}
if ($type != "") {
    $sql .= " AND type LIKE '%$type%'";
}
if ($price != "") {
    $sql .= " AND price <= " . (float)$price;
}

$sql .= " LIMIT $limit OFFSET $offset";
$result = $conn->query($sql);

$rooms = [];

while ($row = $result->fetch_assoc()) {
    $rooms[] = $row;
}

echo json_encode($rooms);

?>
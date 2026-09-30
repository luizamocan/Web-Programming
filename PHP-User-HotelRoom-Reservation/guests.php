<?php
// ── Guests controller ─────────────────────────────────────────
// Reads a date from GET, queries total guests and per-reservation
// breakdown, then renders views/guests.php.
session_start();
if (!isset($_SESSION['user_id'])) { header('Location: index.php'); exit; }

require_once 'config.php';
require_once 'functions.php';

$pdo = getDB();

$pageTitle       = 'Guest Count';
$currentPage     = 'guests.php';
$sessionUsername = $_SESSION['username'];

$date        = $_GET['date'] ?? date('Y-m-d');
$totalGuests = getTotalGuestsOnDate($pdo, $date);
$dateFormatted = date('F j, Y', strtotime($date));

// Fetch per-reservation breakdown for the chosen date
$stmt = $pdo->prepare("
    SELECT r.numberOfGuests, r.checkInDate, r.checkOutDate,
           hr.roomNumber, u.username
    FROM Reservation r
    JOIN HotelRoom hr ON r.roomId = hr.id
    JOIN User      u  ON r.userId = u.id
    WHERE r.checkInDate <= :date_in
      AND r.checkOutDate > :date_out
    ORDER BY hr.roomNumber
");
$stmt->execute([':date_in' => $date, ':date_out' => $date]);
$activeRows  = $stmt->fetchAll();
$activeCount = count($activeRows);

include 'views/guests.php';

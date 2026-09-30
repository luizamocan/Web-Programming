<?php
// ── My Reservations controller ────────────────────────────────
// Fetches all reservations for the logged-in user, pre-computes
// display fields (nights, charged/night, status), then renders
// views/my_reservations.php.
session_start();
if (!isset($_SESSION['user_id'])) { header('Location: index.php'); exit; }

require_once 'config.php';
require_once 'functions.php';

$pdo    = getDB();
$userId = (int)$_SESSION['user_id'];

$pageTitle       = 'My Reservations';
$currentPage     = 'my_reservations.php';
$sessionUsername = $_SESSION['username'];
$justReserved    = isset($_GET['reserved']);

$today = date('Y-m-d');
$raw   = getUserReservations($pdo, $userId);

// Pre-compute display-only fields so the view stays logic-free
$reservations = [];
$totalSpent   = 0;

foreach ($raw as $r) {
    $nights         = max(1, (int)((strtotime($r['checkOutDate']) - strtotime($r['checkInDate'])) / 86400));
    $chargedPerNight = (int)round($r['totalPrice'] / $nights);
    $totalSpent     += $r['totalPrice'];

    if ($r['checkOutDate'] <= $today)    { $status = 'Past';     $badge = 'badge-yellow'; }
    elseif ($r['checkInDate'] <= $today) { $status = 'Active';   $badge = 'badge-green';  }
    else                                 { $status = 'Upcoming'; $badge = '';             }

    $reservations[] = $r + [
        'nights'          => $nights,
        'chargedPerNight' => $chargedPerNight,
        'status'          => $status,
        'statusBadge'     => $badge,
    ];
}

include 'views/my_reservations.php';

<?php
// ── Search controller ─────────────────────────────────────────
// Reads the GET date range, queries available rooms and the active
// pricing multiplier, then renders views/search.php.
session_start();
if (!isset($_SESSION['user_id'])) { header('Location: index.php'); exit; }

require_once 'config.php';
require_once 'functions.php';

$pdo = getDB();

// Variables passed to the view
$pageTitle      = 'Find Available Rooms';
$currentPage    = 'search.php';
$sessionUsername = $_SESSION['username'];

$checkIn  = $_GET['check_in']  ?? '';
$checkOut = $_GET['check_out'] ?? '';
$today    = date('Y-m-d');
$tomorrow = date('Y-m-d', strtotime('+1 day'));

$error           = '';
$searched        = false;
$rooms           = [];
$multiplier      = 1.0;
$pricingLabel    = '';
$pricingBadgeClass = '';
$nights          = 0;

if ($checkIn !== '' && $checkOut !== '') {
    $searched = true;

    if ($checkIn >= $checkOut) {
        $error = 'Check-out date must be after check-in date.';
    } else {
        $nights    = (int)((strtotime($checkOut) - strtotime($checkIn)) / 86400);
        $multiplier = getDynamicMultiplier($pdo, $checkIn, $checkOut);
        $pricingLabel    = getPricingTierLabel($multiplier);
        $pricingBadgeClass = $multiplier === 1.0 ? 'badge-green'
                           : ($multiplier === 1.2 ? 'badge-yellow' : 'badge-red');

        // Add computed display fields to each room row
        $rawRooms = getAvailableRooms($pdo, $checkIn, $checkOut);
        foreach ($rawRooms as $r) {
            $r['dynamicPerNight'] = (int)round($r['basePrice'] * $multiplier);
            $r['totalForRoom']    = $r['dynamicPerNight'] * $nights;
            $rooms[] = $r;
        }
    }
}

include 'views/search.php';

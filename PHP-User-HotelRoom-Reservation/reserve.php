<?php
// ── Reserve controller ────────────────────────────────────────
// GET  → loads room data, prepares view variables, renders views/reserve.php.
// POST → validates and inserts the reservation, then redirects.
session_start();
if (!isset($_SESSION['user_id'])) { header('Location: index.php'); exit; }

require_once 'config.php';
require_once 'functions.php';

$pdo    = getDB();
$userId = (int)$_SESSION['user_id'];

$sessionUsername = $_SESSION['username'];
$currentPage     = 'reserve.php';
$pageTitle       = 'Reserve a Room';

// ── POST: process the reservation ────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $roomId   = (int)($_POST['room_id']          ?? 0);
    $checkIn  = $_POST['check_in']               ?? '';
    $checkOut = $_POST['check_out']              ?? '';
    $guests   = (int)($_POST['number_of_guests'] ?? 0);

    $error = '';

    if (!$roomId || !$checkIn || !$checkOut || $guests < 1) {
        $error = 'All fields are required.';
    } elseif ($checkIn >= $checkOut) {
        $error = 'Check-out must be after check-in.';
    } else {
        $stmt = $pdo->prepare("SELECT * FROM HotelRoom WHERE id = :id");
        $stmt->execute([':id' => $roomId]);
        $room = $stmt->fetch();

        if (!$room) {
            $error = 'Room not found.';
        } elseif ($guests > $room['capacity']) {
            $error = "Guest count exceeds room capacity ({$room['capacity']}).";
        } elseif (userHasOverlappingReservation($pdo, $userId, $roomId, $checkIn, $checkOut)) {
            $error = 'You already have a reservation for this room in that period.';
        } else {
            // Check the room wasn't grabbed by someone else since the search
            $conflict = $pdo->prepare("
                SELECT COUNT(*) FROM Reservation
                WHERE roomId = :r AND checkInDate < :co AND checkOutDate > :ci
            ");
            $conflict->execute([':r' => $roomId, ':ci' => $checkIn, ':co' => $checkOut]);

            if ((int)$conflict->fetchColumn() > 0) {
                $error = 'This room was just booked by someone else. Please go back and choose another.';
            } else {
                $multiplier = getDynamicMultiplier($pdo, $checkIn, $checkOut);
                $totalPrice = calculateTotalPrice($room['basePrice'], $multiplier, $checkIn, $checkOut);

                $insert = $pdo->prepare("
                    INSERT INTO Reservation (userId, roomId, checkInDate, checkOutDate, numberOfGuests, totalPrice)
                    VALUES (:uid, :rid, :ci, :co, :g, :p)
                ");
                $insert->execute([
                    ':uid' => $userId,
                    ':rid' => $roomId,
                    ':ci'  => $checkIn,
                    ':co'  => $checkOut,
                    ':g'   => $guests,
                    ':p'   => $totalPrice,
                ]);

                header('Location: my_reservations.php?reserved=1');
                exit;
            }
        }
    }

    // POST failed: fall through to render the form again with $error set
    $formGuests = $guests;

} else {
    // GET: prepare fresh form
    $roomId   = (int)($_GET['room_id']   ?? 0);
    $checkIn  = $_GET['check_in']        ?? '';
    $checkOut = $_GET['check_out']       ?? '';
    $error    = '';
    $formGuests = 1;

    if (!$roomId || !$checkIn || !$checkOut) {
        header('Location: search.php');
        exit;
    }
}

// Load room (needed for both GET and failed POST)
$stmt = $pdo->prepare("SELECT * FROM HotelRoom WHERE id = :id");
$stmt->execute([':id' => $roomId]);
$room = $stmt->fetch();

if (!$room) {
    header('Location: search.php');
    exit;
}

// Compute display values for the view
$nights          = max(1, (int)((strtotime($checkOut) - strtotime($checkIn)) / 86400));
$multiplier      = getDynamicMultiplier($pdo, $checkIn, $checkOut);
$pricingLabel    = getPricingTierLabel($multiplier);
$pricingBadgeClass = $multiplier === 1.0 ? 'badge-green'
                   : ($multiplier === 1.2 ? 'badge-yellow' : 'badge-red');
$dynamicPerNight = (int)round($room['basePrice'] * $multiplier);
$estimatedTotal  = $dynamicPerNight * $nights;

include 'views/reserve.php';

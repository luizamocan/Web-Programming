<?php
/**
 * Dynamic Pricing Logic
 *
 * Calculates multiplier based on occupancy rate in the given date range.
 * ≤ 50%  booked  → base price (×1.0)
 * > 50%, ≤ 80%   → base price + 20% (×1.2)
 * > 80%           → base price + 50% (×1.5)
 */
function getDynamicMultiplier(PDO $pdo, string $checkIn, string $checkOut): float {
    // Total rooms
    $totalStmt = $pdo->query("SELECT COUNT(*) as total FROM HotelRoom");
    $total = (int)$totalStmt->fetch()['total'];
    if ($total === 0) return 1.0;

    // Rooms that have at least one overlapping reservation in the given range
    $stmt = $pdo->prepare("
        SELECT COUNT(DISTINCT roomId) as booked
        FROM Reservation
        WHERE checkInDate < :checkOut
          AND checkOutDate > :checkIn
    ");
    $stmt->execute([':checkIn' => $checkIn, ':checkOut' => $checkOut]);
    $booked = (int)$stmt->fetch()['booked'];

    $occupancy = $booked / $total;

    if ($occupancy <= 0.50) {
        return 1.0;
    } elseif ($occupancy <= 0.80) {
        return 1.2;
    } else {
        return 1.5;
    }
}

/**
 * Returns the human-readable pricing tier label.
 */
function getPricingTierLabel(float $multiplier): string {
    if ($multiplier === 1.0) return 'Standard (≤50% booked)';
    if ($multiplier === 1.2) return 'Peak (51–80% booked) +20%';
    return 'High Demand (>80% booked) +50%';
}

/**
 * Calculates total price for a reservation.
 * Price is basePrice * multiplier * nights.
 */
function calculateTotalPrice(int $basePrice, float $multiplier, string $checkIn, string $checkOut): int {
    $nights = (int)((strtotime($checkOut) - strtotime($checkIn)) / 86400);
    if ($nights < 1) $nights = 1;
    return (int)round($basePrice * $multiplier * $nights);
}

/**
 * Returns available rooms (no overlapping reservation) for the given date range.
 */
function getAvailableRooms(PDO $pdo, string $checkIn, string $checkOut): array {
    $stmt = $pdo->prepare("
        SELECT hr.*
        FROM HotelRoom hr
        WHERE hr.id NOT IN (
            SELECT DISTINCT roomId
            FROM Reservation
            WHERE checkInDate < :checkOut
              AND checkOutDate > :checkIn
        )
        ORDER BY hr.roomNumber ASC
    ");
    $stmt->execute([':checkIn' => $checkIn, ':checkOut' => $checkOut]);
    return $stmt->fetchAll();
}

/**
 * Checks if the user already has a reservation overlapping with the given dates
 * for ANY room (prevent double-booking same user in same period on same room).
 */
function userHasOverlappingReservation(PDO $pdo, int $userId, int $roomId, string $checkIn, string $checkOut): bool {
    $stmt = $pdo->prepare("
        SELECT COUNT(*) as cnt
        FROM Reservation
        WHERE userId = :userId
          AND roomId = :roomId
          AND checkInDate < :checkOut
          AND checkOutDate > :checkIn
    ");
    $stmt->execute([
        ':userId'   => $userId,
        ':roomId'   => $roomId,
        ':checkIn'  => $checkIn,
        ':checkOut' => $checkOut,
    ]);
    return (int)$stmt->fetch()['cnt'] > 0;
}

/**
 * Returns total number of guests staying in the hotel on a specific date.
 * A guest is staying if their reservation period includes that day.
 */
function getTotalGuestsOnDate(PDO $pdo, string $date): int {
    $stmt = $pdo->prepare("
        SELECT COALESCE(SUM(numberOfGuests), 0) as total
        FROM Reservation
        WHERE checkInDate <= :date_in
          AND checkOutDate > :date_out
    ");
    $stmt->execute([':date_in' => $date, ':date_out' => $date]);
    return (int)$stmt->fetch()['total'];
}

/**
 * Returns all reservations for a specific user with room details.
 */
function getUserReservations(PDO $pdo, int $userId): array {
    $stmt = $pdo->prepare("
        SELECT r.*, hr.roomNumber, hr.capacity, hr.basePrice
        FROM Reservation r
        JOIN HotelRoom hr ON r.roomId = hr.id
        WHERE r.userId = :userId
        ORDER BY r.checkInDate DESC
    ");
    $stmt->execute([':userId' => $userId]);
    return $stmt->fetchAll();
}

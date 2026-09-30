<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($pageTitle ?? 'Hotel Reservations') ?></title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav>
    <span class="brand">🏨 Hotel Reservations</span>
    <a href="search.php"          class="<?= ($currentPage === 'search.php')          ? 'active' : '' ?>">Find Rooms</a>
    <a href="guests.php"          class="<?= ($currentPage === 'guests.php')          ? 'active' : '' ?>">Guest Count</a>
    <a href="my_reservations.php" class="<?= ($currentPage === 'my_reservations.php') ? 'active' : '' ?>">My Reservations</a>
    <span class="nav-user">👤 <?= htmlspecialchars($sessionUsername) ?></span>
    <a href="logout.php">Logout</a>
</nav>

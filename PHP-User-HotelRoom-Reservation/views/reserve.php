<?php include 'views/header.php'; ?>

<div class="container">
    <div class="page-title">Reserve Room <?= htmlspecialchars($room['roomNumber']) ?></div>

    <?php if ($error !== ''): ?>
        <div class="alert alert-error"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <!-- Room & price summary -->
    <div class="card">
        <h2>Reservation Summary</h2>
        <table style="width:auto;">
            <tr><th>Room</th>           <td><?= htmlspecialchars($room['roomNumber']) ?></td></tr>
            <tr><th>Capacity</th>       <td><?= $room['capacity'] ?> guests max</td></tr>
            <tr><th>Check-In</th>       <td><?= htmlspecialchars($checkIn) ?></td></tr>
            <tr><th>Check-Out</th>      <td><?= htmlspecialchars($checkOut) ?></td></tr>
            <tr><th>Nights</th>         <td><?= $nights ?></td></tr>
            <tr><th>Base Price</th>     <td>$<?= $room['basePrice'] ?> / night</td></tr>
            <tr><th>Pricing Tier</th>   <td><span class="badge <?= $pricingBadgeClass ?>"><?= htmlspecialchars($pricingLabel) ?></span></td></tr>
            <tr><th>Price / Night</th>  <td>$<?= $dynamicPerNight ?></td></tr>
            <tr><th>Estimated Total</th><td><strong>$<?= number_format($estimatedTotal) ?></strong></td></tr>
        </table>
    </div>

    <!-- Confirm form -->
    <div class="card">
        <h2>Confirm Reservation</h2>
        <form method="POST" action="reserve.php">
            <input type="hidden" name="room_id"   value="<?= $room['id'] ?>">
            <input type="hidden" name="check_in"  value="<?= htmlspecialchars($checkIn) ?>">
            <input type="hidden" name="check_out" value="<?= htmlspecialchars($checkOut) ?>">

            <div class="form-group" style="max-width:260px;">
                <label for="number_of_guests">
                    Number of Guests (max <?= $room['capacity'] ?>)
                </label>
                <input type="number" id="number_of_guests" name="number_of_guests"
                       min="1" max="<?= $room['capacity'] ?>"
                       value="<?= $formGuests ?>" required>
            </div>

            <div style="display:flex; gap:10px; margin-top:10px;">
                <button type="submit" class="btn btn-success">Confirm &amp; Book</button>
                <a class="btn btn-primary"
                   href="search.php?check_in=<?= urlencode($checkIn) ?>&check_out=<?= urlencode($checkOut) ?>">
                   ← Back to Search
                </a>
            </div>
        </form>
    </div>
</div>

<?php include 'views/footer.php'; ?>

<?php include 'views/header.php'; ?>

<div class="container">
    <div class="page-title">Hotel Guest Count</div>

    <!-- Date picker form -->
    <div class="card">
        <h2>Select a Date</h2>
        <form method="GET" action="guests.php">
            <div class="form-inline">
                <div class="form-group">
                    <label for="date">Date</label>
                    <input type="date" id="date" name="date"
                           value="<?= htmlspecialchars($date) ?>" required>
                </div>
                <div class="form-group" style="flex:0;">
                    <label>&nbsp;</label>
                    <button type="submit" class="btn btn-primary">Check</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Total guests result -->
    <div class="card" style="text-align:center; padding:30px;">
        <div style="font-size:3.5rem; font-weight:bold; color:#1e3a5f;">
            <?= $totalGuests ?>
        </div>
        <div style="font-size:1rem; color:#6b7280; margin-top:6px;">
            total guests staying on
            <strong><?= htmlspecialchars($dateFormatted) ?></strong>
        </div>
        <div style="margin-top:8px; color:#6b7280; font-size:0.85rem;">
            (<?= $activeCount ?> active reservation<?= $activeCount !== 1 ? 's' : '' ?>)
        </div>
    </div>

    <!-- Per-reservation breakdown -->
    <?php if (!empty($activeRows)): ?>
    <div class="card">
        <h2>Active Reservations on <?= htmlspecialchars($dateFormatted) ?></h2>
        <table>
            <thead>
                <tr>
                    <th>Room</th>
                    <th>User</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Guests</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($activeRows as $row): ?>
                <tr>
                    <td><?= htmlspecialchars($row['roomNumber']) ?></td>
                    <td><?= htmlspecialchars($row['username']) ?></td>
                    <td><?= htmlspecialchars($row['checkInDate']) ?></td>
                    <td><?= htmlspecialchars($row['checkOutDate']) ?></td>
                    <td><?= $row['numberOfGuests'] ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
    <?php else: ?>
        <div class="alert alert-info">No reservations found for this date.</div>
    <?php endif; ?>

</div>

<?php include 'views/footer.php'; ?>

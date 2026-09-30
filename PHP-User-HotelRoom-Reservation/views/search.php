<?php include 'views/header.php'; ?>

<div class="container">
    <div class="page-title">Find Available Rooms</div>

    <!-- Date range search form -->
    <div class="card">
        <h2>Select Date Range</h2>
        <form method="GET" action="search.php">
            <div class="form-inline">
                <div class="form-group">
                    <label for="check_in">Check-In</label>
                    <input type="date" id="check_in" name="check_in"
                           value="<?= htmlspecialchars($checkIn) ?>"
                           min="<?= $today ?>" required>
                </div>
                <div class="form-group">
                    <label for="check_out">Check-Out</label>
                    <input type="date" id="check_out" name="check_out"
                           value="<?= htmlspecialchars($checkOut) ?>"
                           min="<?= $tomorrow ?>" required>
                </div>
                <div class="form-group" style="flex:0;">
                    <label>&nbsp;</label>
                    <button type="submit" class="btn btn-primary">Search</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Results section (only shown after a search) -->
    <?php if ($searched): ?>

        <?php if ($error !== ''): ?>
            <div class="alert alert-error"><?= htmlspecialchars($error) ?></div>

        <?php elseif (empty($rooms)): ?>
            <div class="alert alert-info">No rooms available for the selected period. Try different dates.</div>

        <?php else: ?>
            <!-- Active pricing tier -->
            <div class="alert alert-info">
                <strong>Current pricing tier:</strong>
                <span class="badge <?= $pricingBadgeClass ?>"><?= htmlspecialchars($pricingLabel) ?></span>
                &nbsp;|&nbsp; <?= $nights ?> night<?= $nights !== 1 ? 's' : '' ?>
                (<?= htmlspecialchars($checkIn) ?> → <?= htmlspecialchars($checkOut) ?>)
            </div>

            <!-- Available rooms table -->
            <div class="card">
                <h2>Available Rooms (<?= count($rooms) ?>)</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Room</th>
                            <th>Capacity</th>
                            <th>Base Price / night</th>
                            <th>Price / night (now)</th>
                            <th>Total (<?= $nights ?> nights)</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($rooms as $room): ?>
                        <tr>
                            <td><strong><?= htmlspecialchars($room['roomNumber']) ?></strong></td>
                            <td><?= $room['capacity'] ?> guests</td>
                            <td>$<?= $room['basePrice'] ?></td>
                            <td>
                                $<?= $room['dynamicPerNight'] ?>
                                <?php if ($multiplier !== 1.0): ?>
                                    <span class="text-muted">(×<?= $multiplier ?>)</span>
                                <?php endif; ?>
                            </td>
                            <td><strong>$<?= number_format($room['totalForRoom']) ?></strong></td>
                            <td>
                                <a class="btn btn-success"
                                   href="reserve.php?room_id=<?= $room['id'] ?>&check_in=<?= urlencode($checkIn) ?>&check_out=<?= urlencode($checkOut) ?>">
                                   Reserve
                                </a>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    <?php endif; ?>

</div>

<?php include 'views/footer.php'; ?>

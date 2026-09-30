<?php include 'views/header.php'; ?>

<div class="container">
    <div class="page-title">My Reservations</div>

    <?php if ($justReserved): ?>
        <div class="alert alert-success">Room reserved successfully!</div>
    <?php endif; ?>

    <?php if (empty($reservations)): ?>
        <div class="alert alert-info">
            You have no reservations yet.
            <a href="search.php">Find a room to book →</a>
        </div>

    <?php else: ?>
        <div class="card">
            <h2>All Reservations (<?= count($reservations) ?>)</h2>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Room</th>
                        <th>Check-In</th>
                        <th>Check-Out</th>
                        <th>Nights</th>
                        <th>Guests</th>
                        <th>Base / Night</th>
                        <th>Charged / Night</th>
                        <th>Total Paid</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($reservations as $i => $r): ?>
                    <tr>
                        <td><?= $i + 1 ?></td>
                        <td><strong><?= htmlspecialchars($r['roomNumber']) ?></strong></td>
                        <td><?= htmlspecialchars($r['checkInDate']) ?></td>
                        <td><?= htmlspecialchars($r['checkOutDate']) ?></td>
                        <td><?= $r['nights'] ?></td>
                        <td><?= $r['numberOfGuests'] ?></td>
                        <td>$<?= $r['basePrice'] ?></td>
                        <td>$<?= $r['chargedPerNight'] ?></td>
                        <td><strong>$<?= number_format($r['totalPrice']) ?></strong></td>
                        <td><span class="badge <?= $r['statusBadge'] ?>"><?= $r['status'] ?></span></td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
            <p class="text-muted mt-10">
                Total spent: <strong>$<?= number_format($totalSpent) ?></strong>
            </p>
        </div>
    <?php endif; ?>

</div>

<?php include 'views/footer.php'; ?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Hotel Reservations</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="login-wrapper">
    <div class="login-box">
        <h1>🏨 Hotel Reservations</h1>
        <p class="subtitle">Sign in to manage your bookings</p>

        <?php if ($error !== ''): ?>
            <div class="alert alert-error"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <form method="POST" action="index.php">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username"
                       value="<?= htmlspecialchars($formUsername) ?>"
                       placeholder="e.g. admin" required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Your password" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width:100%; padding:10px;">
                Sign In
            </button>
        </form>

        <p class="text-muted mt-10">
            Demo: <strong>admin / admin123</strong> &nbsp;|&nbsp;
            john / john123 &nbsp;|&nbsp; jane / jane123
        </p>
    </div>
</div>

</body>
</html>

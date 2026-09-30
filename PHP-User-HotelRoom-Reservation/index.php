<?php
// ── Login controller ──────────────────────────────────────────
// Handles authentication. On success: redirects to search.php.
// On failure or GET: sets variables and renders views/login.php.
session_start();

if (isset($_SESSION['user_id'])) {
    header('Location: search.php');
    exit;
}

require_once 'config.php';

$error       = '';
$formUsername = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $formUsername = trim($_POST['username'] ?? '');
    $password     = $_POST['password'] ?? '';

    if ($formUsername === '' || $password === '') {
        $error = 'Please enter both username and password.';
    } else {
        $pdo  = getDB();
        $stmt = $pdo->prepare("SELECT id, username, password FROM User WHERE username = :u");
        $stmt->execute([':u' => $formUsername]);
        $user = $stmt->fetch();

        if ($user && $user['password'] === md5($password)) {
            $_SESSION['user_id']  = $user['id'];
            $_SESSION['username'] = $user['username'];
            header('Location: search.php');
            exit;
        }

        $error = 'Invalid username or password.';
    }
}

include 'views/login.php';

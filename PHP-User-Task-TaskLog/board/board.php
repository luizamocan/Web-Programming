<?php

session_start();

if(!isset($_SESSION['username']))
{
    header("Location: ../login/login.php");
    exit();
}

include("../db.php");

include("board_form.php");

?>

<br><br>

<a href="../dashboard.php">
    Back to dashboard
</a>

<script src="realtime.js"></script>

</body>

</html>
<?php

session_start();
include "db.php";


if(isset($_POST['name'])){
    $name = $_POST['name'];

    $sql="SELECT * from students where name='$name'";
    $result = $conn->query($sql);

    $user=$result->fetch_assoc();

    if($user){
       
        $_SESSION['userId'] = $user['id'];
        $_SESSION['name'] = $user['name'];

        header("Location: dashboard.php");
        exit();
    } 
    else{
        echo "User not found";
    }

   

}

?>
<!DOCTYPE html>

<html>

<head>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>
    Login
</h2>

<form method="POST">

    Name:

    <input type="text"
           name="name"
           required>

    <input type="submit"
           value="Continue">

</form>

</body>
</html>
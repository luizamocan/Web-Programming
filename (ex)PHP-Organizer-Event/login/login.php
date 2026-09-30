<?php

session_start();
include ("../db.php");


if(isset($_POST['username'])){
    $username = $_POST['username'];

    $sql="SELECT * from organizers where username='$username'";
    $result = $conn->query($sql);

    $user=$result->fetch_assoc();

    if($user){
       
        $_SESSION['userId'] = $user['id'];
        $_SESSION['username'] = $user['username'];

        header("Location: ../dashboard.php");
        exit();
    } 
    else{
        echo "User not found";
    }

   

}

include ("login_form.php");
?>
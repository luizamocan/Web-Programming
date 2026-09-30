<?php

session_start();
include ("../db.php");


if(isset($_POST['name'])){
    $name = $_POST['name'];

    $sql="SELECT * from readers where name='$name'";
    $result = $conn->query($sql);

    $user=$result->fetch_assoc();

    if($user){
       
        $_SESSION['userId'] = $user['id'];
        $_SESSION['name'] = $user['name'];

        header("Location: ../dashboard.php");
        exit();
    } 
    else{
        echo "User not found";
    }

   

}

include ("login_form.php");
?>
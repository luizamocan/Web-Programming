<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

include("db.php");

$result = $conn->query(
    "SELECT  p.name, p.diagnosis
    FROM patients p
    INNER JOIN appointments a ON p.id = a.patient_id
    WHERE a.doctor_id = '$_SESSION[userId]'"
);

?>

<!DOCTYPE html>

<html>

<head>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>
    Here are your patients
</h2>

<table>

<tr>

    <th>Patient Name</th>

    <th>Patient Diagnosis</th>

</tr>

<?php

while($row = $result->fetch_assoc())
{
    

    echo "

    <tr>

        <td>

            {$row['name']}

        </td>

        <td>

            {$row['diagnosis']}

        </td>

    </tr>

    ";
}

?>

</table>

<br><br>

<a href="dashboard.php">

    Go back to the dashboard

</a>


</body>

</html>


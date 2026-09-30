<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

include("db.php");

$result = $conn->query(
    "SELECT * FROM doctors"
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
    Here are all doctors
</h2>

<table>

<tr>

    <th>Doctor Name</th>

    <th>Doctor Specialization</th>

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

            {$row['specialization']}

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


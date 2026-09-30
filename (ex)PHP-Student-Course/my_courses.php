<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

include("db.php");

$result = $conn->query(
    "SELECT  c.name, c.professor
    FROM courses c
    INNER JOIN enrollments e ON c.id = e.course_id
    WHERE e.student_id = '$_SESSION[userId]'"
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
    Here are your courses
</h2>

<table>

<tr>

    <th>Course Name</th>

    <th>Professor Name</th>

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

            {$row['professor']}

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


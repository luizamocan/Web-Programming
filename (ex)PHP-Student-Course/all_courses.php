<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

include("db.php");

$result = $conn->query(
    "SELECT * FROM courses"
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
    Here are all courses
</h2>

<table>

<tr>

    <th>Course Name</th>

    <th>Number of Students enrolled</th>

</tr>

<?php

while($row = $result->fetch_assoc())
{
    $courseId = $row['id'];

    $studentsResult = $conn->query(
        "SELECT COUNT(*) AS total
         FROM enrollments
         WHERE course_id='$courseId'"
    );

    $count =
        $studentsResult->fetch_assoc();

    echo "

    <tr>

        <td>

            {$row['name']}

        </td>

        <td>

            {$count['total']}

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


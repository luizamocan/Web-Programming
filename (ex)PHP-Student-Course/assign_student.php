<?php

session_start();

include("db.php");

if(!isset($_SESSION['name']))
{
    header("Location: login.php");
    exit();
}

if(isset($_POST['studentName']))
{
    $studentName = $_POST['studentName'];

    $studentResult = $conn->query(
        "SELECT *
         FROM students
         WHERE name='$studentName'"
    );

    if($studentResult->num_rows == 0)
    {
        echo "Student does not exist.";
    }
    else
    {
        $student =
            $studentResult->fetch_assoc();

        $studentId =
            $student['id'];

        /*
        |---------------------------------------
        | Existing courses
        |---------------------------------------
        */

        if(isset($_POST['courses']))
        {
            foreach($_POST['courses']
                    as $courseName)
            {
                $courseResult = $conn->query(
                    "SELECT *
                     FROM courses
                     WHERE name='$courseName'"
                );

                if($courseResult->num_rows > 0)
                {
                    $course =
                        $courseResult
                        ->fetch_assoc();

                    $courseId =
                        $course['id'];

                    /*
                    |---------------------------------------
                    | Avoid duplicates
                    |---------------------------------------
                    */

                    $exists =
                        $conn->query(

                        "SELECT *
                         FROM enrollments
                         WHERE student_id='$studentId'
                         AND course_id='$courseId'"

                        );

                    if($exists->num_rows == 0)
                    {
                        $conn->query(

                        "INSERT INTO enrollments(

                            student_id,

                            course_id

                        )

                        VALUES(

                            '$studentId',

                            '$courseId'

                        )"

                        );
                    }
                }
            }
        }

        /*
        |---------------------------------------
        | New courses
        |---------------------------------------
        */

        if(isset($_POST['newCourses'])
           &&
           $_POST['newCourses'] != '')
        {
            $newCourses =
                explode(
                    ",",
                    $_POST['newCourses']
                );

            foreach($newCourses
                    as $courseName)
            {
                $courseName =
                    trim($courseName);

                $courseResult =
                    $conn->query(

                    "SELECT *
                     FROM courses
                     WHERE name='$courseName'"

                    );

                if($courseResult->num_rows == 0)
                {
                    $conn->query(

                    "INSERT INTO courses(

                        name,

                        professor

                    )

                    VALUES(

                        '$courseName',

                        ''

                    )"

                    );

                    $courseId =
                        $conn->insert_id;
                }
                else
                {
                    $course =
                        $courseResult
                        ->fetch_assoc();

                    $courseId =
                        $course['id'];
                }

                $exists =
                    $conn->query(

                    "SELECT *
                     FROM enrollments
                     WHERE student_id='$studentId'
                     AND course_id='$courseId'"

                    );

                if($exists->num_rows == 0)
                {
                    $conn->query(

                    "INSERT INTO enrollments(

                        student_id,

                        course_id

                    )

                    VALUES(

                        '$studentId',

                        '$courseId'

                    )"

                    );
                }
            }
        }

        echo
        "Student assigned successfully.";
    }
}

?>

<!DOCTYPE html>

<html>

<head>

    <title>

        Assign Student

    </title>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>

    Assign Student
    to Courses

</h2>

<form method="POST">

    Student Name:

    <input type="text"
           name="studentName"
           required>

    <br><br>

    Existing Courses:

    <br>

    <?php

    $result =
        $conn->query(
            "SELECT *
             FROM courses"
        );

    while($course =
          $result->fetch_assoc())
    {
    ?>

        <input type="checkbox"

               name="courses[]"

               value="<?= $course['name'] ?>">

        <?= $course['name'] ?>

        <br>

    <?php
    }
    ?>

    <br>

    New Courses
    (comma separated):

    <br>

    <input type="text"

           name="newCourses">

    <br><br>

    <input type="submit"

           value="Assign">

</form>

<br><br>

<a href="dashboard.php">

    Go back to the dashboard

</a>


</body>

</html>

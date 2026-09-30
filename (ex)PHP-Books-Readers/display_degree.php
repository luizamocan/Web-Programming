<?php

session_start();

include("db.php");
include ("display_degree_form.php");

if(!isset($_SESSION['userId']))
{
    header("Location: login/login.php");
    exit();
}

//echo "Logged user ID: " . $_SESSION['userId'] . "<br>";

$currentReaderId =
    $_SESSION['userId'];

$currentReader =
    $conn->query(
        "SELECT *
         FROM readers
         WHERE id='$currentReaderId'"
    )->fetch_assoc();

$currentCity =
    $currentReader['city'];



if(isset($_POST['degree']))
{
    $degree =
        $_POST['degree'];

    $visited = [];

    $currentLevel =
        [$currentReaderId];

    for($level = 1;
        $level <= $degree;
        $level++)
    {
        $nextLevel = [];

        foreach($currentLevel
                as $readerId)
        {
            $result =
                $conn->query(

                "SELECT *

                 FROM friendships

                 WHERE

                 reader1_id='$readerId'

                 OR

                 reader2_id='$readerId'"

                );

            while($relation =
                  $result->fetch_assoc())
            {
                if(
                    $relation['reader1_id']
                    ==
                    $readerId
                  )
                {
                    $otherReader =
                        $relation[
                            'reader2_id'
                        ];
                }
                else
                {
                    $otherReader =
                        $relation[
                            'reader1_id'
                        ];
                }

                if(
                    !in_array(
                        $otherReader,
                        $visited
                    )

                    &&

                    $otherReader
                    !=
                    $currentReaderId
                  )
                {
                    $visited[] =
                        $otherReader;

                    $nextLevel[] =
                        $otherReader;
                }
            }
        }

        $currentLevel =
            $nextLevel;
    }

    echo "<h3>

          Degree "
          . $degree
          . " friendships:

          </h3>";

    foreach($currentLevel
            as $readerId)
    {
        $reader =
            $conn->query(

            "SELECT *

             FROM readers

             WHERE id='$readerId'"

            )->fetch_assoc();

        if(
            isset(
                $_POST[
                    'sameCity'
                ]
            )

            &&

            $reader['city']
            !=
            $currentCity
          )
        {
            continue;
        }

        echo

            $reader['name']

            . " ("

            . $reader['city']

            . ")<br>";
    }
}


?>

<br><br>

<a href="dashboard.php">

    Back to dashboard

</a>

</body>

</html>

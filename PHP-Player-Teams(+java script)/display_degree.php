<?php

session_start();

include("db.php");

if(!isset($_SESSION['userId']))
{
    header("Location: login.php");
    exit();
}

$currentPlayerId =
    $_SESSION['userId'];

$currentPlayer =
    $conn->query(
        "SELECT *
         FROM players
         WHERE id='$currentPlayerId'"
    )->fetch_assoc();

$currentPosition =
    $currentPlayer['position'];

?>

<!DOCTYPE html>

<html>

<head>

    <title>

        Degree Relations

    </title>

    <link rel="stylesheet"
          href="style.css">

</head>

<body>

<h2>

    Display N-th Degree Relations

</h2>

<form method="POST">

    Degree:

    <select name="degree">

        <option value="1">

            1

        </option>

        <option value="2">

            2

        </option>

        <option value="3">

            3

        </option>

    </select>

    <br><br>

    Same position only:

    <input type="checkbox"

           name="samePosition">

    <br><br>

    <input type="submit"

           value="Display">

</form>

<?php

if(isset($_POST['degree']))
{
    $degree =
        $_POST['degree'];

    $visited = [];

    $currentLevel =
        [$currentPlayerId];

    for($level = 1;
        $level <= $degree;
        $level++)
    {
        $nextLevel = [];

        foreach($currentLevel
                as $playerId)
        {
            $result =
                $conn->query(

                "SELECT *

                 FROM team_members

                 WHERE

                 id_player1='$playerId'

                 OR

                 id_player2='$playerId'"

                );

            while($relation =
                  $result->fetch_assoc())
            {
                if(
                    $relation['id_player1']
                    ==
                    $playerId
                  )
                {
                    $otherPlayer =
                        $relation[
                            'id_player2'
                        ];
                }
                else
                {
                    $otherPlayer =
                        $relation[
                            'id_player1'
                        ];
                }

                if(
                    !in_array(
                        $otherPlayer,
                        $visited
                    )

                    &&

                    $otherPlayer
                    !=
                    $currentPlayerId
                  )
                {
                    $visited[] =
                        $otherPlayer;

                    $nextLevel[] =
                        $otherPlayer;
                }
            }
        }

        $currentLevel =
            $nextLevel;
    }

    echo "<h3>

          Degree "
          . $degree
          . " teammates:

          </h3>";

    foreach($currentLevel
            as $playerId)
    {
        $player =
            $conn->query(

            "SELECT *

             FROM players

             WHERE id='$playerId'"

            )->fetch_assoc();

        if(
            isset(
                $_POST[
                    'samePosition'
                ]
            )

            &&

            $player['position']
            !=
            $currentPosition
          )
        {
            continue;
        }

        echo

            $player['name']

            . " ("

            . $player['position']

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

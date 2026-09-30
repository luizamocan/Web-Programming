CREATE DATABASE team_players;

USE team_players;

CREATE TABLE players(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    position VARCHAR(255)
);

CREATE TABLE teams(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    homecity VARCHAR(255)
);

CREATE TABLE team_members(
    id INT PRIMARY KEY AUTO_INCREMENT,

    id_player1 INT,

    id_player2 INT,

    team_id INT,

    FOREIGN KEY(id_player1)
        REFERENCES players(id),

    FOREIGN KEY(id_player2)
        REFERENCES players(id),

    FOREIGN KEY(team_id)
        REFERENCES teams(id)
);

INSERT INTO players(name, position)
VALUES
('alex', 'goalkeeper'),
('ana', 'goalkeeper'),
('andra', 'defender'),
('luiza', 'defender'),
('raluca', 'goalkeeper'),
('andreea', 'striker');

INSERT INTO teams(name, homecity)
VALUES
('team1', 'cluj'),
('team2', 'bucuresti');

INSERT INTO team_members(
    id_player1,
    id_player2,
    team_id
)
VALUES

(1,2,1),   -- alex ana
(1,3,1),   -- alex andra
(2,4,1),   -- ana luiza

(4,5,2),   -- luiza raluca
(5,6,2);   -- raluca andreea
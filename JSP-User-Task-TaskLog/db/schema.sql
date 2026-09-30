CREATE DATABASE IF NOT EXISTS taskdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE taskdb;

CREATE TABLE IF NOT EXISTS User (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Task (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    status      ENUM('todo', 'in_progress', 'done') NOT NULL DEFAULT 'todo',
    assignedTo  INT,
    lastUpdated DATETIME,
    FOREIGN KEY (assignedTo) REFERENCES User(id)
);

CREATE TABLE IF NOT EXISTS TaskLog (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    taskId    INT NOT NULL,
    userId    INT NOT NULL,
    oldStatus VARCHAR(50) NOT NULL,
    newStatus VARCHAR(50) NOT NULL,
    timestamp DATETIME NOT NULL,
    FOREIGN KEY (taskId) REFERENCES Task(id),
    FOREIGN KEY (userId) REFERENCES User(id)
);

INSERT INTO User (username) VALUES
    ('alice'),
    ('bob'),
    ('charlie')
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO Task (title, status, assignedTo, lastUpdated) VALUES
    ('Design UI mockups',        'todo',        NULL, NOW()),
    ('Write unit tests',         'todo',        NULL, NOW()),
    ('Set up CI pipeline',       'todo',        NULL, NOW()),
    ('Fix login bug',            'in_progress', 1,    NOW()),
    ('Implement search feature', 'in_progress', 2,    NOW()),
    ('Code review PR #42',       'done',        1,    NOW()),
    ('Update documentation',     'done',        3,    NOW())
ON DUPLICATE KEY UPDATE id = id;

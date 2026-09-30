CREATE DATABASE task_manager;

USE task_manager;

CREATE TABLE users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255)
);

CREATE TABLE tasks(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    status ENUM(
        'todo',
        'in_progress',
        'done'
    ),
    assignedTo INT,
    lastUpdated DATETIME,
    FOREIGN KEY(assignedTo) REFERENCES users(id)
);

CREATE TABLE tasklog(
    id INT PRIMARY KEY AUTO_INCREMENT,
    taskId INT,
    userId INT,
    oldStatus VARCHAR(255),
    newStatus VARCHAR(255),
    timestamp DATETIME,
    FOREIGN KEY(taskId) REFERENCES tasks(id),
    FOREIGN KEY(userId) REFERENCES users(id)
);

INSERT INTO users(username)
VALUES
('alex'),
('ana'),
('luiza'),
('vlad');

INSERT INTO tasks(
    title,
    status,
    assignedTo,
    lastUpdated
)
VALUES
(
    'Write report',
    'todo',
    1,
    NOW()
),
(
    'Fix login bug',
    'todo',
    2,
    NOW()
),
(
    'Implement dashboard',
    'in_progress',
    1,
    NOW()
),
(
    'Test application',
    'in_progress',
    3,
    NOW()
),
(
    'Deploy project',
    'done',
    4,
    NOW()
),
(
    'Create documentation',
    'done',
    2,
    NOW()
);

INSERT INTO tasklog(
    taskId,
    userId,
    oldStatus,
    newStatus,
    timestamp
)
VALUES
(
    3,
    1,
    'todo',
    'in_progress',
    NOW()
),
(
    4,
    3,
    'todo',
    'in_progress',
    NOW()
),
(
    5,
    4,
    'in_progress',
    'done',
    NOW()
),
(
    6,
    2,
    'in_progress',
    'done',
    NOW()
);

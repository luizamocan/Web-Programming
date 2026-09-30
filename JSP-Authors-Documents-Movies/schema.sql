-- Create and use the database
CREATE DATABASE IF NOT EXISTS authors_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE authors_db;

-- ─── Tables ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS Documents (
    id       INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    contents TEXT         NOT NULL
);

CREATE TABLE IF NOT EXISTS Movies (
    id       INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title    VARCHAR(255) NOT NULL,
    duration INT          NOT NULL   -- duration in minutes
);

CREATE TABLE IF NOT EXISTS Authors (
    id           INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    documentList VARCHAR(500) DEFAULT '',   -- comma-separated Document IDs
    movieList    VARCHAR(500) DEFAULT ''    -- comma-separated Movie IDs
);

-- ─── Sample data ──────────────────────────────────────────────────────────────

INSERT INTO Documents (id, name, contents) VALUES
(1, 'Introduction to Java',   'Java is a class-based, object-oriented language.'),
(2, 'JSP Fundamentals',       'JavaServer Pages allow embedding Java in HTML.'),
(3, 'Database Design Basics', 'Relational databases organise data in tables.');

INSERT INTO Movies (id, title, duration) VALUES
(1, 'The Matrix',       136),
(2, 'Inception',        148),
(3, 'Interstellar',     169);

INSERT INTO Authors (id, name, documentList, movieList) VALUES
(1, 'Alice', '1,2', '1,2'),
(2, 'Bob',   '2,3', '2,3'),
(3, 'Carol', '1,3', '1,3');

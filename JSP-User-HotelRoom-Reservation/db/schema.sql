-- ============================================================
-- Hotel Dynamic Price Reservation - Database Schema
-- Run this script in MySQL before deploying the application
-- ============================================================

CREATE DATABASE IF NOT EXISTS hotel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_db;

-- -------------------------------------------------------
-- Table: User
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS User (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password INT          NOT NULL
);

-- -------------------------------------------------------
-- Table: HotelRoom
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS HotelRoom (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    roomNumber VARCHAR(20) NOT NULL UNIQUE,
    capacity   INT         NOT NULL,
    basePrice  INT         NOT NULL
);

-- -------------------------------------------------------
-- Table: Reservation
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS Reservation (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    userId         INT  NOT NULL,
    roomId         INT  NOT NULL,
    checkInDate    DATE NOT NULL,
    checkOutDate   DATE NOT NULL,
    numberOfGuests INT  NOT NULL,
    totalPrice     INT  NOT NULL,
    FOREIGN KEY (userId) REFERENCES User(id),
    FOREIGN KEY (roomId) REFERENCES HotelRoom(id)
);

-- -------------------------------------------------------
-- Sample Data: Users  (passwords stored as ints per spec)
-- user: admin  password: 1234
-- user: alice  password: 5678
-- user: bob    password: 9999
-- -------------------------------------------------------
INSERT INTO User (username, password) VALUES
    ('admin', 1234),
    ('alice', 5678),
    ('bob',   9999)
ON DUPLICATE KEY UPDATE id = id;

-- -------------------------------------------------------
-- Sample Data: Hotel Rooms (10 rooms total)
-- -------------------------------------------------------
INSERT INTO HotelRoom (roomNumber, capacity, basePrice) VALUES
    ('101', 1, 100),
    ('102', 2, 150),
    ('103', 2, 150),
    ('104', 3, 200),
    ('105', 3, 200),
    ('201', 2, 180),
    ('202', 4, 280),
    ('203', 1, 120),
    ('301', 2, 220),
    ('302', 4, 350)
ON DUPLICATE KEY UPDATE id = id;

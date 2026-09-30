-- Hotel Reservation System Database Schema
-- Run this in phpMyAdmin or MySQL CLI

CREATE DATABASE IF NOT EXISTS hotel_reservation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_reservation;

-- Users table
CREATE TABLE IF NOT EXISTS User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- Hotel Rooms table
CREATE TABLE IF NOT EXISTS HotelRoom (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roomNumber VARCHAR(20) NOT NULL UNIQUE,
    capacity INT NOT NULL,
    basePrice INT NOT NULL
);

-- Reservations table
CREATE TABLE IF NOT EXISTS Reservation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    roomId INT NOT NULL,
    checkInDate DATE NOT NULL,
    checkOutDate DATE NOT NULL,
    numberOfGuests INT NOT NULL,
    totalPrice INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (roomId) REFERENCES HotelRoom(id) ON DELETE CASCADE
);

-- Seed some users (passwords are md5 hashed; admin/admin123, john/john123, jane/jane123)
INSERT INTO User (username, password) VALUES
('admin', MD5('admin123')),
('john',  MD5('john123')),
('jane',  MD5('jane123'));

-- Seed hotel rooms
INSERT INTO HotelRoom (roomNumber, capacity, basePrice) VALUES
('101', 2, 100),
('102', 2, 100),
('103', 3, 130),
('104', 3, 130),
('105', 4, 160),
('201', 2, 120),
('202', 2, 120),
('203', 3, 150),
('204', 4, 180),
('205', 4, 180),
('301', 2, 140),
('302', 2, 140),
('303', 3, 170),
('304', 4, 200),
('305', 5, 250);

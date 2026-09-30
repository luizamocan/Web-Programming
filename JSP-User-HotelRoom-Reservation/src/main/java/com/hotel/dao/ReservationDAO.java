package com.hotel.dao;

import com.hotel.model.Reservation;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // -----------------------------------------------------------------------
    // Pricing Logic
    // -----------------------------------------------------------------------

    /**
     * Counts how many rooms are already booked (have at least one reservation)
     * that overlaps with [checkIn, checkOut).
     */
    public int countBookedRoomsForPeriod(Date checkIn, Date checkOut) {
        String sql = "SELECT COUNT(DISTINCT roomId) FROM Reservation " +
                     "WHERE checkInDate < ? AND checkOutDate > ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, checkOut);
            ps.setDate(2, checkIn);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Calculates the dynamic price for a room given the current occupancy.
     *
     * Rules:
     *   occupancy <= 50% -> basePrice
     *   50% < occupancy <= 80% -> basePrice * 1.20
     *   occupancy > 80%  -> basePrice * 1.50
     */
    public int calculatePrice(int basePrice, Date checkIn, Date checkOut) {
        HotelRoomDAO roomDAO = new HotelRoomDAO();
        int total  = roomDAO.getTotalRoomCount();
        int booked = countBookedRoomsForPeriod(checkIn, checkOut);

        if (total == 0) return basePrice;

        double occupancy = (double) booked / total;

        if (occupancy <= 0.50) {
            return basePrice;
        } else if (occupancy <= 0.80) {
            return (int) Math.round(basePrice * 1.20);
        } else {
            return (int) Math.round(basePrice * 1.50);
        }
    }

    // -----------------------------------------------------------------------
    // Overlap check (same user)
    // -----------------------------------------------------------------------

    /**
     * Returns true if the given user already has a reservation for ANY room
     * that overlaps with [checkIn, checkOut).
     * "Prevent overlapping reservations for same user."
     */
    public boolean userHasOverlap(int userId, Date checkIn, Date checkOut) {
        String sql = "SELECT COUNT(*) FROM Reservation " +
                     "WHERE userId = ? AND checkInDate < ? AND checkOutDate > ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, checkOut);
            ps.setDate(3, checkIn);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // -----------------------------------------------------------------------
    // Create reservation
    // -----------------------------------------------------------------------

    /**
     * Inserts a new reservation. Returns the generated id, or -1 on failure.
     */
    public int createReservation(int userId, int roomId, Date checkIn, Date checkOut,
                                  int numberOfGuests, int totalPrice) {
        String sql = "INSERT INTO Reservation (userId, roomId, checkInDate, checkOutDate, " +
                     "numberOfGuests, totalPrice) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setInt(2, roomId);
            ps.setDate(3, checkIn);
            ps.setDate(4, checkOut);
            ps.setInt(5, numberOfGuests);
            ps.setInt(6, totalPrice);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // -----------------------------------------------------------------------
    // User's reservations
    // -----------------------------------------------------------------------

    /**
     * Returns all reservations for a given user, joined with HotelRoom info.
     */
    public List<Reservation> getReservationsByUser(int userId) {
        String sql = "SELECT r.id, r.userId, r.roomId, r.checkInDate, r.checkOutDate, " +
                     "       r.numberOfGuests, r.totalPrice, " +
                     "       hr.roomNumber, hr.basePrice " +
                     "FROM Reservation r " +
                     "JOIN HotelRoom hr ON r.roomId = hr.id " +
                     "WHERE r.userId = ? " +
                     "ORDER BY r.checkInDate DESC";
        List<Reservation> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation res = new Reservation();
                    res.setId(rs.getInt("id"));
                    res.setUserId(rs.getInt("userId"));
                    res.setRoomId(rs.getInt("roomId"));
                    res.setCheckInDate(rs.getDate("checkInDate"));
                    res.setCheckOutDate(rs.getDate("checkOutDate"));
                    res.setNumberOfGuests(rs.getInt("numberOfGuests"));
                    res.setTotalPrice(rs.getInt("totalPrice"));
                    res.setRoomNumber(rs.getString("roomNumber"));
                    res.setBasePrice(rs.getInt("basePrice"));
                    list.add(res);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // -----------------------------------------------------------------------
    // Total guests on a specific date
    // -----------------------------------------------------------------------

    /**
     * Returns the sum of numberOfGuests for all reservations where the
     * given date falls within [checkInDate, checkOutDate).
     */
    public int getTotalGuestsOnDate(Date date) {
        String sql = "SELECT COALESCE(SUM(numberOfGuests), 0) FROM Reservation " +
                     "WHERE checkInDate <= ? AND checkOutDate > ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

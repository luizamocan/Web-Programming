package com.hotel.dao;

import com.hotel.model.HotelRoom;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HotelRoomDAO {

    /** Total number of rooms in the hotel. */
    public int getTotalRoomCount() {
        String sql = "SELECT COUNT(*) FROM HotelRoom";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Returns rooms that have NO overlapping reservation in [checkIn, checkOut).
     * Overlap condition: existing.checkInDate < checkOut AND existing.checkOutDate > checkIn
     */
    public List<HotelRoom> getAvailableRooms(Date checkIn, Date checkOut) {
        String sql = "SELECT id, roomNumber, capacity, basePrice FROM HotelRoom " +
                     "WHERE id NOT IN (" +
                     "  SELECT roomId FROM Reservation " +
                     "  WHERE checkInDate < ? AND checkOutDate > ?" +
                     ")";
        List<HotelRoom> rooms = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, checkOut);
            ps.setDate(2, checkIn);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rooms.add(new HotelRoom(
                            rs.getInt("id"),
                            rs.getString("roomNumber"),
                            rs.getInt("capacity"),
                            rs.getInt("basePrice")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    /** Find a single room by its id. */
    public HotelRoom findById(int id) {
        String sql = "SELECT id, roomNumber, capacity, basePrice FROM HotelRoom WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new HotelRoom(
                            rs.getInt("id"),
                            rs.getString("roomNumber"),
                            rs.getInt("capacity"),
                            rs.getInt("basePrice")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

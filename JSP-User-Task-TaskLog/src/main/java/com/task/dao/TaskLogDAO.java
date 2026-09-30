package com.task.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class TaskLogDAO {

    public void insertLog(int taskId, int userId, String oldStatus, String newStatus) {
        String sql = "INSERT INTO TaskLog (taskId, userId, oldStatus, newStatus, timestamp) " +
                     "VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ps.setInt(2, userId);
            ps.setString(3, oldStatus);
            ps.setString(4, newStatus);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

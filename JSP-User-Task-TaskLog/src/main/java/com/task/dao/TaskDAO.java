package com.task.dao;

import com.task.model.Task;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {

    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.id, t.title, t.status, t.assignedTo, t.lastUpdated, u.username " +
                     "FROM Task t LEFT JOIN User u ON t.assignedTo = u.id " +
                     "ORDER BY t.id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Task task = new Task();
                task.setId(rs.getInt("id"));
                task.setTitle(rs.getString("title"));
                task.setStatus(rs.getString("status"));
                task.setAssignedTo(rs.getInt("assignedTo"));
                task.setAssignedToUsername(rs.getString("username"));
                task.setLastUpdated(rs.getTimestamp("lastUpdated"));
                tasks.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    public Task getTaskById(int taskId) {
        String sql = "SELECT t.id, t.title, t.status, t.assignedTo, t.lastUpdated, u.username " +
                     "FROM Task t LEFT JOIN User u ON t.assignedTo = u.id " +
                     "WHERE t.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Task task = new Task();
                    task.setId(rs.getInt("id"));
                    task.setTitle(rs.getString("title"));
                    task.setStatus(rs.getString("status"));
                    task.setAssignedTo(rs.getInt("assignedTo"));
                    task.setAssignedToUsername(rs.getString("username"));
                    task.setLastUpdated(rs.getTimestamp("lastUpdated"));
                    return task;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTaskStatus(int taskId, String newStatus, int userId) {
        String sql = "UPDATE Task SET status = ?, assignedTo = ?, lastUpdated = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, userId);
            ps.setInt(3, taskId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

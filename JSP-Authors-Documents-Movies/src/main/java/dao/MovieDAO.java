package dao;

import model.Movie;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

    /** Fetch a single movie by its primary key. */
    public Movie findById(int id) throws Exception {
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM Movies WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        Movie movie = null;
        if (rs.next()) {
            movie = new Movie(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getInt("duration"));
        }
        conn.close();
        return movie;
    }

    /** Fetch a single movie by title (case-insensitive). */
    public Movie findByTitle(String title) throws Exception {
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM Movies WHERE LOWER(title) = LOWER(?)");
        ps.setString(1, title);
        ResultSet rs = ps.executeQuery();
        Movie movie = null;
        if (rs.next()) {
            movie = new Movie(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getInt("duration"));
        }
        conn.close();
        return movie;
    }

    /** Fetch multiple movies whose IDs are in the provided list. */
    public List<Movie> findByIds(List<Integer> ids) throws Exception {
        List<Movie> list = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return list;

        Connection conn = DBUtil.getConnection();
        StringBuilder sb = new StringBuilder(
                "SELECT * FROM Movies WHERE id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sb.append(i == 0 ? "?" : ",?");
        }
        sb.append(")");

        PreparedStatement ps = conn.prepareStatement(sb.toString());
        for (int i = 0; i < ids.size(); i++) {
            ps.setInt(i + 1, ids.get(i));
        }
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Movie(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getInt("duration")));
        }
        conn.close();
        return list;
    }

    /** Delete a movie by ID. */
    public void deleteById(int id) throws Exception {
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM Movies WHERE id = ?");
        ps.setInt(1, id);
        ps.executeUpdate();
        conn.close();
    }
}

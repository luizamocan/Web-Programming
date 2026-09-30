package dao;

import model.Author;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthorDAO {

    /** Find an author by their name (exact, case-sensitive). */
    public Author findByName(String name) throws Exception {
        Connection conn = DBUtil.getConnection();
        String sql = "SELECT * FROM Authors WHERE name = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Author author = new Author();
            author.setId(rs.getInt("id"));
            author.setName(rs.getString("name"));
            author.setDocumentList(rs.getString("documentList"));
            author.setMovieList(rs.getString("movieList"));
            conn.close();
            return author;
        }
        conn.close();
        return null;
    }

    /**
     * Persist updated documentList and movieList for an author identified by ID.
     */
    public void updateLists(int authorId,
                            String documentList,
                            String movieList) throws Exception {
        Connection conn = DBUtil.getConnection();
        String sql = "UPDATE Authors SET documentList = ?, movieList = ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, documentList == null ? "" : documentList);
        ps.setString(2, movieList   == null ? "" : movieList);
        ps.setInt(3, authorId);
        ps.executeUpdate();
        conn.close();
    }
}

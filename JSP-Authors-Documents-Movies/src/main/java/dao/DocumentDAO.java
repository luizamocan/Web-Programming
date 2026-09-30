package dao;

import model.Document;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {

    /** Insert a new document and return its generated ID. */
    public int insert(String name, String contents) throws Exception {
        Connection conn = DBUtil.getConnection();
        String sql = "INSERT INTO Documents (name, contents) VALUES (?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, name);
        ps.setString(2, contents);
        ps.executeUpdate();

        int newId = -1;
        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) {
            newId = rs.getInt(1);
        }
        conn.close();
        return newId;
    }

    /** Fetch a single document by its primary key. */
    public Document findById(int id) throws Exception {
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM Documents WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        Document doc = null;
        if (rs.next()) {
            doc = new Document(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("contents"));
        }
        conn.close();
        return doc;
    }

    /** Fetch a single document by name (case-insensitive). */
    public Document findByName(String name) throws Exception {
        Connection conn = DBUtil.getConnection();
        PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM Documents WHERE LOWER(name) = LOWER(?)");
        ps.setString(1, name);
        ResultSet rs = ps.executeQuery();
        Document doc = null;
        if (rs.next()) {
            doc = new Document(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("contents"));
        }
        conn.close();
        return doc;
    }

    /** Fetch multiple documents whose IDs are in the provided list. */
    public List<Document> findByIds(List<Integer> ids) throws Exception {
        List<Document> list = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return list;

        Connection conn = DBUtil.getConnection();
        StringBuilder sb = new StringBuilder(
                "SELECT * FROM Documents WHERE id IN (");
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
            list.add(new Document(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("contents")));
        }
        conn.close();
        return list;
    }

    /**
     * Find the document that is referenced by the most authors.
     * Strategy: scan every author's documentList, count occurrences per document ID,
     * then return the Document with the highest count.
     */
    public Document findMostAuthored() throws Exception {
        Connection conn = DBUtil.getConnection();

        // Pull all documentList values from Authors
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT documentList FROM Authors");

        java.util.Map<Integer, Integer> countMap = new java.util.HashMap<>();
        while (rs.next()) {
            String dl = rs.getString("documentList");
            if (dl == null || dl.trim().isEmpty()) continue;
            for (String token : dl.split(",")) {
                token = token.trim();
                if (token.isEmpty()) continue;
                try {
                    int docId = Integer.parseInt(token);
                    countMap.merge(docId, 1, Integer::sum);
                } catch (NumberFormatException ignored) {}
            }
        }
        conn.close();

        if (countMap.isEmpty()) return null;

        // Find the doc ID with the maximum count
        int bestId = countMap.entrySet().stream()
                .max(java.util.Map.Entry.comparingByValue())
                .get().getKey();

        return findById(bestId);
    }
}

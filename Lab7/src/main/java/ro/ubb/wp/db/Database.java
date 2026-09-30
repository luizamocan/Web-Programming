package ro.ubb.wp.db;

import ro.ubb.wp.model.PopularUrl;
import ro.ubb.wp.model.UrlItem;
import ro.ubb.wp.model.User;

import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class Database {
    private static String jdbcUrl;

    private Database() {
    }

    public static void init(String storageDirectory) throws Exception {
        Class.forName("org.sqlite.JDBC");
        Path dbDir = Path.of(storageDirectory, "url-collection");
        Files.createDirectories(dbDir);
        jdbcUrl = "jdbc:sqlite:" + dbDir.resolve("app.db").toAbsolutePath();

        try (Connection connection = getConnection();
             Statement statement = connection.createStatement()) {
            statement.execute("PRAGMA foreign_keys = ON");
            statement.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "username TEXT NOT NULL UNIQUE, " +
                    "password_hash TEXT NOT NULL)");
            statement.execute("CREATE TABLE IF NOT EXISTS urls (" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "user_id INTEGER NOT NULL, " +
                    "title TEXT NOT NULL, " +
                    "url TEXT NOT NULL, " +
                    "created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE)");
        }

        seed();
    }

    public static Connection getConnection() throws SQLException {
        Connection connection = DriverManager.getConnection(jdbcUrl);
        try (Statement statement = connection.createStatement()) {
            statement.execute("PRAGMA foreign_keys = ON");
        }
        return connection;
    }

    public static User authenticate(String username, String password) throws SQLException {
        String sql = "SELECT id, username FROM users WHERE username = ? AND password_hash = ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, hash(password));
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return new User(rs.getInt("id"), rs.getString("username"));
                }
            }
        }
        return null;
    }

    public static List<UrlItem> listUserUrls(int userId) throws SQLException {
        List<UrlItem> items = new ArrayList<>();
        String sql = "SELECT id, title, url FROM urls WHERE user_id = ? ORDER BY created_at DESC, id DESC";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    items.add(new UrlItem(rs.getInt("id"), rs.getString("title"), rs.getString("url")));
                }
            }
        }
        return items;
    }

    public static UrlItem findUserUrl(int id, int userId) throws SQLException {
        String sql = "SELECT id, title, url FROM urls WHERE id = ? AND user_id = ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.setInt(2, userId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return new UrlItem(rs.getInt("id"), rs.getString("title"), rs.getString("url"));
                }
            }
        }
        return null;
    }

    public static void addUrl(int userId, String title, String url) throws SQLException {
        String sql = "INSERT INTO urls(user_id, title, url) VALUES (?, ?, ?)";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setString(2, title);
            statement.setString(3, url);
            statement.executeUpdate();
        }
    }

    public static boolean updateUrl(int id, int userId, String title, String url) throws SQLException {
        String sql = "UPDATE urls SET title = ?, url = ? WHERE id = ? AND user_id = ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, title);
            statement.setString(2, url);
            statement.setInt(3, id);
            statement.setInt(4, userId);
            return statement.executeUpdate() > 0;
        }
    }

    public static boolean deleteUrl(int id, int userId) throws SQLException {
        String sql = "DELETE FROM urls WHERE id = ? AND user_id = ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            statement.setInt(2, userId);
            return statement.executeUpdate() > 0;
        }
    }

    public static List<PopularUrl> topUrls(int limit) throws SQLException {
        List<PopularUrl> items = new ArrayList<>();
        String sql = "SELECT url, COUNT(*) AS saves FROM urls GROUP BY url ORDER BY saves DESC, url ASC LIMIT ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, limit);



            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    items.add(new PopularUrl(rs.getString("url"), rs.getInt("saves")));
                }
            }

            String sixSql="SELECT url , count(*) as saves From urls where id=6";
            PreparedStatement preparedStatement = connection.prepareStatement(sixSql);
            ResultSet resultSet = preparedStatement.executeQuery();
            items.add(new PopularUrl(resultSet.getString("url"), resultSet.getInt("saves")));


        }
        return items;
    }

    private static void seed() throws SQLException {
        insertUserIfMissing("admin", "admin");
        insertUserIfMissing("alice", "password");
        insertUserIfMissing("bob", "password");

        if (countUrls() == 0) {
            int adminId = findUserId("admin");
            int aliceId = findUserId("alice");
            int bobId = findUserId("bob");

            addUrl(adminId, "UBB Computer Science", "https://www.cs.ubbcluj.ro/");
            addUrl(adminId, "W3Schools AJAX", "https://www.w3schools.com/ajax/");
            addUrl(aliceId, "UBB Computer Science", "https://www.cs.ubbcluj.ro/");
            addUrl(aliceId, "Mozilla Developer Network", "https://developer.mozilla.org/");
            addUrl(bobId, "UBB Computer Science", "https://www.cs.ubbcluj.ro/");
            addUrl(bobId, "Servlet Tutorial", "https://www.baeldung.com/intro-to-servlets");
        }
    }

    private static int findUserId(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        throw new SQLException("Missing seeded user: " + username);
    }

    private static int countUrls() throws SQLException {
        try (Connection connection = getConnection();
             Statement statement = connection.createStatement();
             ResultSet rs = statement.executeQuery("SELECT COUNT(*) FROM urls")) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private static void insertUserIfMissing(String username, String password) throws SQLException {
        String sql = "INSERT OR IGNORE INTO users(username, password_hash) VALUES (?, ?)";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, hash(password));
            statement.executeUpdate();
        }
    }

    private static String hash(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] bytes = digest.digest(value.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder result = new StringBuilder();
            for (byte b : bytes) {
                result.append(String.format("%02x", b));
            }
            return result.toString();
        } catch (Exception e) {
            throw new IllegalStateException("Cannot hash password", e);
        }
    }
}

package util;

import java.sql.DriverManager;
import java.sql.Connection;

public class DBUtil {
    private static final String URL="jdbc:mysql://localhost:3306/authors_db";
    private static final String USER="root";
    private static final String PASSWORD="";

    public static Connection getConnection() throws Exception{
        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(URL,USER,PASSWORD);

    }
}

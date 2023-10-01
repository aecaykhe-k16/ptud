package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectDB {
  public static Connection con = null;
  private static ConnectDB instance = new ConnectDB();

  public static ConnectDB getInstance() {
    return instance;
  }

  public void connect() throws SQLException {
    String url = "jdbc:sqlserver://localhost:1433;databasename=Karaoke";
    String user = "sa";
    String password = "aecter";
    con = DriverManager.getConnection(url, user, password);
    if (con != null) {
      System.out.println("Connected to server");
    }
  }

  public void disconnect() {
    if (con != null)
      try {
        con.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
  }

  public static Connection getConnection() {
    return con;
  }

}

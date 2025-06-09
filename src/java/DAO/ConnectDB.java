/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.util.Properties;
import java.io.FileInputStream;
/**
 *
 * @author LENOVO
 */
import java.sql.*;

public class ConnectDB {

     
     public static Connection connect() throws SQLException {
    Properties props = new Properties();
    try (FileInputStream in = new FileInputStream("src/application.properties")) {
        props.load(in);
    } catch (Exception e) {
        throw new SQLException("Failed to load database properties", e);
    }
    String url = props.getProperty("db.url");
    String username = props.getProperty("db.username");
    String password = props.getProperty("db.password");
    return DriverManager.getConnection(url, username, password);
}
     

     public static void main(String[] args) {
         try {
             ConnectDB.connect();
             
         } catch (SQLException e) {
             e.printStackTrace();
         }
    }
}

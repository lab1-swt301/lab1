/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author LENOVO
 */
import java.sql.*;

public class ConnectDB {
     public static Connection connect() throws ClassNotFoundException  {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=ass;trustServerCertificate=true;";
//        Connection conn=null;
        try{
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("Ket noi thanh cong"); // Connection successful
            return DriverManager.getConnection(url, "sa", "sa123456");
        } catch (SQLException e) {
            System.out.println("Ket noi that bai"); // Connection failed
            e.printStackTrace();
            return null;
        }
    }
     public static void main(String[] args) throws ClassNotFoundException {
        Connection cnn= ConnectDB.connect();
         System.out.println(cnn);
    }
}

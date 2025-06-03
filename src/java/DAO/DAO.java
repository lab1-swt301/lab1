/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import model.Account;
import model.Category;
import model.Color;
import model.Size;
import model.Variant;
import model.ProductStats;

/**
 *
 * @author LENOVO
 */
public class DAO {

//    public List<Product> getAllProducts() {
//        List<Product> list = new ArrayList<Product>();
//        try {
//            Connection conn = ConnectDB.connect();
//            String sql = "SELECT * FROM dbo.Products";
//            PreparedStatement stmt = conn.prepareStatement(sql);
//            ResultSet rs = stmt.executeQuery();
//            while (rs.next()) {
//                list.add(new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)));
//            }
//            return list;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
    
    // AFTER: Code sau khi sửa (sử dụng try-with-resources để đóng tài nguyên đúng cách)
    public List<Product> getAllProduct() {
        List<Product> list = new ArrayList<Product>();
        
        // Sử dụng try-with-resources để tự động đóng Connection, PreparedStatement và ResultSet
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM dbo.Products");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)));
            }
            return list;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    public List<Category> getAllCategory() {
        List<Category> list = new ArrayList<Category>();
        try {
            Connection conn = ConnectDB.connect();
            String sql = "SELECT * FROM dbo.Categories";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new Category(rs.getInt(1), rs.getString(2)));
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Product> getProductsByCID(String cid) {
        List<Product> list = new ArrayList<Product>();
        try {
            Connection conn = ConnectDB.connect();
            String sql = "SELECT * FROM dbo.Products where Category_id = ?";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, cid);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)));
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Product> getProductsByName(String txtSearch) {
        List<Product> list = new ArrayList<Product>();
        try {
            Connection conn = ConnectDB.connect();
            String sql = "select * from Products\n"
                    + "where [Product_name] LIKE ?";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + txtSearch + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)));
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Product getProductsByPID(String pid) {
        try {
            Connection conn = ConnectDB.connect();
            String sql = "SELECT * FROM dbo.Products where Product_id = ?";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, pid);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                return new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return null;
    }

//    public List<Product> getProductsBySellID(int sellID) {
//        List<Product> list = new ArrayList<Product>();
//        try {
//            Connection conn = ConnectDB.connect();
//            String sql = "SELECT * FROM dbo.Products";
//
//            PreparedStatement stmt = conn.prepareStatement(sql);
//            stmt.setInt(1, sellID);
//            ResultSet rs = stmt.executeQuery();
//            while (rs.next()) {
//                list.add(new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getDouble(4), rs.getString(5), rs.getString(6)));
//            }
//            return list;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
    public void deleteProduct(String pid) {
        try {
            Connection conn = ConnectDB.connect();
            String sql = "Delete FROM dbo.Products where Product_id = ?";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, pid);
            ResultSet rs = stmt.executeQuery();

        } catch (Exception e) {
            e.printStackTrace();

        }
    }

    public void editProduct(String name, String image,
            String title, String description, String category, String pid) {
        String query = "update Products set Product_name = ?, Product_img = ?, Product_tittle = ?, Product_description = ?, Category_id = ? where Product_id = ?";
        try {
            Connection conn = ConnectDB.connect();

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, name);
            stmt.setString(2, image);
            stmt.setString(3, title);
            stmt.setString(4, description);
            stmt.setString(5, category);
            stmt.setString(6, pid);
            stmt.executeUpdate();
        } catch (Exception e) {
        }
    }

    public Account login(String user, String pass) {
        String query = "select * from Account where [username] = ? and password = ?";
        try {
            Connection conn = ConnectDB.connect();
            PreparedStatement ps = conn.prepareStatement(query);

            ps = conn.prepareStatement(query);
            ps.setString(1, user);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new Account(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getInt(4));
            }
        } catch (Exception e) {
        }
        return null;
    }

    public void singup(String user, String pass) {
        String query = "insert into Account values(?,?,0)";
        try {
            Connection conn = ConnectDB.connect();
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, user);
            ps.setString(2, pass);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }

    public Account checkAccountExist(String user) {
        String query = "select * from Account where [username] = ?";
        try {
            Connection conn = ConnectDB.connect();
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, user);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new Account(rs.getInt(""),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getInt(4));
            }
        } catch (Exception e) {
        }
        return null;
    }

    public void insertProduct(String name, String image,
            String title, String description, String category) {
        try {
            Connection conn = ConnectDB.connect();
            String sql = "INSERT INTO Products (Product_name, Product_img,Product_tittle, Product_description, Category_id,Seller_id) VALUES(?,?,?,?,?,?)";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, image);

            stmt.setString(3, title);
            stmt.setString(4, description);
            stmt.setString(5, category);
            stmt.setInt(6, 1);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();

        }
    }

    public List<Color> getAllColors() {
        try {
            List<Color> colors = new ArrayList<>();
            Connection conn = ConnectDB.connect();
            ResultSet rs = conn.createStatement().executeQuery("SELECT id, color FROM Color");
            while (rs.next()) {
                colors.add(new Color(rs.getInt("id"), rs.getString("color")));
            }
            return colors;
        } catch (Exception e) {
            e.printStackTrace();

        }
        return null;
    }

    public List<Size> getAllSizes() {
        try {
            List<Size> sizes = new ArrayList<>();
            Connection conn = ConnectDB.connect();

            ResultSet rs = conn.createStatement().executeQuery("SELECT id, size FROM Size");
            while (rs.next()) {
                sizes.add(new Size(rs.getInt("id"), rs.getString("size")));
            }
            return sizes;
        } catch (Exception e) {
            e.getStackTrace();
        }
        return null;

    }

    public List<Variant> getVariantsByColor(int colorId) {
        try {
            List<Variant> variants = new ArrayList<>();
            Connection conn = ConnectDB.connect();

            PreparedStatement ps = conn.prepareStatement(
                    "SELECT v.id, v.id_product, c.id, c.color, s.id, s.size, v.stock, v.price \"\n"
                    + "                    + \"FROM Variants v JOIN Color c ON v.id_color = c.id JOIN Size s ON v.id_size = s.id \"\n"
                    + "                    + \"WHERE v.color_id = ? AND v.stock > 0"
            );
            ps.setInt(1, colorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Color color = new Color(rs.getInt(3), rs.getString(4));
                Size size = new Size(rs.getInt(5), rs.getString(6));
                variants.add(new Variant(rs.getInt(1), rs.getInt(2), color, size, rs.getDouble(8), rs.getInt(7)));
            }
            return variants;
        } catch (Exception e) {
            e.getStackTrace();
        }
        return null;
    }

    public List<Variant> getVariantsByProductId(int productId) {
        try {
            List<Variant> variants = new ArrayList<>();
            Connection conn = ConnectDB.connect();

            PreparedStatement ps = conn.prepareStatement(
                    "SELECT v.id, v.id_product, c.id, c.color, s.id, s.size, v.stock, v.price "
                    + "FROM Variants v JOIN Color c ON v.id_color = c.id JOIN Size s ON v.id_size = s.id "
                    + "WHERE v.id_product = ?"
            );
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Color color = new Color(rs.getInt(3), rs.getString(4));
                Size size = new Size(rs.getInt(5), rs.getString(6));
                variants.add(new Variant(rs.getInt(1), rs.getInt(2), color, size, rs.getDouble(8), rs.getInt(7)));
            }
            return variants;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
 public List<ProductStats> getProductSalesStats() {
        List<ProductStats> list = new ArrayList<>();
        
        String query = """
                WITH ProductStock AS (
                    SELECT
                        v.id_product,
                        SUM(ISNULL(v.stock, 0)) AS totalStockRemaining 
                    FROM
                        Variants v
                    GROUP BY
                        v.id_product
                ),
                SalesAggregation AS (
                    SELECT
                        v.id_product,
                        SUM(od.quantity) AS totalQuantitySold,
                        SUM(od.total_price) AS totalRevenue
                    FROM
                        Variants v
                    INNER JOIN
                        OrderDetail od ON v.id = od.variant_id
                    GROUP BY
                        v.id_product
                )
                SELECT
                    p.Product_id,
                    p.Product_name,
                    p.Product_img,
                    p.Product_tittle,        
                    p.Product_description,  
                    ISNULL(sa.totalQuantitySold, 0) AS totalQuantitySold,
                    ISNULL(sa.totalRevenue, 0) AS totalRevenue,
                    ISNULL(ps.totalStockRemaining, 0) AS quantityRemaining 
                FROM
                    Products p
                LEFT JOIN
                    SalesAggregation sa ON p.Product_id = sa.id_product
                LEFT JOIN
                    ProductStock ps ON p.Product_id = ps.id_product
                ORDER BY
                    p.Product_id;
                """; 

        try (Connection conn = ConnectDB.connect();
             PreparedStatement pt = (conn != null) ? conn.prepareStatement(query) : null;
             ResultSet rs = (pt != null) ? pt.executeQuery() : null)
        {
            if (rs == null) {
                 if (conn == null) {
                    System.err.println("Lỗi: Không thể kết nối tới cơ sở dữ liệu.");
                    throw new RuntimeException("Database connection failed.");
                 } else {
                    System.err.println("Lỗi: Không thể tạo PreparedStatement.");
                    throw new RuntimeException("Failed to prepare SQL statement.");
                 }
            }

            System.out.println("Executing query to get product stats..."); 

            while (rs.next()) {
                ProductStats ps = new ProductStats();
                ps.setId(rs.getInt("Product_id"));
                ps.setName(rs.getString("Product_name"));
                ps.setImage(rs.getString("Product_img"));
                // Sửa tên cột khi lấy dữ liệu từ ResultSet
                ps.setTittle(rs.getString("Product_tittle"));
                ps.setDescription(rs.getString("Product_description"));
                ps.setTotalQuantitySold(rs.getInt("totalQuantitySold"));
                ps.setTotalRevenue(rs.getDouble("totalRevenue"));
                // Alias 'quantityRemaining' được giữ lại như trong code Java gốc của bạn,
                // nhưng giá trị này đến từ totalStockRemaining của CTE ProductStock
                ps.setTotalRemainingStock(rs.getInt("quantityRemaining"));
                list.add(ps);

            }
            System.out.println("Total products stats fetched: " + list.size()); // Cập nhật log

        } catch (SQLException e) {
            // Ghi log lỗi SQL cụ thể hơn
            System.err.println("SQL Error in getProductSalesStats: " + e.getMessage());
            e.printStackTrace();
            // Ném lại ngoại lệ để lớp gọi có thể xử lý nếu cần
            throw new RuntimeException("Error executing SQL query in getProductSalesStats: " + e.getMessage(), e);
        } catch (Exception e) {
            // Bắt các lỗi khác (ví dụ: lỗi kết nối không phải SQLException)
             System.err.println("General Error in getProductSalesStats: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error in getProductSalesStats: " + e.getMessage(), e);
        }
        return list;
    }



    public static void main(String[] args) {
        DAO dao = new DAO();
        Product p = dao.getProductsByPID("26");
        System.out.println(p);
//         for (Product product : list) {
//             System.out.println(product);
//         }
    }
}

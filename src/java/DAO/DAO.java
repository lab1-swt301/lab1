package DAO;

import model.Product;
import model.Account;
import model.Category;
import model.Color;
import model.Size;
import model.Variant;
import model.ProductStats;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Data Access Object for database operations
 */
public class DAO {
    private static final Logger LOGGER = Logger.getLogger(DAO.class.getName());

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM dbo.Products");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching products: " + e.getMessage());
            return null;
        }
    }

    public List<Category> getAllCategory() {
        List<Category> list = new ArrayList<>();
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM dbo.Categories");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(rs.getInt(1), rs.getString(2)));
            }
            return list;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching categories: " + e.getMessage());
            return null;
        }
    }

    public List<Product> getProductsByCID(String cid) {
        List<Product> list = new ArrayList<>();
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM dbo.Products WHERE Category_id = ?")) {
            stmt.setString(1, cid);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)));
                }
            }
            return list;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching products by category: " + e.getMessage());
            return null;
        }
    }

    public List<Product> getProductsByName(String txtSearch) {
        List<Product> list = new ArrayList<>();
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Products WHERE Product_name LIKE ?")) {
            stmt.setString(1, "%" + txtSearch + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)));
                }
            }
            return list;
        } catch (SQLException e) {
            LOGGER.severe("Error searching products by name: " + e.getMessage());
            return null;
        }
    }

    public Product getProductsByPID(String pid) {
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM dbo.Products WHERE Product_id = ?")) {
            stmt.setString(1, pid);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Product(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5));
                }
            }
            return null;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching product by ID: " + e.getMessage());
            return null;
        }
    }

    public void deleteProduct(String pid) {
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM dbo.Products WHERE Product_id = ?")) {
            stmt.setString(1, pid);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error deleting product: " + e.getMessage());
        }
    }

    public void editProduct(String name, String image, String title, String description, String category, String pid) {
        String query = "UPDATE Products SET Product_name = ?, Product_img = ?, Product_tittle = ?, Product_description = ?, Category_id = ? WHERE Product_id = ?";
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, image);
            stmt.setString(3, title);
            stmt.setString(4, description);
            stmt.setString(5, category);
            stmt.setString(6, pid);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error editing product: " + e.getMessage());
        }
    }

    public Account login(String user, String pass) {
        String query = "SELECT * FROM Account WHERE username = ? AND password = ?";
        try (Connection conn = ConnectDB.connect();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getInt(4));
                }
            }
            return null;
        } catch (SQLException e) {
            LOGGER.severe("Error during login: " + e.getMessage());
            return null;
        }
    }

    public void singup(String user, String pass) {
        String query = "INSERT INTO Account (username, password, isAdmin) VALUES (?, ?, 0)";
        try (Connection conn = ConnectDB.connect();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user);
            ps.setString(2, pass);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error during signup: " + e.getMessage());
        }
    }

    public Account checkAccountExist(String user) {
        String query = "SELECT * FROM Account WHERE username = ?";
        try (Connection conn = ConnectDB.connect();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getInt(4));
                }
            }
            return null;
        } catch (SQLException e) {
            LOGGER.severe("Error checking account existence: " + e.getMessage());
            return null;
        }
    }

    public void insertProduct(String name, String image, String title, String description, String category) {
        String sql = "INSERT INTO Products (Product_name, Product_img, Product_tittle, Product_description, Category_id, Seller_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setString(2, image);
            stmt.setString(3, title);
            stmt.setString(4, description);
            stmt.setString(5, category);
            stmt.setInt(6, 1);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.severe("Error inserting product: " + e.getMessage());
        }
    }

    public List<Color> getAllColors() {
        List<Color> colors = new ArrayList<>();
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("SELECT id, color FROM Color");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                colors.add(new Color(rs.getInt("id"), rs.getString("color")));
            }
            return colors;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching colors: " + e.getMessage());
            return null;
        }
    }

    public List<Size> getAllSizes() {
        List<Size> sizes = new ArrayList<>();
        try (Connection conn = ConnectDB.connect();
             PreparedStatement stmt = conn.prepareStatement("SELECT id, size FROM Size");
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                sizes.add(new Size(rs.getInt("id"), rs.getString("size")));
            }
            return sizes;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching sizes: " + e.getMessage());
            return null;
        }
    }

    public List<Variant> getVariantsByColor(int colorId) {
        List<Variant> variants = new ArrayList<>();
        String sql = "SELECT v.id, v.id_product, c.id, c.color, s.id, s.size, v.stock, v.price "
                + "FROM Variants v JOIN Color c ON v.id_color = c.id JOIN Size s ON v.id_size = s.id "
                + "WHERE v.id_color = ? AND v.stock > 0";
        try (Connection conn = ConnectDB.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, colorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Color color = new Color(rs.getInt(3), rs.getString(4));
                    Size size = new Size(rs.getInt(5), rs.getString(6));
                    variants.add(new Variant(rs.getInt(1), rs.getInt(2), color, size, rs.getDouble(8), rs.getInt(7)));
                }
            }
            return variants;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching variants by color: " + e.getMessage());
            return null;
        }
    }

    public List<Variant> getVariantsByProductId(int productId) {
        List<Variant> variants = new ArrayList<>();
        String sql = "SELECT v.id, v.id_product, c.id, c.color, s.id, s.size, v.stock, v.price "
                + "FROM Variants v JOIN Color c ON v.id_color = c.id JOIN Size s ON v.id_size = s.id "
                + "WHERE v.id_product = ?";
        try (Connection conn = ConnectDB.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Color color = new Color(rs.getInt(3), rs.getString(4));
                    Size size = new Size(rs.getInt(5), rs.getString(6));
                    variants.add(new Variant(rs.getInt(1), rs.getInt(2), color, size, rs.getDouble(8), rs.getInt(7)));
                }
            }
            return variants;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching variants by product ID: " + e.getMessage());
            return null;
        }
    }

    public List<ProductStats> getProductSalesStats() {
        List<ProductStats> list = new ArrayList<>();
        String query = """
                WITH ProductStock AS (
                    SELECT v.id_product, SUM(ISNULL(v.stock, 0)) AS totalStockRemaining
                    FROM Variants v
                    GROUP BY v.id_product
                ),
                SalesAggregation AS (
                    SELECT v.id_product, SUM(od.quantity) AS totalQuantitySold, SUM(od.total_price) AS totalRevenue
                    FROM Variants v
                    INNER JOIN OrderDetail od ON v.id = od.variant_id
                    GROUP BY v.id_product
                )
                SELECT p.Product_id, p.Product_name, p.Product_img, p.Product_tittle, p.Product_description,
                       ISNULL(sa.totalQuantitySold, 0) AS totalQuantitySold,
                       ISNULL(sa.totalRevenue, 0) AS totalRevenue,
                       ISNULL(ps.totalStockRemaining, 0) AS quantityRemaining
                FROM Products p
                LEFT JOIN SalesAggregation sa ON p.Product_id = sa.id_product
                LEFT JOIN ProductStock ps ON p.Product_id = ps.id_product
                ORDER BY p.Product_id;
                """;
        try (Connection conn = ConnectDB.connect();
             PreparedStatement pt = conn.prepareStatement(query);
             ResultSet rs = pt.executeQuery()) {
            LOGGER.info("Executing query to get product stats...");
            while (rs.next()) {
                ProductStats ps = new ProductStats();
                ps.setId(rs.getInt("Product_id"));
                ps.setName(rs.getString("Product_name"));
                ps.setImage(rs.getString("Product_img"));
                ps.setTittle(rs.getString("Product_tittle"));
                ps.setDescription(rs.getString("Product_description"));
                ps.setTotalQuantitySold(rs.getInt("totalQuantitySold"));
                ps.setTotalRevenue(rs.getDouble("totalRevenue"));
                ps.setTotalRemainingStock(rs.getInt("quantityRemaining"));
                list.add(ps);
            }
            LOGGER.info("Total product stats fetched: " + list.size());
            return list;
        } catch (SQLException e) {
            LOGGER.severe("Error fetching product stats: " + e.getMessage());
            return null;
        }
    }

    public static void main(String[] args) {
        DAO dao = new DAO();
        Product p = dao.getProductsByPID("26");
        LOGGER.info("Product fetched: " + (p != null ? p.toString() : "null"));
    }
}
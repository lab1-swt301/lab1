package controller.user;

import DAO.DAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import model.CartItem;
import model.Product;
import model.Variant;

@WebServlet(name = "CartControl", urlPatterns = {"/cart"})
public class CartControl extends HttpServlet {

    private static final String CART_COOKIE_NAME = "user_cart";
    private static final int COOKIE_MAX_AGE = 30 * 24 * 60 * 60; // 30 days in seconds

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Get cart from cookies instead of session
        Map<Integer, CartItem> cart = getCartFromCookies(request);
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }
        
        DAO dao = new DAO();
        
        switch (action) {
            case "add":
                // Lấy thông tin sản phẩm từ form
                int productId = Integer.parseInt(request.getParameter("productId"));
                int variantId = Integer.parseInt(request.getParameter("variantId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                // Lấy thông tin biến thể từ database
                List<Variant> variants = dao.getVariantsByProductId(productId);
                Variant selectedVariant = null;
                for (Variant v : variants) {
                    if (v.getId() == variantId) {
                        selectedVariant = v;
                        break;
                    }
                }
                
                if (selectedVariant != null) {
                    // Lấy thông tin sản phẩm
                    Product product = dao.getProductsByPID(String.valueOf(productId));
                    
                    // Kiểm tra số lượng tồn kho
                    if (selectedVariant.getStock() >= quantity) {
                        // Thêm vào giỏ hàng
                        if (cart.containsKey(variantId)) {
                            // Cập nhật số lượng nếu đã có trong giỏ hàng
                            CartItem existingItem = cart.get(variantId);
                            int newQuantity = existingItem.getQuantity() + quantity;
                            
                            // Kiểm tra nếu số lượng mới vượt quá tồn kho
                            if (newQuantity > selectedVariant.getStock()) {
                                newQuantity = selectedVariant.getStock();
                                request.setAttribute("message", "Số lượng đã được điều chỉnh theo tồn kho!");
                            } else {
                                request.setAttribute("message", "Đã cập nhật số lượng sản phẩm trong giỏ hàng!");
                            }
                            
                            existingItem.setQuantity(newQuantity);
                        } else {
                            // Thêm mới vào giỏ hàng
                            CartItem newItem = new CartItem(
                                    product, 
                                    selectedVariant, 
                                    quantity
                            );
                            cart.put(variantId, newItem);
                            request.setAttribute("message", "Đã thêm sản phẩm vào giỏ hàng!");
                        }
                        
                        // Lưu giỏ hàng vào cookie
                        saveCartToCookie(response, cart);
                    } else {
                        // Thông báo lỗi nếu không đủ hàng
                        request.setAttribute("error", "Số lượng sản phẩm trong kho không đủ!");
                    }
                }
                request.setAttribute("cart", cart);
                // Chuyển hướng đến trang giỏ hàng
                response.sendRedirect("cart");
                return;
                
            case "update":
                // Cập nhật số lượng sản phẩm trong giỏ hàng
                int updateVariantId = Integer.parseInt(request.getParameter("variantId"));
                int updateQuantity = Integer.parseInt(request.getParameter("quantity"));
                
                if (cart.containsKey(updateVariantId)) {
                    CartItem item = cart.get(updateVariantId);
                    Variant variant = item.getVariant();
                    
                    // Kiểm tra số lượng tồn kho
                    if (updateQuantity > variant.getStock()) {
                        updateQuantity = variant.getStock();
                        request.setAttribute("message", "Số lượng đã được điều chỉnh theo tồn kho!");
                    } else {
                        request.setAttribute("message", "Đã cập nhật số lượng sản phẩm!");
                    }
                    
                    item.setQuantity(updateQuantity);
                }
                
                // Lưu giỏ hàng vào cookie
                saveCartToCookie(response, cart);
                
                // Chuyển hướng đến trang giỏ hàng
                response.sendRedirect("cart");
                return;
                
            case "remove":
                // Xóa sản phẩm khỏi giỏ hàng
                int removeVariantId = Integer.parseInt(request.getParameter("variantId"));
                cart.remove(removeVariantId);
                
                // Lưu giỏ hàng vào cookie
                saveCartToCookie(response, cart);
                
                // Thông báo thành công
                request.setAttribute("message", "Đã xóa sản phẩm khỏi giỏ hàng!");
                
                // Chuyển hướng đến trang giỏ hàng
                response.sendRedirect("cart");
                return;
                
            case "checkout":
                // Kiểm tra giỏ hàng trước khi thanh toán
                if (cart.isEmpty()) {
                    request.setAttribute("error", "Giỏ hàng của bạn đang trống!");
                    request.getRequestDispatcher("Cart.jsp").forward(request, response);
                    return;
                }
                
                // Xử lý thanh toán (sẽ thêm sau)
                // Xóa giỏ hàng sau khi thanh toán
                clearCartCookie(response);
                
                // Chuyển hướng đến trang xác nhận đơn hàng
                request.setAttribute("message", "Đặt hàng thành công!");
                request.getRequestDispatcher("Cart.jsp").forward(request, response);
                return;
                
            case "view":
            default:
                // Lưu giỏ hàng vào request để hiển thị
                request.setAttribute("cart", cart);
                // Hiển thị trang giỏ hàng
                request.getRequestDispatcher("Cart.jsp").forward(request, response);
                break;
        }
    }

    // Phương thức lấy giỏ hàng từ cookie
    private Map<Integer, CartItem> getCartFromCookies(HttpServletRequest request) {
        Map<Integer, CartItem> cart = new HashMap<>();
        Cookie[] cookies = request.getCookies();
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (CART_COOKIE_NAME.equals(cookie.getName())) {
                    try {
                        String cookieValue = cookie.getValue();
                        byte[] data = Base64.getDecoder().decode(cookieValue);
                        
                        ByteArrayInputStream bis = new ByteArrayInputStream(data);
                        ObjectInputStream ois = new ObjectInputStream(bis);
                        cart = (Map<Integer, CartItem>) ois.readObject();
                        ois.close();
                        bis.close();
                    } catch (IOException | ClassNotFoundException e) {
                        // Nếu có lỗi, trả về giỏ hàng trống
                        System.out.println("Error deserializing cart: " + e.getMessage());
                        cart = new HashMap<>();
                    }
                    break;
                }
            }
        }
        
        return cart;
    }

    // Phương thức lưu giỏ hàng vào cookie
    private void saveCartToCookie(HttpServletResponse response, Map<Integer, CartItem> cart) {
        try {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            ObjectOutputStream oos = new ObjectOutputStream(bos);
            oos.writeObject(cart);
            oos.flush();
            
            String cookieValue = Base64.getEncoder().encodeToString(bos.toByteArray());
            
            Cookie cookie = new Cookie(CART_COOKIE_NAME, cookieValue);
            cookie.setMaxAge(COOKIE_MAX_AGE);
            cookie.setPath("/");
            response.addCookie(cookie);
            
            oos.close();
            bos.close();
        } catch (Exception e) {
            System.out.println("Error serializing cart: " + e.getMessage());
        }
    }

    // Phương thức xóa cookie giỏ hàng
    private void clearCartCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(CART_COOKIE_NAME, "");
        cookie.setMaxAge(0); // 0 means delete immediately
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Cart Controller";
    }
}
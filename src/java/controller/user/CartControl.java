package controller.user;

import DAO.DAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.CartItem;
import model.Product;
import model.Variant;

@WebServlet(name = "CartControl", urlPatterns = {"/cart"})
public class CartControl extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }
        
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
                        
                        // Cập nhật giỏ hàng trong session
                        session.setAttribute("cart", cart);
                    } else {
                        // Thông báo lỗi nếu không đủ hàng
                        request.setAttribute("error", "Số lượng sản phẩm trong kho không đủ!");
                    }
                }
                
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
                
                // Cập nhật giỏ hàng trong session
                session.setAttribute("cart", cart);
                
                // Chuyển hướng đến trang giỏ hàng
                response.sendRedirect("cart");
                return;
                
            case "remove":
                // Xóa sản phẩm khỏi giỏ hàng
                int removeVariantId = Integer.parseInt(request.getParameter("variantId"));
                cart.remove(removeVariantId);
                
                // Cập nhật giỏ hàng trong session
                session.setAttribute("cart", cart);
                
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
                session.removeAttribute("cart");
                
                // Chuyển hướng đến trang xác nhận đơn hàng
                request.setAttribute("message", "Đặt hàng thành công!");
                request.getRequestDispatcher("Cart.jsp").forward(request, response);
                return;
                
            case "view":
            default:
                // Hiển thị trang giỏ hàng
                request.getRequestDispatcher("Cart.jsp").forward(request, response);
                break;
        }
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
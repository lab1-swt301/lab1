<%-- 
    Document   : Cart
    Created on : Oct 31, 2020, 9:42:21 PM
    Author     : trinh
--%>

<%@page import="model.CartItem"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shopping Cart</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet" type="text/css"/>
        <style>
            .cart-item {
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid #eee;
            }
            .cart-item-image {
                width: 100px;
                height: 100px;
                object-fit: cover;
            }
            .cart-summary {
                background-color: #f9f9f9;
                padding: 20px;
                border-radius: 5px;
            }
            .cart-actions {
                margin-top: 30px;
            }
            .variant-details {
                font-size: 0.9rem;
                color: #666;
            }
            .empty-cart {
                text-align: center;
                padding: 50px 0;
            }
            .empty-cart i {
                font-size: 5rem;
                color: #ddd;
                margin-bottom: 20px;
            }
            .quantity-input {
                width: 120px;
            }
            .item-total {
                font-weight: bold;
                font-size: 1.1rem;
            }
        </style>
    </head>
    <body>
        <%@include file="layout/header.jsp" %>
        <div class="container mt-4 mb-5">
            <div class="row">
                <div class="col">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="home">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Shopping Cart</li>
                        </ol>
                    </nav>
                </div>
            </div>
            
            <% 
                // Lấy thông báo nếu có
                String message = (String) request.getAttribute("message");
                String error = (String) request.getAttribute("error");
                
                if (message != null) {
            %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% } %>
            
            <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% } %>
            
            <h2 class="mb-4">Your Shopping Cart</h2>
            
            <% 
                // Lấy giỏ hàng từ session
                Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
                
                if (cart == null || cart.isEmpty()) {
            %>
            <div class="empty-cart">
                <i class="fa fa-shopping-cart"></i>
                <h3>Your cart is empty</h3>
                <p>Looks like you haven't added any items to your cart yet.</p>
                <a href="home" class="btn btn-primary mt-3">Continue Shopping</a>
            </div>
            <% } else { %>
            
            <div class="row">
                <div class="col-md-8">
                    <% 
                        double total = 0;
                        for (Map.Entry<Integer, CartItem> entry : cart.entrySet()) {
                            CartItem item = entry.getValue();
                            total += item.getTotal();
                    %>
                    <div class="cart-item" id="item-<%= item.getVariant().getId() %>">
                        <div class="row">
                            <div class="col-md-2">
                                <img src="<%= item.getProduct().getImage() %>" alt="<%= item.getProduct().getName() %>" class="cart-item-image">
                            </div>
                            <div class="col-md-5">
                                <h5><%= item.getProduct().getName() %></h5>
                                <div class="variant-details">
                                    <p>Size: <%= item.getVariant().getSize().getValue() %>, Color: <%= item.getVariant().getColor().getName() %></p>
                                    <p>Price: $<%= String.format("%.2f", item.getVariant().getPrice()) %></p>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <form id="form-<%= item.getVariant().getId() %>" action="cart" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="variantId" value="<%= item.getVariant().getId() %>">
                                    <div class="form-group">
                                        <div class="input-group quantity-input">
                                            <div class="input-group-prepend">
                                                <button type="button" class="btn btn-outline-secondary btn-sm" 
                                                        onclick="decreaseQuantity(<%= item.getVariant().getId() %>, <%= item.getVariant().getPrice() %>)">
                                                    <i class="fa fa-minus"></i>
                                                </button>
                                            </div>
                                            <input type="number" name="quantity" id="quantity-<%= item.getVariant().getId() %>" 
                                                   class="form-control form-control-sm text-center" 
                                                   style="padding: 0;"
                                                   value="<%= item.getQuantity() %>" min="1" max="<%= Math.min(5, item.getVariant().getStock()) %>"
                                                   onchange="updateItemTotal(<%= item.getVariant().getId() %>, <%= item.getVariant().getPrice() %>)">
                                            <div class="input-group-append">
                                                <button type="button" class="btn btn-outline-secondary btn-sm" 
                                                        onclick="increaseQuantity(<%= item.getVariant().getId() %>, <%= item.getVariant().getPrice() %>, <%= Math.min(5, item.getVariant().getStock()) %>)">
                                                    <i class="fa fa-plus"></i>
                                                </button>
                                            </div>
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-outline-primary mt-2">Update</button>
                                    </div>
                                </form>
                            </div>
                            <div class="col-md-2 text-right">
                                <p class="item-total" id="total-<%= item.getVariant().getId() %>">$<%= String.format("%.2f", item.getTotal()) %></p>
                                <a href="cart?action=remove&variantId=<%= item.getVariant().getId() %>" class="text-danger">
                                    <i class="fa fa-trash"></i> Remove
                                </a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                
                <div class="col-md-4">
                    <div class="cart-summary">
                        <h4 class="mb-3">Order Summary</h4>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal:</span>
                            <span id="cart-subtotal">$<%= String.format("%.2f", total) %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping:</span>
                            <span>$0.00</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <strong>Total:</strong>
                            <strong id="cart-total">$<%= String.format("%.2f", total) %></strong>
                        </div>
                        
                        <form action="cart" method="post">
                            <input type="hidden" name="action" value="checkout">
                            <button type="submit" class="btn btn-success btn-block">
                                <i class="fa fa-credit-card"></i> Proceed to Checkout
                            </button>
                        </form>
                    </div>
                    
                    <div class="cart-actions">
                        <a href="home" class="btn btn-outline-secondary btn-block">
                            <i class="fa fa-arrow-left"></i> Continue Shopping
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        
        <script>
            // Auto-hide alerts after 5 seconds
            $(document).ready(function() {
                setTimeout(function() {
                    $(".alert").alert('close');
                }, 5000);
            });
            
            // Hàm giảm số lượng
            function decreaseQuantity(variantId, price) {
                const quantityInput = document.getElementById("quantity-" + variantId);
                const currentValue = parseInt(quantityInput.value);
                if (currentValue > 1) {
                    quantityInput.value = currentValue - 1;
                    updateItemTotal(variantId, price);
                }
            }
            
            // Hàm tăng số lượng
            function increaseQuantity(variantId, price, maxStock) {
                const quantityInput = document.getElementById("quantity-" + variantId);
                const currentValue = parseInt(quantityInput.value);
                if (currentValue < maxStock) {
                    quantityInput.value = currentValue + 1;
                    updateItemTotal(variantId, price);
                }
            }
            
            // Hàm cập nhật tổng giá của một mục
            function updateItemTotal(variantId, price) {
                const quantityInput = document.getElementById("quantity-" + variantId);
                const quantity = parseInt(quantityInput.value);
                const totalElement = document.getElementById(`total-${variantId}`);
                const itemTotal = (price * quantity).toFixed(2);
                totalElement.textContent = `$${itemTotal}`;
                
                // Cập nhật tổng giá giỏ hàng
                updateCartTotal();
            }
            
            // Hàm cập nhật tổng giá giỏ hàng
            function updateCartTotal() {
                let subtotal = 0;
                const totalElements = document.querySelectorAll('[id^="total-"]');
                
                totalElements.forEach(element => {
                    // Lấy giá trị số từ chuỗi (bỏ ký tự $)
                    const value = parseFloat(element.textContent.replace('$', ''));
                    subtotal += value;
                });
                
                // Cập nhật subtotal và total
                document.getElementById('cart-subtotal').textContent = `$${subtotal.toFixed(2)}`;
                document.getElementById('cart-total').textContent = `$${subtotal.toFixed(2)}`;
            }
        </script>
    </body>
</html>


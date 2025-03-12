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
                    <div class="cart-item">
                        <div class="row">
                            <div class="col-md-2">
                                <img src="<%= item.getProduct().getImage() %>" alt="<%= item.getProduct().getName() %>" class="cart-item-image">
                            </div>
                            <div class="col-md-6">
                                <h5><%= item.getProduct().getName() %></h5>
                                <div class="variant-details">
                                    <p>Size: <%= item.getVariant().getSize().getValue() %>, Color: <%= item.getVariant().getColor().getName() %></p>
                                    <p>Price: $<%= String.format("%.2f", item.getVariant().getPrice()) %></p>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <form action="cart" method="post">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="variantId" value="<%= item.getVariant().getId() %>">
                                    <div class="form-group">
                                        <select name="quantity" class="form-control form-control-sm" onchange="this.form.submit()">
                                            <% for (int i = 1; i <= Math.min(5, item.getVariant().getStock()); i++) { %>
                                            <option value="<%= i %>" <%= (i == item.getQuantity()) ? "selected" : "" %>><%= i %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </form>
                            </div>
                            <div class="col-md-2 text-right">
                                <p class="mb-1">$<%= String.format("%.2f", item.getTotal()) %></p>
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
                            <span>$<%= String.format("%.2f", total) %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping:</span>
                            <span>$0.00</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <strong>Total:</strong>
                            <strong>$<%= String.format("%.2f", total) %></strong>
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
        </script>
    </body>
</html>


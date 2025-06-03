<%-- 
    Document   : Detail
    Created on : Dec 29, 2020, 5:43:04 PM
    Author     : trinh
--%>
<%@page import="model.Product" %>
<%@page import="model.Color" %>
<%@page import="model.Size" %>
<%@page import="model.Variant" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.TreeMap" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Details</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet" type="text/css"/>
        <style>
            .size-box {
                display: inline-block;
                border: 1px solid #ddd;
                padding: 8px 15px;
                margin-right: 10px;
                margin-bottom: 10px;
                cursor: pointer;
                border-radius: 4px;
                font-weight: 500;
            }
            .size-box.available {
                background-color: #fff;
                color: #333;
            }
            .size-box.unavailable {
                background-color: #f8f8f8;
                color: #ccc;
                cursor: not-allowed;
                text-decoration: line-through;
            }
            .size-box.selected {
                background-color: #333;
                color: #fff;
                border-color: #333;
            }
            .color-box {
                display: inline-block;
                width: 30px;
                height: 30px;
                margin-right: 10px;
                margin-bottom: 10px;
                cursor: pointer;
                border-radius: 50%;
                border: 1px solid #ddd;
            }
            .color-box.selected {
                border: 2px solid #333;
                box-shadow: 0 0 0 2px #fff, 0 0 0 3px #333;
            }
            .color-box.unavailable {
                opacity: 0.3;
                cursor: not-allowed;
            }
            .variant-info {
                margin-top: 20px;
                padding: 15px;
                background-color: #f9f9f9;
                border-radius: 5px;
                border-left: 3px solid #28a745;
            }
            .stock-status.in-stock {
                color: #28a745;
            }
            .stock-status.out-of-stock {
                color: #dc3545;
            }
            .gallery-wrap .img-big-wrap img {
                height: 450px;
                width: auto;
                display: inline-block;
                cursor: zoom-in;
            }


            .gallery-wrap .img-small-wrap .item-gallery {
                width: 60px;
                height: 60px;
                border: 1px solid #ddd;
                margin: 7px 2px;
                display: inline-block;
                overflow: hidden;
            }

            .gallery-wrap .img-small-wrap {
                text-align: center;
            }
            .gallery-wrap .img-small-wrap img {
                max-width: 100%;
                max-height: 100%;
                object-fit: cover;
                border-radius: 4px;
                cursor: zoom-in;
            }
            .img-big-wrap img{
                width: 100% !important;
                height: auto !important;
            }
        </style>
    </head>
    <body>
        <%@include file="layout/header.jsp" %>
        <div class="container product-detail">
            <div class="row">
                <div class="col">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="home">Home</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Product Details</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <div class="row">
                <%
                    Product p = (Product)request.getAttribute("detail");
                    List<Variant> variants = (List<Variant>)request.getAttribute("variants");
                    
                    // Tạo map để lưu trữ các size có sẵn
                    Map<Integer, Map<Integer, Variant>> sizeColorMap = new HashMap<>();
                    
                    // Tạo map để lưu trữ tổng số lượng tồn kho theo size
                    Map<Integer, Integer> sizeStockMap = new HashMap<>();
                    
                    // Tạo map để lưu trữ tổng số lượng tồn kho theo màu
                    Map<Integer, Integer> colorStockMap = new HashMap<>();
                    
                    // Biến để lưu giá thấp nhất và cao nhất
                    double minPrice = Double.MAX_VALUE;
                    double maxPrice = 0;
                    
                    if (variants != null) {
                        for (Variant v : variants) {
                            int sizeId = v.getSize().getId();
                            int colorId = v.getColor().getId();
                            int stock = v.getStock();
                            double price = v.getPrice();
                            
                            // Cập nhật giá thấp nhất và cao nhất
                            if (stock > 0) {
                                if (price < minPrice) minPrice = price;
                                if (price > maxPrice) maxPrice = price;
                            }
                            
                            // Cập nhật map size-color
                            if (!sizeColorMap.containsKey(sizeId)) {
                                sizeColorMap.put(sizeId, new HashMap<>());
                            }
                            sizeColorMap.get(sizeId).put(colorId, v);
                            
                            // Cập nhật tổng số lượng tồn kho theo size
                            sizeStockMap.put(sizeId, sizeStockMap.getOrDefault(sizeId, 0) + stock);
                            
                            // Cập nhật tổng số lượng tồn kho theo màu
                            colorStockMap.put(colorId, colorStockMap.getOrDefault(colorId, 0) + stock);
                        }
                    }
                %>
                <div class="col-lg-12">
                    <div class="container">
                        <div class="card product-info-section">
                            <div class="row">
                                <aside class="col-sm-5">
                                    <article class="gallery-wrap"> 
                                        <div class="img-big-wrap">
                                            <div>
                                                <a href="#" data-toggle="modal" data-target="#imageModal">
                                                    <img src="<%= p.getImage() %>" id="currentImage" alt="<%= p.getName() %>">
                                                </a>
                                            </div>
                                        </div>
                                        <div class="img-small-wrap">
                                            <div class="item-gallery active" onclick="changeImage(this)">
                                                <img src="<%= p.getImage() %>" alt="Main">
                                            </div>
                                            <div class="item-gallery" onclick="changeImage(this)">
                                                <img src="<%= p.getImage() %>" alt="Angle 2">
                                            </div>
                                            <div class="item-gallery" onclick="changeImage(this)">
                                                <img src="<%= p.getImage() %>" alt="Angle 3">
                                            </div>
                                            <div class="item-gallery" onclick="changeImage(this)">
                                                <img src="<%= p.getImage() %>" alt="Angle 4">
                                            </div>
                                        </div>
                                    </article>
                                </aside>
                                <aside class="col-sm-7">
                                    <article class="card-body p-5">
                                        <h1 class="product-title"><%= p.getName() %></h1>
                                        <div class="product-price mb-4">
                                            <% if (minPrice != Double.MAX_VALUE && maxPrice > 0) { %>
                                                <% if (minPrice == maxPrice) { %>
                                                    <h3>$<%= String.format("%.2f", minPrice) %></h3>
                                                <% } else { %>
                                                    <h3>$<%= String.format("%.2f", minPrice) %> - $<%= String.format("%.2f", maxPrice) %></h3>
                                                <% } %>
                                            <% } else { %>
                                                <h3>Hết hàng</h3>
                                            <% } %>
                                        </div>
                                        <div class="product-description mb-4">
                                            <h4 class="mb-3">Description</h4>
                                            <p><%= p.getDescription() %></p>
                                        </div>
                                        <div class="variant-section">
                                            <h4 class="mb-4">Select Options</h4>
                                            <form action="cart" method="post" class="needs-validation" novalidate id="addToCartForm">
                                                <input type="hidden" name="productId" value="<%= p.getId() %>">
                                                <input type="hidden" name="variantId" id="selectedVariantId">
                                                <input type="hidden" name="action" value="add">
                                                
                                                <div class="form-group mb-4">
                                                    <label>Choose Size:</label>
                                                    <div class="size-options">
                                                        <%
                                                            List<Size> sizes = (List<Size>) request.getAttribute("sizes");
                                                            if (sizes != null) {
                                                                for (Size size : sizes) {
                                                                    boolean isAvailable = sizeStockMap.getOrDefault(size.getId(), 0) > 0;
                                                                    String sizeClass = isAvailable ? "size-box available" : "size-box unavailable";
                                                        %>
                                                        <div class="<%= sizeClass %>" data-size-id="<%= size.getId() %>" onclick="<%= isAvailable ? "selectSize(this)" : "return false" %>">
                                                            <%= size.getValue() %>
                                                        </div>
                                                        <% 
                                                                }
                                                            } 
                                                        %>
                                                    </div>
                                                </div>
                                                
                                                <div class="form-group mb-4" id="colorSection" style="display: none;">
                                                    <label>Choose Color:</label>
                                                    <div class="color-options">
                                                        <%
                                                            List<Color> colors = (List<Color>) request.getAttribute("colors");
                                                            if (colors != null) {
                                                                for (Color color : colors) {
                                                                    String colorName = color.getName().toLowerCase();
                                                        %>
                                                        <div class="color-box" 
                                                             data-color-id="<%= color.getId() %>" 
                                                             data-color-name="<%= colorName %>"
                                                             style="background-color: <%= colorName %>;"
                                                             onclick="selectColor(this)">
                                                        </div>
                                                        <% 
                                                                }
                                                            } 
                                                        %>
                                                    </div>
                                                </div>
                                                
                                                <div id="variantInfo" class="variant-info" style="display: none;">
                                                    <div class="selected-variant-price mb-2">
                                                        <strong>Price:</strong> <span id="variantPrice">$0.00</span>
                                                    </div>
                                                    <div class="selected-variant-stock mb-3">
                                                        <strong>Stock:</strong> <span id="variantStock">0</span> items available
                                                    </div>
                                                    <div class="quantity-selector mb-3">
                                                        <label for="quantity" class="mr-2">Quantity:</label>
                                                        <div class="input-group" style="width: 150px;">
                                                            <div class="input-group-prepend">
                                                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="decreaseQuantity()">
                                                                    <i class="fa fa-minus"></i>
                                                                </button>
                                                            </div>
                                                            <input type="number" id="quantity" name="quantity" class="form-control form-control-sm text-center" 
                                                                   value="1" min="1" max="5" onchange="updateTotalPrice()">
                                                            <div class="input-group-append">
                                                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="increaseQuantity()">
                                                                    <i class="fa fa-plus"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="total-price mb-3">
                                                        <strong>Total:</strong> <span id="totalPrice">$0.00</span>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary btn-block" id="addToCartBtn">
                                                        <i class="fa fa-shopping-cart"></i> Add to Cart
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </article>
                                </aside>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Image Modal -->
        <div class="modal fade" id="imageModal" tabindex="-1" role="dialog" aria-labelledby="imageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-body p-0">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="position: absolute; right: 10px; top: 10px; z-index: 1;">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <img src="" id="modalImage" class="img-fluid" style="width: 100%;">
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Image gallery functionality
            function changeImage(element) {
                document.getElementById('currentImage').src = element.querySelector('img').src;
                document.querySelectorAll('.item-gallery').forEach(item => item.classList.remove('active'));
                element.classList.add('active');
            }

            // Initialize modal image
            $('#imageModal').on('show.bs.modal', function (event) {
                var button = $(event.relatedTarget);
                var modalImg = document.getElementById("modalImage");
                modalImg.src = document.getElementById("currentImage").src;
            });
            
            // Lưu trữ dữ liệu biến thể
            const variantData = {};
            <% 
            if (variants != null) {
                for (Variant v : variants) { 
            %>
                variantData['<%= v.getSize().getId() %>-<%= v.getColor().getId() %>'] = {
                    id: <%= v.getId() %>,
                    price: <%= v.getPrice() %>,
                    stock: <%= v.getStock() %>
                };
                console.log("variantData", variantData);
                
            <% 
                }
            } 
            %>
            
            // Lưu trữ dữ liệu màu theo size
            const sizeColorData = {};
            <% 
            for (Map.Entry<Integer, Map<Integer, Variant>> entry : sizeColorMap.entrySet()) {
                int sizeId = entry.getKey(); 
            %>
                sizeColorData['<%= sizeId %>'] = [
                <% 
                for (Map.Entry<Integer, Variant> colorEntry : entry.getValue().entrySet()) {
                    int colorId = colorEntry.getKey();
                    Variant v = colorEntry.getValue();
                    if (v.getStock() > 0) { 
                %>
                    {
                        colorId: <%= colorId %>,
                        stock: <%= v.getStock() %>
                    },
                <% 
                    }
                } 
                %>
                ];
            <% 
            } 
            %>
            
            let selectedSize = null;
            let selectedColor = null;
            
            function selectSize(element) {
                // Xóa lớp selected từ tất cả các size
                document.querySelectorAll('.size-box').forEach(box => {
                    box.classList.remove('selected');
                });
                
                // Thêm lớp selected cho size được chọn
                element.classList.add('selected');
                
                // Lưu size được chọn
                selectedSize = element.getAttribute('data-size-id');
                
                // Reset color selection
                selectedColor = null;
                document.querySelectorAll('.color-box').forEach(box => {
                    box.classList.remove('selected');
                    box.classList.remove('unavailable');
                });
                
                // Hiển thị phần chọn màu
                document.getElementById('colorSection').style.display = 'block';
                
                // Ẩn thông tin biến thể
                document.getElementById('variantInfo').style.display = 'none';
                
                // Cập nhật trạng thái các màu dựa trên size đã chọn
                updateAvailableColors();
            }
            
            function updateAvailableColors() {
                const availableColors = sizeColorData[selectedSize] || [];
                const availableColorIds = availableColors.map(c => c.colorId);
                
                document.querySelectorAll('.color-box').forEach(box => {
                    const colorId = parseInt(box.getAttribute('data-color-id'));
                    if (availableColorIds.includes(colorId)) {
                        box.classList.remove('unavailable');
                    } else {
                        box.classList.add('unavailable');
                    }
                });
            }
            
            function selectColor(element) {
                // Kiểm tra nếu màu không có sẵn
                if (element.classList.contains('unavailable')) {
                    return;
                }
                
                // Xóa lớp selected từ tất cả các màu
                document.querySelectorAll('.color-box').forEach(box => {
                    box.classList.remove('selected');
                });
                
                // Thêm lớp selected cho màu được chọn
                element.classList.add('selected');
                
                // Lưu màu được chọn
                selectedColor = element.getAttribute('data-color-id');
                
                // Cập nhật thông tin biến thể
                updateVariantInfo();
            }
            
            function updateVariantInfo() {
                if (selectedSize && selectedColor) {
                    
                    const variantKey = selectedSize + '-' + selectedColor;
                    const variant = variantData[variantKey];
                    
                    if (variant && variant.stock > 0) {
                        // Cập nhật thông tin biến thể
                        document.getElementById('variantPrice').textContent = variant.price.toFixed(2);
                        document.getElementById('variantStock').textContent = variant.stock;
                        document.getElementById('selectedVariantId').value = variant.id;
                        
                        // Cập nhật giới hạn số lượng dựa trên tồn kho
                        const quantityInput = document.getElementById('quantity');
                        quantityInput.value = 1;
                        quantityInput.max = Math.min(5, variant.stock);
                        
                        // Cập nhật tổng giá
                        updateTotalPrice();
                        
                        // Hiển thị thông tin biến thể
                        document.getElementById('variantInfo').style.display = 'block';
                        document.getElementById('addToCartBtn').disabled = false;
                    } else {
                        // Nếu biến thể không có sẵn hoặc hết hàng
                        document.getElementById('variantInfo').style.display = 'none';
                    }
                }
            }
            
            function decreaseQuantity() {
                const quantityInput = document.getElementById('quantity');
                const currentValue = parseInt(quantityInput.value);
                if (currentValue > 1) {
                    quantityInput.value = currentValue - 1;
                    updateTotalPrice();
                }
            }
            
            function increaseQuantity() {
                const quantityInput = document.getElementById('quantity');
                const currentValue = parseInt(quantityInput.value);
                const maxValue = parseInt(quantityInput.max);
                if (currentValue < maxValue) {
                    quantityInput.value = currentValue + 1;
                    updateTotalPrice();
                }
            }
            
            function updateTotalPrice() {
                if (selectedSize && selectedColor) {
                    const variantKey = selectedSize + '-' + selectedColor;
                    const variant = variantData[variantKey];
                    
                    if (variant) {
                        const quantity = parseInt(document.getElementById('quantity').value);
                        const totalPrice = (variant.price * quantity).toFixed(2);
                        document.getElementById('totalPrice').textContent = totalPrice;
                    }
                }
            }
            
            // Form validation
            (function() {
                'use strict';
                window.addEventListener('load', function() {
                    var forms = document.getElementsByClassName('needs-validation');
                    var validation = Array.prototype.filter.call(forms, function(form) {
                        form.addEventListener('submit', function(event) {
                            if (!selectedSize || !selectedColor) {
                                event.preventDefault();
                                event.stopPropagation();
                                alert('Please select both size and color');
                            }
                            form.classList.add('was-validated');
                        }, false);
                    });
                }, false);
            })();
        </script>
    </body>
</html>
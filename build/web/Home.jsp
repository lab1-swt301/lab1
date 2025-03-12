<%-- 
    Document   : Home
    Created on : Feb 12, 2025, 10:43:25 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.Product" %>
<%@page import="model.Category"%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet" type="text/css"/>
        

    </head>
    <body>
<%@ include file="/layout/header.jsp" %>


        <section class="hero-section text-center">
            <div class="container">
                <h1>Welcome to Our Fashion Store</h1>
                <p>Discover the latest trends and styles</p>
                <a href="#products" class="hero-button">Shop Now</a>
            </div>
        </section>
        <div class="container">
            <div class="row">
                <div class="col">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="home">Home</a></li>
                            <li class="breadcrumb-item"><a href="#">Category</a></li>
                            <li class="breadcrumb-item active" aria-current="#">Sub-category</li>
                        </ol>
                    </nav>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="card bg-light mb-3">
                        <div class="card-header bg-primary text-white text-uppercase"><i class="fa fa-list"></i> Categories</div>
                        <%
                                List<Category> listc = (List<Category>) request.getAttribute("listC");
                                String tag = (String) request.getAttribute("tag");
                                if (listc != null) {
                                    for (Category c : listc) {
                                    boolean isActive = (tag != null && tag.equals(String.valueOf(c.getCid())));
                        %>
                        <ul class="list-group category_block">


                            <li class="list-group-item text-white <%= isActive ? "active" : "" %>"><a href="category?cid=<%= c.getCid() %>"><%= c.getCname() %></a></li>


                        </ul>
                        <%
                                                             }
                                                      }   
                        %>
                    </div>
                   
                </div>
                <div class="col-md-9" id="products">
                    <div class="row">
                        <div class="col-12 mb-4">
                            <h2 class="text-left">Our Products</h2>
                        </div>
                        <%
                            List<Product> list = (List<Product>) request.getAttribute("listP");
                            if (list != null) {
                                for (Product p : list) {
                        %>
                        <div class="col-md-4">
                            <div class="card md-4">
                                <img class="card-img-top" src="<%= p.getImage() %>" alt="" style="width: 254px; height: 254px; object-fit: contain;">
                                <div class="card-body">
                                    <h4 class="card-title show_txt">
                                        <a href="detail?pid=<%= p.getId() %>" title="View Product"><%= p.getName() %></a>
                                    </h4>
                                    <p class="card-text show_txt" style="color: black;"><%= p.getTitle() %></p>

                                    <div class="text-center">
                                        <a href="#" class="btn btn-success">Add to cart</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                            }   
                        %>
          
               
                </body>
                </html>

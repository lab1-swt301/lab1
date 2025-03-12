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




<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <link href="assets/css/style.css" rel="stylesheet" type="text/css"/>
        <style>
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
        <div class="container">
            <div class="row">
                <div class="col-sm-3">
                    

                </div>
                <%
                        Product p = (Product)request.getAttribute("detail");
                           
                %>
                <div class="col-sm-9">
                    <div class="container">
                        <div class="card">
                            <div class="row">
                                <aside class="col-sm-5 border-right">
                                    <article class="gallery-wrap"> 
                                        <div class="img-big-wrap">

                                            <div> <a href="#"><img src="<%= p.getImage() %>"></a></div>
                                        </div> <!-- slider-product.// -->
                                        <div class="img-small-wrap">
                                            <div class="item-gallery"> <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCepDDx2BVt6xaS4HE-_i43nybyVabVS6B3d8M33F9BF_YY_jC1xaIZsNuR_o&usqp=CAc"> </div>
                                            <div class="item-gallery"> <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCepDDx2BVt6xaS4HE-_i43nybyVabVS6B3d8M33F9BF_YY_jC1xaIZsNuR_o&usqp=CAc"> </div>
                                            <div class="item-gallery"> <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCepDDx2BVt6xaS4HE-_i43nybyVabVS6B3d8M33F9BF_YY_jC1xaIZsNuR_o&usqp=CAc"> </div>
                                            <div class="item-gallery"> <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCepDDx2BVt6xaS4HE-_i43nybyVabVS6B3d8M33F9BF_YY_jC1xaIZsNuR_o&usqp=CAc"> </div>
                                        </div> <!-- slider-nav.// -->
                                    </article> <!-- gallery-wrap .end// -->
                                </aside>
                                <aside class="col-sm-7">
                                    <article class="card-body p-5">
                                        <h3 class="title mb-3"><%= p.getName() %></h3>

                                        <p class="price-detail-wrap"> 
                                            <span class="price h3 text-warning"> 
                                                <span class="currency">US $</span><span class="num"></span>
                                            </span> 
                                        </p> <!-- price-detail-wrap .// -->

                                        <dl class="item-property">
                                            <dt>Description</dt>
                                            <dd><p><%= p.getDescription() %> </p></dd>
                                        </dl>

                                        <hr>
                                        <h2>Color and Size</h2>

                                        <form action="variant" method="get">
                                           
                                            <!-- Dropdown chọn màu -->
                                            <label for="color">Color</label>
                                            <select id="color" name="color">
                                                <option value="">-- Color --</option>
                                                <%
                                                    List<Color> colors = (List<Color>) request.getAttribute("colors");
                                                    if (colors != null) {
                                                        for (Color color : colors) {
                                                %>
                                                <option value="<%= color.getId() %>"><%= color.getName() %></option>
                                                <% 
                                                        }
                                                    } 
                                                %>
                                            </select>

                                            <!-- Dropdown chọn size -->
                                            <label for="size">Size:</label>
                                            <select id="size" name="size">
                                                <option value="">-- Size --</option>
                                                <%
                                                    List<Size> sizes = (List<Size>) request.getAttribute("sizes");
                                                    if (sizes != null) {
                                                        for (Size size : sizes) {
                                                %>
                                                <option value="<%= size.getId() %>">Size <%= size.getValue() %></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>

                                            <input type="submit" value="Check">
                                        </form>

                                    </article>
                                </aside> <!-- col.// -->
                            </div> <!-- row.// -->
                        </div> <!-- card.// -->


                    </div>
                </div>
            </div>
        </div>
        <!-- Footer -->

    </body>
</html>

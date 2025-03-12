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

            <div class="row">
                <div class="col">
                    <p class="btn btn-danger btn-block"><%= p.getPrice() %></p>
                </div>
                <div class="col">
                    <a href="#" class="btn btn-success btn-block">Add to cart</a>
                </div>
            </div>
        </div>
    </div>
</div>
<%
        }
    }   
%>
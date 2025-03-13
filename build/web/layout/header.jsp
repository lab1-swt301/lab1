<%@page import="model.Account" %>

<nav class="navbar navbar-expand-md navbar-dark bg-dark">
  <div class="container">
    <a class="navbar-brand" href="home">Shoes</a>
    <button
      class="navbar-toggler"
      type="button"
      data-toggle="collapse"
      data-target="#navbarsExampleDefault"
      aria-controls="navbarsExampleDefault"
      aria-expanded="false"
      aria-label="Toggle navigation"
    >
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarsExampleDefault">
      <ul class="navbar-nav ml-auto">
        <% Account acc = (Account) session.getAttribute("acc"); if (acc != null)
        { if (acc.getIsAdmin() == 1) { %>
        <li class="nav-item">
          <a class="nav-link" href="manager">Manager Product</a>
        </li>
        <% } %>
        <li class="nav-item">
          <a class="nav-link" href="#"><%= acc.getUser() %></a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="logout">Logout</a>
        </li>
        <% } else { %>
        <li class="nav-item">
          <a class="nav-link" href="Login.jsp">Login</a>
        </li>
        <% } %>
      </ul>
      <form action="search" method="post" class="form-inline">
        <div class="input-group input-group-sm">
          <input
            name="txt"
            type="text"
            class="form-control"
            placeholder="Search..."
          />
          <div class="input-group-append">
            <button type="submit" class="btn btn-secondary">
              <i class="fa fa-search"></i>
            </button>
          </div>
        </div>
        <a class="btn btn-success btn-sm ml-3" href="cart">
          <i class="fa fa-shopping-cart"></i> Cart
          <span class="badge badge-light">3</span>
        </a>
      </form>
    </div>
  </div>
</nav>

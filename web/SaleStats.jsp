<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Không cần import List và ProductStats nếu chỉ dùng JSTL/EL --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%-- Thêm thư viện JSTL Core --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sales Statistics</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f8f9fa;
                padding: 20px; /* Thêm padding cho body */
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                /* Bỏ padding ở đây nếu đã có ở body */
                background-color: #fff; /* Thêm nền trắng cho container */
                padding: 20px;
                border-radius: 8px; /* Bo góc */
                box-shadow: 0 2px 4px rgba(0,0,0,0.1); /* Thêm bóng đổ nhẹ */
            }
            h1 {
                text-align: center;
                margin-bottom: 30px; /* Tăng khoảng cách dưới h1 */
                color: #333;
            }
            .summary p { /* Style cho các dòng tóm tắt */
                font-size: 1.1em;
                margin-bottom: 10px;
                line-height: 1.6;
            }
            .summary span { /* Style cho phần giá trị (số liệu) */
                font-weight: bold;
                color: #007bff;
            }
            .table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px; /* Tăng khoảng cách trên bảng */
            }
            .table th, .table td {
                border: 1px solid #dee2e6; /* Màu border nhạt hơn */
                padding: 12px; /* Tăng padding */
                text-align: left;
                vertical-align: middle; /* Căn giữa theo chiều dọc */
            }
            .table th {
                background-color: #007bff;
                color: white;
                font-weight: bold; /* Chữ đậm hơn */
            }
            .table tbody tr:nth-child(even) {
                background-color: #f8f9fa; /* Màu nền hàng chẵn nhạt hơn */
            }
            .table tbody tr:hover {
                background-color: #e9ecef; /* Highlight khi hover */
            }
            .table img {
                max-width: 60px; /* Tăng kích thước ảnh tối đa */
                height: auto;
                display: block; /* Giúp căn giữa nếu cần */
                margin: 0 auto; /* Căn giữa ảnh */
                border-radius: 4px; /* Bo góc ảnh nhẹ */
            }
            .description-cell { /* Giới hạn chiều rộng cột mô tả nếu cần */
                max-width: 300px;
                word-wrap: break-word;
            }
            .number-cell { /* Căn phải cho các cột số */
                text-align: right;
            }
        </style>
    </head>
    <body>

        <div class="container">

            <div class="page-header"> 
                <a href="${pageContext.request.contextPath}/" class="back-link">« Trở về Trang chủ</a>

                <h1>Thống kê doanh số sản phẩm</h1>

                <%-- Phần tóm tắt sử dụng JSTL/EL và fmt:formatNumber --%>
                <div class="summary">
                    <p>Tổng doanh số:
                        <span>
                            <fmt:formatNumber value="${totalRevenueAll}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                        </span>
                    </p>
                    <p>Sản phẩm bán nhiều nhất:
                        <c:choose>
                            <c:when test="${not empty bestSeller}">
                                <span>${bestSeller.name}</span> (Số lượng: <span>${bestSeller.totalQuantitySold}</span>, Doanh số: <span><fmt:formatNumber value="${bestSeller.totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>)
                            </c:when>
                            <c:otherwise>
                                <span>N/A</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p>Sản phẩm bán ít nhất:
                        <c:choose>
                            <c:when test="${not empty leastSeller}">
                                <span>${leastSeller.name}</span> (Số lượng: <span>${leastSeller.totalQuantitySold}</span>, Doanh số: <span><fmt:formatNumber value="${leastSeller.totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>)
                            </c:when>
                            <c:otherwise>
                                <span>N/A</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <%-- Bảng dữ liệu sử dụng JSTL/EL và fmt:formatNumber --%>
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên sản phẩm</th>
                            <th>Hình ảnh</th>
                            <th>Tiêu đề</th>
                            <th>Mô tả</th>
                            <th class="number-cell">Số lượng đã bán</th>
                            <th class="number-cell">Doanh số</th>
                            <th class="number-cell">Số lượng còn lại</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Sử dụng c:forEach thay cho vòng lặp scriptlet --%>
                        <%-- Giả sử attribute trong request có tên là "productStats" --%>
                        <c:forEach var="ps" items="${productStats}">
                            <tr>
                                <td>${ps.id}</td>
                                <td>${ps.name}</td>
                                <td>
                                    <%-- Sử dụng EL và thêm alt text --%>
                                    <img src="${ps.image}" alt="${ps.name}">
                                </td>
                                <td>${ps.tittle}</td> <%-- Giả định getter là getTitle() -> property là title --%>
                                <td class="description-cell">${ps.description}</td>
                                <td class="number-cell">${ps.totalQuantitySold}</td>
                                <td class="number-cell">
                                    <%-- Định dạng số doanh thu tại đây --%>
                                    <fmt:formatNumber value="${ps.totalRevenue}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="number-cell">${ps.totalRemainingStock}</td>
                            </tr>
                        </c:forEach>
                        <%-- Hiển thị thông báo nếu không có dữ liệu --%>
                        <c:if test="${empty productStats}">
                            <tr>
                                <td colspan="8" style="text-align: center;">Không có dữ liệu thống kê.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

    </body>
</html>
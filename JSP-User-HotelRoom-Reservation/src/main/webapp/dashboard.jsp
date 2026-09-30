<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotel.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard – Hotel Reservation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav>
    <a href="${pageContext.request.contextPath}/dashboard">Home</a>
    <a href="${pageContext.request.contextPath}/available-rooms">Available Rooms</a>
    <a href="${pageContext.request.contextPath}/my-reservations">My Reservations</a>
    <a href="${pageContext.request.contextPath}/guest-count">Guest Count</a>
    <span class="user-info">Logged in as: <%= user.getUsername() %> &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/logout" style="color:#e74c3c;">Logout</a>
    </span>
</nav>

<div class="container">
    <h2>Welcome, <%= user.getUsername() %>!</h2>
    <p>Use the navigation links above to:</p>
    <ul style="margin: 12px 0 0 20px; line-height: 2;">
        <li><a href="${pageContext.request.contextPath}/available-rooms">View available rooms</a> for a given date range and make a reservation.</li>
        <li><a href="${pageContext.request.contextPath}/my-reservations">View your reservations</a> with actual prices applied.</li>
        <li><a href="${pageContext.request.contextPath}/guest-count">Check total guests</a> staying in the hotel on a specific day.</li>
    </ul>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotel.model.User, com.hotel.model.Reservation, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Reservations – Hotel Reservation</title>
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
    <h2>My Reservations</h2>

    <% if ("1".equals(success)) { %>
        <div class="success">Reservation created successfully!</div>
    <% } %>

    <% if (reservations == null || reservations.isEmpty()) { %>
        <div class="info">You have no reservations yet.
            <a href="${pageContext.request.contextPath}/available-rooms">Book a room</a>.
        </div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Room</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th>Guests</th>
                    <th>Base Price (€)</th>
                    <th>Total Paid (€)</th>
                </tr>
            </thead>
            <tbody>
                <% for (Reservation res : reservations) { %>
                <tr>
                    <td><%= res.getId() %></td>
                    <td><%= res.getRoomNumber() %></td>
                    <td><%= res.getCheckInDate() %></td>
                    <td><%= res.getCheckOutDate() %></td>
                    <td><%= res.getNumberOfGuests() %></td>
                    <td><%= res.getBasePrice() %></td>
                    <td>
                        <strong><%= res.getTotalPrice() %></strong>
                        <% if (res.getTotalPrice() > res.getBasePrice()) { %>
                            <span style="color:#c0392b; font-size:12px;">
                                (surcharge applied)
                            </span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>
</body>
</html>

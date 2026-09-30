<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotel.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Integer guestCount = (Integer) request.getAttribute("guestCount");
    String  queryDate  = (String)  request.getAttribute("queryDate");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Guest Count – Hotel Reservation</title>
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
    <h2>Total Guests on a Specific Day</h2>

    <form method="get" action="${pageContext.request.contextPath}/guest-count">
        <table style="width:auto; border:none;">
            <tr>
                <td style="border:none; padding:4px 8px 4px 0;">
                    <label for="date"><strong>Date</strong></label><br>
                    <input type="date" id="date" name="date"
                           value="<%= queryDate != null ? queryDate : "" %>" required>
                </td>
                <td style="border:none; padding:20px 0 0 8px;">
                    <input type="submit" value="Check">
                </td>
            </tr>
        </table>
    </form>

    <% if (guestCount != null) { %>
        <div class="info" style="margin-top:20px; font-size:16px;">
            On <strong><%= queryDate %></strong>, there are
            <strong><%= guestCount %></strong> guest(s) staying in the hotel.
        </div>
    <% } %>
</div>
</body>
</html>

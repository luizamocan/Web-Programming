<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hotel.model.User, com.hotel.model.HotelRoom, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<HotelRoom> rooms  = (List<HotelRoom>) request.getAttribute("rooms");
    List<Integer>   prices = (List<Integer>)   request.getAttribute("prices");
    String checkIn  = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    String errorParam = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Rooms – Hotel Reservation</title>
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
    <h2>Search Available Rooms</h2>

    <%-- Error messages --%>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error">${error}</div>
    <% } %>
    <% if ("overlap".equals(errorParam)) { %>
        <div class="error">You already have a reservation that overlaps with the selected dates. Please choose different dates.</div>
    <% } else if ("daterange".equals(errorParam)) { %>
        <div class="error">Check-out date must be after check-in date.</div>
    <% } else if ("capacity".equals(errorParam)) { %>
        <div class="error">Number of guests exceeds the room capacity.</div>
    <% } else if ("db".equals(errorParam)) { %>
        <div class="error">A database error occurred. Please try again.</div>
    <% } else if ("notfound".equals(errorParam)) { %>
        <div class="error">Room not found.</div>
    <% } %>

    <%-- Search form --%>
    <form method="get" action="${pageContext.request.contextPath}/available-rooms">
        <table style="width:auto; border:none;">
            <tr>
                <td style="border:none; padding:4px 8px 4px 0;">
                    <label for="checkIn"><strong>Check-in</strong></label><br>
                    <input type="date" id="checkIn" name="checkIn"
                           value="<%= checkIn != null ? checkIn : "" %>" required>
                </td>
                <td style="border:none; padding:4px 8px;">
                    <label for="checkOut"><strong>Check-out</strong></label><br>
                    <input type="date" id="checkOut" name="checkOut"
                           value="<%= checkOut != null ? checkOut : "" %>" required>
                </td>
                <td style="border:none; padding:20px 0 0 8px;">
                    <input type="submit" value="Search">
                </td>
            </tr>
        </table>
    </form>

    <%-- Results --%>
    <% if (rooms != null) { %>
        <% if (rooms.isEmpty()) { %>
            <div class="info" style="margin-top:16px;">No rooms available for the selected period.</div>
        <% } else { %>
            <p style="margin-top:16px;"><strong><%= rooms.size() %></strong> room(s) available from
               <strong><%= checkIn %></strong> to <strong><%= checkOut %></strong>.</p>

            <table>
                <thead>
                    <tr>
                        <th>Room No.</th>
                        <th>Capacity</th>
                        <th>Base Price (€/stay)</th>
                        <th>Current Price (€/stay)</th>
                        <th>Guests</th>
                        <th>Reserve</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (int i = 0; i < rooms.size(); i++) {
                           HotelRoom r = rooms.get(i);
                           int dynamicPrice = prices.get(i);
                    %>
                    <tr>
                        <td><%= r.getRoomNumber() %></td>
                        <td><%= r.getCapacity() %></td>
                        <td><%= r.getBasePrice() %></td>
                        <td>
                            <strong><%= dynamicPrice %></strong>
                            <% if (dynamicPrice > r.getBasePrice()) { %>
                                <span style="color:#c0392b; font-size:12px;">
                                    (+<%= dynamicPrice - r.getBasePrice() %>)
                                </span>
                            <% } %>
                        </td>
                        <td>
                            <%-- Inline form to reserve this specific room --%>
                            <form method="post" action="${pageContext.request.contextPath}/reserve"
                                  style="display:inline;">
                                <input type="hidden" name="roomId"   value="<%= r.getId() %>">
                                <input type="hidden" name="checkIn"  value="<%= checkIn %>">
                                <input type="hidden" name="checkOut" value="<%= checkOut %>">
                                <input type="number" name="numberOfGuests" min="1"
                                       max="<%= r.getCapacity() %>"
                                       value="1" style="width:50px;" required>
                        </td>
                        <td>
                                <button type="submit">Reserve</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    <% } %>
</div>
</body>
</html>

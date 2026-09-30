<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // If already logged in, go straight to the dashboard
    if (session.getAttribute("author") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    response.sendRedirect("login.jsp");
%>

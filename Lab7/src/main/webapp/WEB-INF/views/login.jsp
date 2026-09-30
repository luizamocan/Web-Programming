<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | URL Collection</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css">
</head>
<body>
<main class="auth-panel">
    <h1>URL Collection</h1>
    <p class="muted">Sign in to manage your saved URLs.</p>

    <c:if test="${not empty error}">
        <p class="alert"><c:out value="${error}"/></p>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login" class="form-stack">
        <label>
            Username
            <input type="text" name="username" minlength="3" maxlength="40" required autofocus>
        </label>
        <label>
            Password
            <input type="password" name="password" minlength="3" maxlength="80" required>
        </label>
        <button type="submit">Login</button>
    </form>

    <a href="${pageContext.request.contextPath}/top">Continue as guest</a>
</main>
</body>
</html>

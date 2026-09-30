<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Popular URLs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css">
</head>
<body>
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/top">URL Collection</a>
    <nav>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/urls">My URLs</a>
                <form method="post" action="${pageContext.request.contextPath}/logout" class="inline">
                    <button type="submit" class="link-button">Logout</button>
                </form>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<main class="container">
    <section class="section-heading">
        <div>
            <h1>Most popular URLs</h1>
            <p class="muted">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">Showing the top <c:out value="${limit}"/> URLs.</c:when>
                    <c:otherwise>Guests can see the top 10 URLs.</c:otherwise>
                </c:choose>
            </p>
        </div>
        <c:if test="${not empty sessionScope.user}">
            <form method="get" action="${pageContext.request.contextPath}/top" class="limit-form">
                <label>
                    Show top
                    <input type="number" name="limit" min="1" max="50" value="${limit}" required>
                </label>
                <button type="submit">Apply</button>
            </form>
        </c:if>
    </section>

    <c:if test="${not empty limitError}">
        <p class="alert"><c:out value="${limitError}"/></p>
    </c:if>

    <div class="list">
        <c:forEach var="item" items="${popularUrls}" varStatus="status">
            <article class="row">
                <span class="rank">${status.index + 1}</span>
                <a href="${fn:escapeXml(item.url)}" target="_blank" rel="noopener noreferrer"><c:out value="${item.url}"/></a>
                <span class="badge"><c:out value="${item.saves}"/> saves</span>
            </article>
        </c:forEach>
        <c:if test="${empty popularUrls}">
            <p class="empty">No URLs have been saved yet.</p>
        </c:if>
    </div>
</main>
</body>
</html>

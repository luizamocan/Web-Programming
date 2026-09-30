 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My URLs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css">
</head>
<body>
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/urls">URL Collection</a>
    <nav>
        <a href="${pageContext.request.contextPath}/top">Popular URLs</a>
        <form method="post" action="${pageContext.request.contextPath}/logout" class="inline">
            <button type="submit" class="link-button">Logout <c:out value="${sessionScope.user.username}"/></button>
        </form>
    </nav>
</header>

<main class="container grid">
    <section>
        <h1>My URLs</h1>
        <p class="muted">Select Edit or Delete from a saved item. IDs stay hidden in the form actions.</p>

        <div class="list">
            <c:forEach var="item" items="${urls}">
                <article class="row manage-row">
                    <div>
                        <strong><c:out value="${item.title}"/></strong>
                        <a href="${fn:escapeXml(item.url)}" target="_blank" rel="noopener noreferrer"><c:out value="${item.url}"/></a>
                    </div>
                    <div class="actions">
                        <a class="button secondary" href="${pageContext.request.contextPath}/url/edit?id=${item.id}">Edit</a>
                        <form method="post"
                              action="${pageContext.request.contextPath}/url/delete"
                              onsubmit="return confirm('Delete this URL from your collection?');">
                            <input type="hidden" name="id" value="${item.id}">
                            <button type="submit" class="danger">Delete</button>
                        </form>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty urls}">
                <p class="empty">Your collection is empty.</p>
            </c:if>
        </div>
    </section>

    <aside class="panel">
        <h2>
            <c:choose>
                <c:when test="${not empty editing}">Edit URL</c:when>
                <c:otherwise>Add URL</c:otherwise>
            </c:choose>
        </h2>

        <c:if test="${not empty error}">
            <p class="alert"><c:out value="${error}"/></p>
        </c:if>

        <form method="post"
              action="${pageContext.request.contextPath}${not empty editing ? '/url/edit' : '/url/add'}"
              class="form-stack">
            <c:if test="${not empty editing}">
                <input type="hidden" name="id" value="${editing.id}">
            </c:if>
            <label>
                Title
                <input type="text"
                       name="title"
                       minlength="2"
                       maxlength="80"
                       value="${fn:escapeXml(editing.title)}"
                       required>
            </label>
            <label>
                URL
                <input type="url"
                       name="url"
                       maxlength="250"
                       placeholder="https://example.com"
                       value="${fn:escapeXml(editing.url)}"
                       required>
            </label>
            <div class="actions">
                <button type="submit">
                    <c:choose>
                        <c:when test="${not empty editing}">Save</c:when>
                        <c:otherwise>Add</c:otherwise>
                    </c:choose>
                </button>
                <c:if test="${not empty editing}">
                    <a class="button secondary"
                       href="${pageContext.request.contextPath}/urls"
                       onclick="return confirm('Cancel editing this URL?');">Cancel</a>
                </c:if>
            </div>
        </form>
    </aside>
</main>
</body>
</html>

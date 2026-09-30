<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Author, model.Document, service.AuthorService" %>
<%
    Author author = (Author) session.getAttribute("author");
    if (author == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    AuthorService svc = new AuthorService();
    Document topDoc = svc.getDocumentWithMostAuthors();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Most-Authored Document – Author Portal</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: #e2e8f0;
            padding: 40px 20px;
            display: flex;
            align-items: flex-start;
            justify-content: center;
        }

        .container { width: 580px; animation: fadeUp .45s ease both; }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .back { display:inline-block; color:#a78bfa; text-decoration:none;
                font-size:.85rem; margin-bottom:22px; transition:opacity .2s; }
        .back:hover { opacity:.7; }

        h1 {
            font-size: 1.7rem; font-weight: 700;
            background: linear-gradient(90deg,#fbbf24,#f87171);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            margin-bottom: 6px;
        }
        .subtitle { color:#94a3b8; font-size:.88rem; margin-bottom:32px; }

        .trophy-card {
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(251,191,36,.3);
            border-radius: 18px;
            padding: 36px 32px;
            text-align: center;
        }
        .trophy-card .t-icon { font-size: 3.5rem; display:block; margin-bottom:16px; }
        .trophy-card .doc-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #fbbf24;
            margin-bottom: 8px;
        }
        .trophy-card .doc-id {
            font-size: .8rem;
            color: #64748b;
            margin-bottom: 18px;
        }
        .trophy-card .doc-content {
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            padding: 16px 20px;
            font-size: .9rem;
            line-height: 1.6;
            color: #cbd5e1;
            text-align: left;
        }

        .none {
            text-align: center; padding: 60px 20px; color: #4b5563;
        }
        .none .e-icon { font-size: 3rem; display:block; margin-bottom:12px; }
    </style>
</head>
<body>
<div class="container">
    <a class="back" href="dashboard.jsp">← Back to Dashboard</a>
    <h1>🏆 Most-Authored Document</h1>
    <p class="subtitle">The document referenced by the greatest number of authors.</p>

    <% if (topDoc == null) { %>
    <div class="none">
        <span class="e-icon">📭</span>
        No documents found in the database.
    </div>
    <% } else { %>
    <div class="trophy-card">
        <span class="t-icon">🥇</span>
        <div class="doc-title"><%= topDoc.getName() %></div>
        <div class="doc-id">Document ID: <%= topDoc.getId() %></div>
        <div class="doc-content"><%= topDoc.getContent() %></div>
    </div>
    <% } %>
</div>
</body>
</html>

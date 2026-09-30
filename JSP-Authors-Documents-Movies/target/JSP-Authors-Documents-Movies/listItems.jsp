<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Author, model.Document, model.Movie, service.AuthorService, java.util.List" %>
<%
    Author author = (Author) session.getAttribute("author");
    if (author == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    AuthorService svc = new AuthorService();
    List<Document> docs   = svc.getDocumentsForAuthor(author);
    List<Movie>    movies = svc.getMoviesForAuthor(author);
    int maxLen = Math.max(docs.size(), movies.size());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Documents &amp; Movies – Author Portal</title>
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
        }

        .container { max-width: 680px; margin: 0 auto; animation: fadeUp .45s ease both; }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .back { display:inline-block; color:#a78bfa; text-decoration:none;
                font-size:.85rem; margin-bottom:22px; transition:opacity .2s; }
        .back:hover { opacity:.7; }

        h1 {
            font-size: 1.7rem; font-weight: 700;
            background: linear-gradient(90deg,#a78bfa,#60a5fa);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            margin-bottom: 6px;
        }
        .subtitle { color:#94a3b8; font-size:.88rem; margin-bottom:32px; }

        .item-card {
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 14px;
            padding: 20px 24px;
            margin-bottom: 14px;
            display: flex;
            align-items: flex-start;
            gap: 16px;
            animation: fadeUp .4s ease both;
        }
        .item-card.doc  { border-left: 4px solid #a78bfa; }
        .item-card.movie { border-left: 4px solid #34d399; }

        .item-icon { font-size: 1.7rem; flex-shrink: 0; margin-top: 2px; }

        .item-body h2 {
            font-size: 1rem; font-weight: 600; margin-bottom: 4px; color: #e2e8f0;
        }
        .item-body .meta {
            font-size: .78rem; color: #64748b; margin-bottom: 6px;
        }
        .item-body p {
            font-size: .88rem; color: #94a3b8; line-height: 1.55;
        }

        .badge {
            display: inline-block;
            font-size: .68rem;
            font-weight: 700;
            letter-spacing: .07em;
            text-transform: uppercase;
            padding: 3px 8px;
            border-radius: 99px;
            margin-bottom: 6px;
        }
        .badge-doc   { background: rgba(167,139,250,.2); color: #a78bfa; }
        .badge-movie { background: rgba(52,211,153,.2);  color: #34d399; }

        .empty {
            text-align: center; padding: 60px 20px; color: #4b5563;
        }
        .empty .e-icon { font-size: 3rem; display:block; margin-bottom:12px; }
    </style>
</head>
<body>
<div class="container">
    <a class="back" href="dashboard.jsp">← Back to Dashboard</a>
    <h1>📋 My Documents &amp; Movies</h1>
    <p class="subtitle">Displayed interleaved: document → movie → document → movie…</p>

    <% if (maxLen == 0) { %>
    <div class="empty">
        <span class="e-icon">📭</span>
        You haven't authored any documents or movies yet.
    </div>
    <% } else {
        for (int i = 0; i < maxLen; i++) {
            // ── Document slot ─────────────────────────────────────────────
            if (i < docs.size()) {
                Document d = docs.get(i);
    %>
    <div class="item-card doc">
        <div class="item-icon">📄</div>
        <div class="item-body">
            <span class="badge badge-doc">Document</span>
            <h2><%= d.getName() %></h2>
            <div class="meta">ID: <%= d.getId() %></div>
            <p><%= d.getContent() %></p>
        </div>
    </div>
    <%      }
            // ── Movie slot ────────────────────────────────────────────────
            if (i < movies.size()) {
                Movie m = movies.get(i);
    %>
    <div class="item-card movie">
        <div class="item-icon">🎬</div>
        <div class="item-body">
            <span class="badge badge-movie">Movie</span>
            <h2><%= m.getTitle() %></h2>
            <div class="meta">ID: <%= m.getId() %> &nbsp;·&nbsp; Duration: <%= m.getDuration() %> min</div>
        </div>
    </div>
    <%      }
        }
    } %>
</div>
</body>
</html>

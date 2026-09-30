<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Author, model.Movie, service.AuthorService, java.util.List" %>
<%
    Author author = (Author) session.getAttribute("author");
    if (author == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    AuthorService svc = new AuthorService();
    List<Movie> movies = svc.getMoviesForAuthor(author);

    String success = request.getParameter("success");
    String error   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Movie – Author Portal</title>
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

        .container { max-width: 620px; margin: 0 auto; animation: fadeUp .45s ease both; }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .back { display:inline-block; color:#a78bfa; text-decoration:none;
                font-size:.85rem; margin-bottom:22px; transition:opacity .2s; }
        .back:hover { opacity:.7; }

        h1 {
            font-size: 1.7rem; font-weight: 700;
            background: linear-gradient(90deg,#f87171,#fbbf24);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            margin-bottom: 6px;
        }
        .subtitle { color:#94a3b8; font-size:.88rem; margin-bottom:28px; }

        .alert-success {
            background: rgba(16,185,129,.15);
            border: 1px solid rgba(16,185,129,.4);
            color: #6ee7b7;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 20px;
            font-size: .87rem;
        }
        .alert-error {
            background: rgba(239,68,68,.15);
            border: 1px solid rgba(239,68,68,.4);
            color: #fca5a5;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 20px;
            font-size: .87rem;
        }

        /* Movie list */
        .movie-card {
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.1);
            border-left: 4px solid #f87171;
            border-radius: 14px;
            padding: 18px 22px;
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }
        .movie-info h2 { font-size: .97rem; font-weight: 600; margin-bottom: 3px; }
        .movie-info .meta { font-size: .78rem; color: #64748b; }

        .btn-delete {
            padding: 8px 18px;
            border: none;
            border-radius: 8px;
            background: rgba(239,68,68,.2);
            color: #f87171;
            font-family: inherit;
            font-size: .85rem;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid rgba(239,68,68,.35);
            transition: background .2s, transform .15s;
            flex-shrink: 0;
        }
        .btn-delete:hover  { background: rgba(239,68,68,.35); }
        .btn-delete:active { transform: scale(.97); }

        .empty {
            text-align: center; padding: 60px 20px; color: #4b5563;
        }
        .empty .e-icon { font-size: 3rem; display:block; margin-bottom:12px; }
    </style>
</head>
<body>
<div class="container">
    <a class="back" href="dashboard.jsp">← Back to Dashboard</a>
    <h1>🗑️ Delete a Movie</h1>
    <p class="subtitle">Select one of your movies to remove it from the system.</p>

    <% if ("1".equals(success)) { %>
    <div class="alert-success">✓ &nbsp;Movie deleted and your profile updated successfully.</div>
    <% } else if ("notOwned".equals(error)) { %>
    <div class="alert-error">✗ &nbsp;You do not own that movie.</div>
    <% } else if ("invalidId".equals(error)) { %>
    <div class="alert-error">✗ &nbsp;Invalid movie ID.</div>
    <% } %>

    <% if (movies.isEmpty()) { %>
    <div class="empty">
        <span class="e-icon">🎬</span>
        You have no movies to delete.
    </div>
    <% } else {
        for (Movie m : movies) { %>
    <div class="movie-card" id="movie-row-<%= m.getId() %>">
        <div class="movie-info">
            <h2><%= m.getTitle() %></h2>
            <div class="meta">ID: <%= m.getId() %> &nbsp;·&nbsp; Duration: <%= m.getDuration() %> min</div>
        </div>
        <form method="post" action="deleteMovie"
              onsubmit="return confirm('Delete \"<%= m.getTitle() %>\"?');">
            <input type="hidden" name="movieId" value="<%= m.getId() %>">
            <button type="submit" class="btn-delete"
                    id="del-movie-<%= m.getId() %>">Delete</button>
        </form>
    </div>
    <%  }
    } %>
</div>
</body>
</html>

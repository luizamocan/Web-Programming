<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Author" %>
<%
    Author author = (Author) session.getAttribute("author");
    if (author == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Author Portal</title>
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

        .container {
            max-width: 680px;
            margin: 0 auto;
            animation: fadeUp .5s ease both;
        }

        @keyframes fadeUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }

        header {
            text-align: center;
            margin-bottom: 40px;
        }
        header .icon { font-size: 2.8rem; display: block; margin-bottom: 8px; }
        header h1 {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(90deg, #a78bfa, #60a5fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        header p { color: #94a3b8; margin-top: 6px; font-size: .9rem; }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .card {
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 16px;
            padding: 28px 24px;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 10px;
            transition: transform .2s, box-shadow .2s, border-color .2s;
            cursor: pointer;
        }
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 40px rgba(0,0,0,.35);
            border-color: rgba(167,139,250,.5);
        }

        .card .c-icon { font-size: 2rem; }
        .card .c-title {
            font-size: 1rem;
            font-weight: 600;
            color: #e2e8f0;
        }
        .card .c-desc {
            font-size: .8rem;
            color: #94a3b8;
            line-height: 1.5;
        }

        .logout-wrap {
            margin-top: 32px;
            text-align: center;
        }
        .logout-wrap a {
            color: #f87171;
            text-decoration: none;
            font-size: .88rem;
            font-weight: 500;
            transition: opacity .2s;
        }
        .logout-wrap a:hover { opacity: .75; }
    </style>
</head>
<body>
<div class="container">
    <header>
        <span class="icon">📚</span>
        <h1>Welcome, <%= author.getName() %>!</h1>
        <p>What would you like to do today?</p>
    </header>

    <div class="grid">
        <a class="card" href="addDocument.jsp" id="nav-add-doc">
            <span class="c-icon">📝</span>
            <span class="c-title">Add Document</span>
            <span class="c-desc">Create a new document and link it to your profile.</span>
        </a>

        <a class="card" href="listItems.jsp" id="nav-list">
            <span class="c-icon">📋</span>
            <span class="c-title">My Documents &amp; Movies</span>
            <span class="c-desc">View all your documents and movies interleaved.</span>
        </a>

        <a class="card" href="largestDocument.jsp" id="nav-largest">
            <span class="c-icon">🏆</span>
            <span class="c-title">Most-Authored Document</span>
            <span class="c-desc">Find the document with the highest number of authors.</span>
        </a>

        <a class="card" href="deleteMovie.jsp" id="nav-delete-movie">
            <span class="c-icon">🗑️</span>
            <span class="c-title">Delete a Movie</span>
            <span class="c-desc">Remove one of your movies from the system.</span>
        </a>
    </div>

    <div class="logout-wrap">
        <a href="logout.jsp" id="nav-logout">← Sign out</a>
    </div>
</div>
</body>
</html>
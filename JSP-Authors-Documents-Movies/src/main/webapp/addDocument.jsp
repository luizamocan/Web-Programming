<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Author" %>
<%
    Author author = (Author) session.getAttribute("author");
    if (author == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String success = request.getParameter("success");
    String docId   = request.getParameter("docId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Document – Author Portal</title>
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

        .container {
            width: 540px;
            animation: fadeUp .45s ease both;
        }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .back { display:inline-block; color:#a78bfa; text-decoration:none;
                font-size:.85rem; margin-bottom:22px; transition:opacity .2s; }
        .back:hover { opacity:.7; }

        h1 {
            font-size: 1.7rem;
            font-weight: 700;
            background: linear-gradient(90deg, #a78bfa, #60a5fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 6px;
        }
        .subtitle { color:#94a3b8; font-size:.88rem; margin-bottom:28px; }

        .alert-success {
            background: rgba(16,185,129,.15);
            border: 1px solid rgba(16,185,129,.4);
            color: #6ee7b7;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 22px;
            font-size: .87rem;
        }

        .card {
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 16px;
            padding: 32px 28px;
        }

        label {
            display: block;
            font-size: .78rem;
            font-weight: 600;
            letter-spacing: .05em;
            text-transform: uppercase;
            color: #94a3b8;
            margin-bottom: 6px;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 12px 16px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.12);
            background: rgba(255,255,255,0.05);
            color: #e2e8f0;
            font-family: inherit;
            font-size: .92rem;
            outline: none;
            transition: border-color .25s, box-shadow .25s;
            margin-bottom: 20px;
            resize: vertical;
        }
        input[type="text"]:focus, textarea:focus {
            border-color: #a78bfa;
            box-shadow: 0 0 0 3px rgba(167,139,250,.2);
        }
        input[type="text"]::placeholder,
        textarea::placeholder { color: #4b5563; }
        textarea { min-height: 120px; }

        button[type="submit"] {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(90deg, #7c3aed, #2563eb);
            color: #fff;
            font-family: inherit;
            font-size: .97rem;
            font-weight: 600;
            cursor: pointer;
            transition: opacity .25s, transform .15s;
        }
        button[type="submit"]:hover  { opacity: .88; }
        button[type="submit"]:active { transform: scale(.98); }
    </style>
</head>
<body>
<div class="container">
    <a class="back" href="dashboard.jsp">← Back to Dashboard</a>
    <h1>📝 Add a Document</h1>
    <p class="subtitle">The document will be linked to your author profile automatically.</p>

    <% if ("1".equals(success)) { %>
    <div class="alert-success">
        ✓ &nbsp;Document #<%= docId %> added successfully and linked to your profile!
    </div>
    <% } %>

    <div class="card">
        <form method="post" action="addDocument">
            <label for="docName">Document Title</label>
            <input type="text" id="docName" name="docName"
                   placeholder="e.g. Advanced Algorithms" required>

            <label for="contents">Contents</label>
            <textarea id="contents" name="contents"
                      placeholder="Write the document contents here…" required></textarea>

            <button type="submit" id="btn-add-doc">Add Document</button>
        </form>
    </div>
</div>
</body>
</html>

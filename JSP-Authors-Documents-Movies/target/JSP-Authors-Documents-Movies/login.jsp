<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – Author Portal</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: #e2e8f0;
        }

        .card {
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 20px;
            padding: 48px 44px;
            width: 420px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.4);
            animation: fadeUp .5s ease both;
        }

        @keyframes fadeUp {
            from { opacity:0; transform:translateY(24px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .logo {
            text-align: center;
            margin-bottom: 28px;
        }
        .logo .icon {
            font-size: 3rem;
            display: block;
            margin-bottom: 8px;
        }
        h1 {
            font-size: 1.7rem;
            font-weight: 700;
            text-align: center;
            background: linear-gradient(90deg, #a78bfa, #60a5fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .subtitle {
            text-align: center;
            color: #94a3b8;
            font-size: .85rem;
            margin-top: 6px;
            margin-bottom: 32px;
        }

        .alert-error {
            background: rgba(239,68,68,.15);
            border: 1px solid rgba(239,68,68,.4);
            color: #fca5a5;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 22px;
            font-size: .87rem;
            text-align: center;
        }

        label {
            display: block;
            font-size: .8rem;
            font-weight: 600;
            letter-spacing: .05em;
            text-transform: uppercase;
            color: #94a3b8;
            margin-bottom: 6px;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px 16px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.15);
            background: rgba(255,255,255,0.06);
            color: #e2e8f0;
            font-family: inherit;
            font-size: .95rem;
            outline: none;
            transition: border-color .25s, box-shadow .25s;
            margin-bottom: 20px;
        }
        input[type="text"]:focus {
            border-color: #a78bfa;
            box-shadow: 0 0 0 3px rgba(167,139,250,.25);
        }
        input[type="text"]::placeholder { color: #4b5563; }

        .hint {
            font-size: .75rem;
            color: #64748b;
            margin-top: -14px;
            margin-bottom: 20px;
        }

        button[type="submit"] {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(90deg, #7c3aed, #2563eb);
            color: #fff;
            font-family: inherit;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: opacity .25s, transform .15s;
            letter-spacing: .03em;
        }
        button[type="submit"]:hover  { opacity: .88; }
        button[type="submit"]:active { transform: scale(.98); }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <span class="icon">📚</span>
        <h1>Author Portal</h1>
        <p class="subtitle">Sign in to manage your documents &amp; movies</p>
    </div>

    <% if ("1".equals(request.getParameter("error"))) { %>
    <div class="alert-error">
        ✗ &nbsp;Invalid credentials. Please try again.
    </div>
    <% } %>

    <form method="post" action="login">
        <label for="name">Author Name</label>
        <input type="text" id="name" name="name"
               placeholder="e.g. Alice" required>

        <label for="itemIdentifier">Document / Movie Identifier</label>
        <input type="text" id="itemIdentifier" name="itemIdentifier"
               placeholder="e.g. 2 or Introduction to Java" required>
        <p class="hint">Enter the ID <em>or</em> name/title of a document or movie you authored.</p>

        <button type="submit">Sign In →</button>
    </form>
</div>
</body>
</html>
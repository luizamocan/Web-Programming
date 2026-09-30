<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Manager — Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #0d0f18;
            background-image:
                radial-gradient(ellipse at 20% 50%, rgba(99, 102, 241, 0.15) 0%, transparent 60%),
                radial-gradient(ellipse at 80% 20%, rgba(168, 85, 247, 0.12) 0%, transparent 50%);
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 48px 40px;
            backdrop-filter: blur(20px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(255,255,255,0.05) inset;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 32px;
        }

        .logo-icon {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .logo-text {
            font-size: 22px;
            font-weight: 700;
            color: #fff;
        }

        h1 {
            font-size: 26px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 8px;
        }

        .subtitle {
            color: rgba(255,255,255,0.5);
            font-size: 14px;
            margin-bottom: 32px;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: rgba(255,255,255,0.7);
            margin-bottom: 8px;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px 16px;
            background: rgba(255,255,255,0.07);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 10px;
            color: #fff;
            font-size: 15px;
            font-family: inherit;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input[type="text"]:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.25);
        }

        input[type="text"]::placeholder { color: rgba(255,255,255,0.25); }

        .error-msg {
            margin-top: 12px;
            padding: 10px 14px;
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 8px;
            color: #f87171;
            font-size: 13px;
        }

        button[type="submit"] {
            margin-top: 24px;
            width: 100%;
            padding: 13px;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            border: none;
            border-radius: 10px;
            color: #fff;
            font-size: 15px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.1s;
        }

        button[type="submit"]:hover { opacity: 0.9; transform: translateY(-1px); }
        button[type="submit"]:active { transform: translateY(0); }

        .hint {
            margin-top: 20px;
            text-align: center;
            font-size: 13px;
            color: rgba(255,255,255,0.35);
        }

        .hint span { color: rgba(255,255,255,0.6); font-weight: 500; }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="logo">
            <div class="logo-icon">📋</div>
            <div class="logo-text">TaskBoard</div>
        </div>
        <h1>Welcome back</h1>
        <p class="subtitle">Enter your username to access your board.</p>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="e.g. alice" autofocus required>
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
            <div class="error-msg"><%= error %></div>
            <% } %>
            <button type="submit" id="loginBtn">Sign In</button>
        </form>

        <p class="hint">Available users: <span>alice</span>, <span>bob</span>, <span>charlie</span></p>
    </div>
</body>
</html>

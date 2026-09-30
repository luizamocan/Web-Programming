<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.task.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskBoard — <%= currentUser.getUsername() %></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: #0d0f18;
            background-image:
                radial-gradient(ellipse at 10% 30%, rgba(99, 102, 241, 0.1) 0%, transparent 55%),
                radial-gradient(ellipse at 90% 70%, rgba(168, 85, 247, 0.08) 0%, transparent 50%);
            color: #e2e8f0;
        }

        header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 32px;
            background: rgba(255,255,255,0.03);
            border-bottom: 1px solid rgba(255,255,255,0.07);
            backdrop-filter: blur(12px);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .logo-text {
            font-size: 18px;
            font-weight: 700;
            color: #fff;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .move-counter {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(99, 102, 241, 0.15);
            border: 1px solid rgba(99, 102, 241, 0.3);
            border-radius: 20px;
            padding: 6px 14px;
            font-size: 13px;
            color: #a5b4fc;
            font-weight: 500;
        }

        .move-counter .count {
            font-size: 18px;
            font-weight: 700;
            color: #818cf8;
        }

        .user-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: rgba(255,255,255,0.6);
        }

        .avatar {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 600;
            color: #fff;
            text-transform: uppercase;
        }

        .logout-btn {
            padding: 7px 16px;
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.25);
            border-radius: 8px;
            color: #f87171;
            font-size: 13px;
            font-weight: 500;
            font-family: inherit;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.2s, border-color 0.2s;
        }

        .logout-btn:hover {
            background: rgba(239, 68, 68, 0.2);
            border-color: rgba(239, 68, 68, 0.45);
        }

        main {
            padding: 32px;
        }

        .board-title {
            font-size: 22px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 28px;
        }

        .board {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            align-items: start;
        }

        .column {
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px;
            padding: 20px;
            min-height: 480px;
        }

        .col-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
        }

        .col-title-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .col-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }

        .col-todo .col-dot    { background: #60a5fa; box-shadow: 0 0 8px rgba(96,165,250,0.6); }
        .col-inprog .col-dot  { background: #fbbf24; box-shadow: 0 0 8px rgba(251,191,36,0.6); }
        .col-done .col-dot    { background: #34d399; box-shadow: 0 0 8px rgba(52,211,153,0.6); }

        .col-title {
            font-size: 15px;
            font-weight: 600;
            color: #fff;
        }

        .col-count {
            font-size: 12px;
            font-weight: 600;
            padding: 2px 9px;
            border-radius: 12px;
        }

        .col-todo .col-count    { background: rgba(96,165,250,0.15);  color: #93c5fd; }
        .col-inprog .col-count  { background: rgba(251,191,36,0.15);  color: #fcd34d; }
        .col-done .col-count    { background: rgba(52,211,153,0.15);   color: #6ee7b7; }

        .task-list { display: flex; flex-direction: column; gap: 10px; }

        .task-card {
            position: relative;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 12px;
            padding: 14px 16px;
            cursor: default;
            transition: background 0.2s, border-color 0.2s, transform 0.15s;
        }

        .task-card:hover {
            background: rgba(255,255,255,0.08);
            border-color: rgba(255,255,255,0.15);
            transform: translateY(-2px);
        }

        .task-title {
            font-size: 14px;
            font-weight: 500;
            color: #e2e8f0;
            margin-bottom: 12px;
            line-height: 1.4;
        }

        .task-actions {
            display: flex;
            gap: 6px;
        }

        .move-btn {
            flex: 1;
            padding: 6px 10px;
            border: none;
            border-radius: 7px;
            font-size: 12px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: opacity 0.15s, transform 0.1s;
        }

        .move-btn:hover   { opacity: 0.85; transform: scale(1.02); }
        .move-btn:active  { transform: scale(0.98); }

        .btn-left {
            background: rgba(255,255,255,0.08);
            color: rgba(255,255,255,0.7);
            border: 1px solid rgba(255,255,255,0.1);
        }

        .btn-right-todo   { background: rgba(251,191,36,0.2);   color: #fbbf24; border: 1px solid rgba(251,191,36,0.3); }
        .btn-right-inprog { background: rgba(52,211,153,0.2);   color: #34d399; border: 1px solid rgba(52,211,153,0.3); }

        .tooltip-wrap {
            position: relative;
            margin-top: 10px;
        }

        .last-updated-by {
            font-size: 11px;
            color: rgba(255,255,255,0.35);
            display: flex;
            align-items: center;
            gap: 4px;
            cursor: help;
        }

        .last-updated-by:hover .tooltip-box {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }

        .tooltip-box {
            position: absolute;
            bottom: 100%;
            left: 0;
            margin-bottom: 6px;
            background: rgba(15, 17, 30, 0.95);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 8px;
            padding: 7px 12px;
            font-size: 12px;
            font-weight: 500;
            color: #c4b5fd;
            white-space: nowrap;
            opacity: 0;
            transform: translateY(4px);
            transition: opacity 0.2s, transform 0.2s;
            pointer-events: none;
            z-index: 10;
            box-shadow: 0 8px 24px rgba(0,0,0,0.4);
        }

        .empty-col {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            color: rgba(255,255,255,0.2);
            font-size: 13px;
            gap: 8px;
        }

        .empty-col span { font-size: 28px; }

        .realtime-dot {
            width: 8px;
            height: 8px;
            background: #34d399;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        .realtime-label {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: rgba(255,255,255,0.35);
        }

        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(52,211,153,0.4); }
            50%       { box-shadow: 0 0 0 6px rgba(52,211,153,0); }
        }
    </style>
</head>
<body>

<header>
    <div class="header-left">
        <div class="logo-icon">📋</div>
        <div class="logo-text">TaskBoard</div>
    </div>
    <div class="header-right">
        <div class="move-counter">
            <span>Tasks moved this session:</span>
            <span class="count" id="moveCountDisplay">${moveCount}</span>
        </div>
        <div class="user-badge">
            <div class="avatar"><%= currentUser.getUsername().charAt(0) %></div>
            <span><%= currentUser.getUsername() %></span>
        </div>
        <div class="realtime-label">
            <div class="realtime-dot"></div>
            <span>Live</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn" id="logoutBtn">Log out</a>
    </div>
</header>

<main>
    <div class="board-title">Task Board</div>
    <div class="board">

        <div class="column col-todo">
            <div class="col-header">
                <div class="col-title-wrap">
                    <div class="col-dot"></div>
                    <span class="col-title">To Do</span>
                </div>
                <span class="col-count">${todoTasks.size()}</span>
            </div>
            <div class="task-list" id="col-todo">
                <c:choose>
                    <c:when test="${empty todoTasks}">
                        <div class="empty-col"><span>✓</span>No tasks here</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${todoTasks}">
                            <div class="task-card" id="task-${task.id}">
                                <div class="task-title">${task.title}</div>
                                <div class="task-actions">
                                    <button class="move-btn btn-right-todo"
                                            id="moveToInProgress-${task.id}"
                                            onclick="moveTask(${task.id}, 'in_progress')">
                                        → In Progress
                                    </button>
                                </div>
                                <c:if test="${not empty task.assignedToUsername}">
                                    <div class="tooltip-wrap">
                                        <div class="last-updated-by">
                                            🕐 Moved by ${task.assignedToUsername}
                                            <div class="tooltip-box">Last updated by ${task.assignedToUsername}</div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="column col-inprog">
            <div class="col-header">
                <div class="col-title-wrap">
                    <div class="col-dot"></div>
                    <span class="col-title">In Progress</span>
                </div>
                <span class="col-count">${inProgressTasks.size()}</span>
            </div>
            <div class="task-list" id="col-inprogress">
                <c:choose>
                    <c:when test="${empty inProgressTasks}">
                        <div class="empty-col"><span>⚡</span>Nothing in progress</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${inProgressTasks}">
                            <div class="task-card" id="task-${task.id}">
                                <div class="task-title">${task.title}</div>
                                <div class="task-actions">
                                    <button class="move-btn btn-left"
                                            id="moveToTodo-${task.id}"
                                            onclick="moveTask(${task.id}, 'todo')">
                                        ← To Do
                                    </button>
                                    <button class="move-btn btn-right-inprog"
                                            id="moveToDone-${task.id}"
                                            onclick="moveTask(${task.id}, 'done')">
                                        → Done
                                    </button>
                                </div>
                                <c:if test="${not empty task.assignedToUsername}">
                                    <div class="tooltip-wrap">
                                        <div class="last-updated-by">
                                            🕐 Moved by ${task.assignedToUsername}
                                            <div class="tooltip-box">Last updated by ${task.assignedToUsername}</div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="column col-done">
            <div class="col-header">
                <div class="col-title-wrap">
                    <div class="col-dot"></div>
                    <span class="col-title">Done</span>
                </div>
                <span class="col-count">${doneTasks.size()}</span>
            </div>
            <div class="task-list" id="col-done">
                <c:choose>
                    <c:when test="${empty doneTasks}">
                        <div class="empty-col"><span>🏁</span>Nothing done yet</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="task" items="${doneTasks}">
                            <div class="task-card" id="task-${task.id}">
                                <div class="task-title">${task.title}</div>
                                <div class="task-actions">
                                    <button class="move-btn btn-left"
                                            id="moveToInProgressFromDone-${task.id}"
                                            onclick="moveTask(${task.id}, 'in_progress')">
                                        ← In Progress
                                    </button>
                                </div>
                                <c:if test="${not empty task.assignedToUsername}">
                                    <div class="tooltip-wrap">
                                        <div class="last-updated-by">
                                            🕐 Moved by ${task.assignedToUsername}
                                            <div class="tooltip-box">Last updated by ${task.assignedToUsername}</div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</main>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    function moveTask(taskId, newStatus) {
        fetch(contextPath + '/move', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'taskId=' + taskId + '&newStatus=' + newStatus
        }).catch(function() {});
    }

    const evtSource = new EventSource(contextPath + '/events');

    evtSource.onmessage = function(e) {
        if (e.data === 'update') {
            window.location.reload();
        }
    };

    evtSource.onerror = function() {
        evtSource.close();
        setTimeout(function() {
            window.location.reload();
        }, 3000);
    };
</script>

</body>
</html>

package com.task.servlet;

import com.task.dao.TaskDAO;
import com.task.dao.TaskLogDAO;
import com.task.model.Task;
import com.task.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/move")
public class MoveTaskServlet extends HttpServlet {

    private static final List<String> VALID_STATUSES = Arrays.asList("todo", "in_progress", "done");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User user = (User) session.getAttribute("user");

        int taskId;
        try {
            taskId = Integer.parseInt(req.getParameter("taskId"));
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String newStatus = req.getParameter("newStatus");
        if (newStatus == null || !VALID_STATUSES.contains(newStatus)) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        TaskDAO taskDAO = new TaskDAO();
        Task task = taskDAO.getTaskById(taskId);
        if (task == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String oldStatus = task.getStatus();
        if (oldStatus.equals(newStatus)) {
            resp.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        boolean updated = taskDAO.updateTaskStatus(taskId, newStatus, user.getId());
        if (updated) {
            TaskLogDAO taskLogDAO = new TaskLogDAO();
            taskLogDAO.insertLog(taskId, user.getId(), oldStatus, newStatus);

            Integer moveCount = (Integer) session.getAttribute("moveCount");
            session.setAttribute("moveCount", (moveCount != null ? moveCount : 0) + 1);

            TaskEventsServlet.broadcast("update");
        }

        resp.setStatus(HttpServletResponse.SC_OK);
    }
}

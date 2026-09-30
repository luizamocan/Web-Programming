package com.task.servlet;

import com.task.dao.TaskDAO;
import com.task.model.Task;
import com.task.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/board")
public class BoardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        TaskDAO taskDAO = new TaskDAO();
        List<Task> allTasks = taskDAO.getAllTasks();

        List<Task> todoTasks = new ArrayList<>();
        List<Task> inProgressTasks = new ArrayList<>();
        List<Task> doneTasks = new ArrayList<>();

        for (Task t : allTasks) {
            switch (t.getStatus()) {
                case "todo":        todoTasks.add(t);        break;
                case "in_progress": inProgressTasks.add(t);  break;
                case "done":        doneTasks.add(t);         break;
            }
        }

        req.setAttribute("todoTasks",       todoTasks);
        req.setAttribute("inProgressTasks", inProgressTasks);
        req.setAttribute("doneTasks",       doneTasks);

        Integer moveCount = (Integer) session.getAttribute("moveCount");
        req.setAttribute("moveCount", moveCount != null ? moveCount : 0);

        req.getRequestDispatcher("/board.jsp").forward(req, resp);
    }
}

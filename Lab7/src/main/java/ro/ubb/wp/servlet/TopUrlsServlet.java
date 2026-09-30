package ro.ubb.wp.servlet;

import ro.ubb.wp.db.Database;
import ro.ubb.wp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/top")
public class TopUrlsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        int limit = user == null ? 10 : readLimit(request);

        try {
            request.setAttribute("limit", limit);
            request.setAttribute("popularUrls", Database.topUrls(limit));
            request.getRequestDispatcher("/WEB-INF/views/top.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private int readLimit(HttpServletRequest request) {
        String rawLimit = request.getParameter("limit");
        Object sessionLimit = request.getSession().getAttribute("topLimit");
        int limit = sessionLimit instanceof Integer ? (Integer) sessionLimit : 10;
        if (rawLimit != null) {
            try {
                limit = Integer.parseInt(rawLimit);
            } catch (NumberFormatException ignored) {
                request.setAttribute("limitError", "The number of URLs must be numeric.");
            }
        }
        if (limit < 1 || limit > 50) {
            request.setAttribute("limitError", "Choose a number between 1 and 50.");
            limit = 10;
        }
        request.getSession().setAttribute("topLimit", limit);
        return limit;
    }
}

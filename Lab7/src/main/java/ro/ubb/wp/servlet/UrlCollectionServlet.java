package ro.ubb.wp.servlet;

import ro.ubb.wp.db.Database;
import ro.ubb.wp.model.UrlItem;
import ro.ubb.wp.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.sql.SQLException;

@WebServlet({"/urls", "/url/add", "/url/edit", "/url/delete"})
public class UrlCollectionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        try {
            String path = request.getServletPath();
            if ("/url/edit".equals(path)) {
                int id = parseId(request.getParameter("id"));
                UrlItem item = Database.findUserUrl(id, user.getId());
                if (item == null) {
                    response.sendRedirect(request.getContextPath() + "/urls?message=not-found");
                    return;
                }
                request.setAttribute("editing", item);
            }
            request.setAttribute("urls", Database.listUserUrls(user.getId()));
            request.getRequestDispatcher("/WEB-INF/views/urls.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        String path = request.getServletPath();

        try {
            if ("/url/add".equals(path)) {
                Validation validation = validate(request);
                if (!validation.valid) {
                    showFormWithError(request, response, user, validation.error);
                    return;
                }
                Database.addUrl(user.getId(), validation.title, validation.url);
            } else if ("/url/edit".equals(path)) {
                int id = parseId(request.getParameter("id"));
                Validation validation = validate(request);
                if (!validation.valid) {
                    request.setAttribute("editing", new UrlItem(id, validation.title, validation.url));
                    showFormWithError(request, response, user, validation.error);
                    return;
                }
                Database.updateUrl(id, user.getId(), validation.title, validation.url);
            } else if ("/url/delete".equals(path)) {
                int id = parseId(request.getParameter("id"));
                Database.deleteUrl(id, user.getId());
            }
            response.sendRedirect(request.getContextPath() + "/urls");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void showFormWithError(HttpServletRequest request, HttpServletResponse response, User user, String error)
            throws SQLException, ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("urls", Database.listUserUrls(user.getId()));
        request.getRequestDispatcher("/WEB-INF/views/urls.jsp").forward(request, response);
    }

    private User currentUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("user");
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private Validation validate(HttpServletRequest request) {
        String title = trim(request.getParameter("title"));
        String url = trim(request.getParameter("url"));

        if (title.length() < 2 || title.length() > 80) {
            return Validation.error("Title must contain between 2 and 80 characters.", title, url);
        }
        if (url.length() > 250) {
            return Validation.error("URL must not exceed 250 characters.", title, url);
        }
        try {
            URI uri = new URI(url);
            String scheme = uri.getScheme();
            if (!"http".equalsIgnoreCase(scheme) && !"https".equalsIgnoreCase(scheme)) {
                return Validation.error("URL must start with http:// or https://.", title, url);
            }
            if (uri.getHost() == null || uri.getHost().length() < 3) {
                return Validation.error("URL must include a valid host name.", title, url);
            }
        } catch (URISyntaxException e) {
            return Validation.error("URL format is invalid.", title, url);
        }
        return Validation.ok(title, url);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static class Validation {
        private final boolean valid;
        private final String error;
        private final String title;
        private final String url;

        private Validation(boolean valid, String error, String title, String url) {
            this.valid = valid;
            this.error = error;
            this.title = title;
            this.url = url;
        }

        private static Validation ok(String title, String url) {
            return new Validation(true, null, title, url);
        }

        private static Validation error(String error, String title, String url) {
            return new Validation(false, error, title, url);
        }
    }
}

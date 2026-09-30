package controller;

import model.Author;
import service.AuthorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthorService authorService = new AuthorService();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String name           = request.getParameter("name");
        String itemIdentifier = request.getParameter("itemIdentifier");

        try {
            Author author = authorService.login(name, itemIdentifier);

            if (author != null) {
                HttpSession session = request.getSession();
                session.setAttribute("author", author);
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
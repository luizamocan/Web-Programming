package controller;

import model.Author;
import service.AuthorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteMovie")
public class DeleteMovieServlet extends HttpServlet {

    private final AuthorService authorService = new AuthorService();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Author author = (session != null)
                ? (Author) session.getAttribute("author")
                : null;

        if (author == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String movieIdParam = request.getParameter("movieId");

        try {
            int movieId = Integer.parseInt(movieIdParam);
            boolean deleted = authorService.deleteMovie(author, movieId);

            // Persist the updated author object back in the session
            session.setAttribute("author", author);

            if (deleted) {
                response.sendRedirect("deleteMovie.jsp?success=1");
            } else {
                response.sendRedirect("deleteMovie.jsp?error=notOwned");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("deleteMovie.jsp?error=invalidId");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

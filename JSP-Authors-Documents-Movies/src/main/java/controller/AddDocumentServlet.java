package controller;

import model.Author;
import model.Document;
import service.AuthorService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/addDocument")
public class AddDocumentServlet extends HttpServlet {

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

        String docName  = request.getParameter("docName");
        String contents = request.getParameter("contents");

        try {
            Document newDoc = authorService.addDocument(author, docName, contents);
            // Reflect the updated author (with new documentList) back into the session
            session.setAttribute("author", author);
            response.sendRedirect("addDocument.jsp?success=1&docId=" + newDoc.getId());
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

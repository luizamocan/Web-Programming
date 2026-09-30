package service;

import dao.AuthorDAO;
import dao.DocumentDAO;
import dao.MovieDAO;
import model.Author;
import model.Document;
import model.Movie;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class AuthorService {

    private final AuthorDAO   authorDAO   = new AuthorDAO();
    private final DocumentDAO documentDAO = new DocumentDAO();
    private final MovieDAO    movieDAO    = new MovieDAO();

    // ─── Authentication ───────────────────────────────────────────────────────

    /**
     * Authenticate by author name + a document/movie identifier.
     * The identifier may be:
     *   - a numeric string → treated as an ID
     *   - a non-numeric string → treated as a document name or movie title
     */
    public Author login(String name, String itemIdentifier) throws Exception {
        Author author = authorDAO.findByName(name);
        if (author == null) return null;

        // Try numeric ID first
        try {
            int itemId = Integer.parseInt(itemIdentifier.trim());
            if (idInList(author.getDocumentList(), itemId)) return author;
            if (idInList(author.getMovieList(),    itemId)) return author;
        } catch (NumberFormatException ignored) {
            // Not a number – fall through to name-based lookup
        }

        // Try document name
        Document doc = documentDAO.findByName(itemIdentifier);
        if (doc != null && idInList(author.getDocumentList(), doc.getId())) {
            return author;
        }

        // Try movie title
        Movie movie = movieDAO.findByTitle(itemIdentifier);
        if (movie != null && idInList(author.getMovieList(), movie.getId())) {
            return author;
        }

        return null;
    }

    // ─── Document operations ──────────────────────────────────────────────────

    /**
     * Add a new Document and append its ID to the author's documentList.
     *
     * @return the newly created Document
     */
    public Document addDocument(Author author,
                                String docName,
                                String contents) throws Exception {
        int newId = documentDAO.insert(docName, contents);

        // Append the new ID to documentList
        String currentList = author.getDocumentList();
        String updatedList = (currentList == null || currentList.trim().isEmpty())
                ? String.valueOf(newId)
                : currentList.trim() + "," + newId;

        author.setDocumentList(updatedList);
        authorDAO.updateLists(author.getId(), updatedList, author.getMovieList());

        return documentDAO.findById(newId);
    }

    /** Fetch all documents that belong to this author. */
    public List<Document> getDocumentsForAuthor(Author author) throws Exception {
        List<Integer> ids = parseIds(author.getDocumentList());
        return documentDAO.findByIds(ids);
    }

    /** Fetch all movies that belong to this author. */
    public List<Movie> getMoviesForAuthor(Author author) throws Exception {
        List<Integer> ids = parseIds(author.getMovieList());
        return movieDAO.findByIds(ids);
    }

    // ─── Movie operations ─────────────────────────────────────────────────────

    /**
     * Delete a movie by ID and remove it from the author's movieList.
     * Only allowed if the movie is in the author's movieList.
     *
     * @return true if deletion succeeded; false if the movie is not owned by this author
     */
    public boolean deleteMovie(Author author, int movieId) throws Exception {
        if (!idInList(author.getMovieList(), movieId)) return false;

        // Remove from movieList
        List<Integer> ids = parseIds(author.getMovieList());
        ids.remove(Integer.valueOf(movieId));
        String updatedMovieList = ids.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));

        author.setMovieList(updatedMovieList);
        authorDAO.updateLists(author.getId(), author.getDocumentList(), updatedMovieList);

        movieDAO.deleteById(movieId);
        return true;
    }

    // ─── Document with most authors ───────────────────────────────────────────

    public Document getDocumentWithMostAuthors() throws Exception {
        return documentDAO.findMostAuthored();
    }

    // ─── Helpers ──────────────────────────────────────────────────────────────

    private boolean idInList(String list, int id) {
        if (list == null || list.trim().isEmpty()) return false;
        for (String token : list.split(",")) {
            token = token.trim();
            if (token.isEmpty()) continue;
            try {
                if (Integer.parseInt(token) == id) return true;
            } catch (NumberFormatException ignored) {}
        }
        return false;
    }

    private List<Integer> parseIds(String list) {
        List<Integer> ids = new ArrayList<>();
        if (list == null || list.trim().isEmpty()) return ids;
        for (String token : list.split(",")) {
            token = token.trim();
            if (token.isEmpty()) continue;
            try { ids.add(Integer.parseInt(token)); }
            catch (NumberFormatException ignored) {}
        }
        return ids;
    }
}
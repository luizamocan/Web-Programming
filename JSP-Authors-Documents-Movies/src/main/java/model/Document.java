package model;

public class Document {
    private int    id;
    private String name;
    private String contents;   // matches DB column "contents"

    public Document() {}
    public Document(int id, String name, String contents) {
        this.id       = id;
        this.name     = name;
        this.contents = contents;
    }

    public int    getId()       { return id; }
    public void   setId(int id) { this.id = id; }

    public String getName()         { return name; }
    public void   setName(String n) { this.name = n; }

    // Alias kept for JSP compatibility
    public String getContent()           { return contents; }
    public void   setContent(String c)   { this.contents = c; }

    public String getContents()          { return contents; }
    public void   setContents(String c)  { this.contents = c; }
}

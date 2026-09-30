package ro.ubb.wp.model;

public class PopularUrl {
    private final String url;
    private final int saves;

    public PopularUrl(String url, int saves) {
        this.url = url;
        this.saves = saves;
    }

    public String getUrl() {
        return url;
    }

    public int getSaves() {
        return saves;
    }
}

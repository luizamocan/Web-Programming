package ro.ubb.wp;

import ro.ubb.wp.db.Database;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppInitializer implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            String storageDir = System.getProperty("user.home");
            Database.init(storageDir);
        } catch (Exception e) {
            throw new IllegalStateException("Could not initialize database", e);
        }
    }
}

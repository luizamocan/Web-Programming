package com.task.servlet;

import javax.servlet.AsyncContext;
import javax.servlet.AsyncEvent;
import javax.servlet.AsyncListener;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.CopyOnWriteArrayList;

@WebServlet(urlPatterns = "/events", asyncSupported = true)
public class TaskEventsServlet extends HttpServlet {

    public static final CopyOnWriteArrayList<AsyncContext> clients = new CopyOnWriteArrayList<>();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/event-stream");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("Connection", "keep-alive");
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.flushBuffer();

        AsyncContext ac = req.startAsync();
        ac.setTimeout(0);
        clients.add(ac);

        ac.addListener(new AsyncListener() {
            @Override public void onComplete(AsyncEvent e) { clients.remove(ac); }
            @Override public void onTimeout(AsyncEvent e)  { clients.remove(ac); ac.complete(); }
            @Override public void onError(AsyncEvent e)    { clients.remove(ac); ac.complete(); }
            @Override public void onStartAsync(AsyncEvent e) {}
        });
    }

    public static void broadcast(String data) {
        for (AsyncContext ac : clients) {
            try {
                PrintWriter writer = ac.getResponse().getWriter();
                writer.write("data: " + data + "\n\n");
                writer.flush();
                if (writer.checkError()) {
                    clients.remove(ac);
                }
            } catch (Exception e) {
                clients.remove(ac);
            }
        }
    }
}

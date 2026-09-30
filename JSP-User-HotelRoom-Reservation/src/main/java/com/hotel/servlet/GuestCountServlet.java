package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/guest-count")
public class GuestCountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Auth guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String dateStr = req.getParameter("date");
        if (dateStr != null && !dateStr.isEmpty()) {
            Date date = Date.valueOf(dateStr);
            ReservationDAO dao = new ReservationDAO();
            int count = dao.getTotalGuestsOnDate(date);
            req.setAttribute("guestCount", count);
            req.setAttribute("queryDate", dateStr);
        }

        req.getRequestDispatcher("/guestCount.jsp").forward(req, resp);
    }
}

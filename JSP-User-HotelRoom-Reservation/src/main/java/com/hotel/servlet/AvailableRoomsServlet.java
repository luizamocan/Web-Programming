package com.hotel.servlet;

import com.hotel.dao.HotelRoomDAO;
import com.hotel.dao.ReservationDAO;
import com.hotel.model.HotelRoom;
import com.hotel.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/available-rooms")
public class AvailableRoomsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Auth guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String checkInStr  = req.getParameter("checkIn");
        String checkOutStr = req.getParameter("checkOut");

        if (checkInStr != null && !checkInStr.isEmpty()
                && checkOutStr != null && !checkOutStr.isEmpty()) {

            Date checkIn  = Date.valueOf(checkInStr);
            Date checkOut = Date.valueOf(checkOutStr);

            if (!checkOut.after(checkIn)) {
                req.setAttribute("error", "Check-out date must be after check-in date.");
                req.getRequestDispatcher("/availableRooms.jsp").forward(req, resp);
                return;
            }

            HotelRoomDAO   roomDAO        = new HotelRoomDAO();
            ReservationDAO reservationDAO = new ReservationDAO();

            List<HotelRoom> available = roomDAO.getAvailableRooms(checkIn, checkOut);

            // Attach dynamic price to each room (stored as a parallel list of ints)
            List<Integer> prices = new ArrayList<>();
            for (HotelRoom room : available) {
                prices.add(reservationDAO.calculatePrice(room.getBasePrice(), checkIn, checkOut));
            }

            req.setAttribute("rooms",     available);
            req.setAttribute("prices",    prices);
            req.setAttribute("checkIn",   checkInStr);
            req.setAttribute("checkOut",  checkOutStr);
        }

        req.getRequestDispatcher("/availableRooms.jsp").forward(req, resp);
    }
}

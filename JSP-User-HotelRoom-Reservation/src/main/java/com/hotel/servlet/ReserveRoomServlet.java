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

@WebServlet("/reserve")
public class ReserveRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Auth guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        int    roomId;
        Date   checkIn;
        Date   checkOut;
        int    numberOfGuests;

        try {
            roomId         = Integer.parseInt(req.getParameter("roomId"));
            checkIn        = Date.valueOf(req.getParameter("checkIn"));
            checkOut       = Date.valueOf(req.getParameter("checkOut"));
            numberOfGuests = Integer.parseInt(req.getParameter("numberOfGuests"));
        } catch (Exception e) {
            req.setAttribute("error", "Invalid reservation data. Please try again.");
            req.getRequestDispatcher("/availableRooms.jsp").forward(req, resp);
            return;
        }

        if (!checkOut.after(checkIn)) {
            req.setAttribute("error", "Check-out date must be after check-in date.");
            resp.sendRedirect(req.getContextPath() + "/available-rooms?checkIn="
                    + checkIn + "&checkOut=" + checkOut + "&error=daterange");
            return;
        }

        ReservationDAO reservationDAO = new ReservationDAO();

        // --- Prevent overlapping reservation for the same user ---
        if (reservationDAO.userHasOverlap(user.getId(), checkIn, checkOut)) {
            resp.sendRedirect(req.getContextPath()
                    + "/available-rooms?checkIn=" + checkIn
                    + "&checkOut=" + checkOut
                    + "&error=overlap");
            return;
        }

        // --- Validate guest count vs room capacity ---
        HotelRoomDAO roomDAO = new HotelRoomDAO();
        HotelRoom room = roomDAO.findById(roomId);
        if (room == null) {
            resp.sendRedirect(req.getContextPath() + "/available-rooms?error=notfound");
            return;
        }
        if (numberOfGuests < 1 || numberOfGuests > room.getCapacity()) {
            resp.sendRedirect(req.getContextPath()
                    + "/available-rooms?checkIn=" + checkIn
                    + "&checkOut=" + checkOut
                    + "&error=capacity");
            return;
        }

        // --- Calculate dynamic price ---
        int totalPrice = reservationDAO.calculatePrice(room.getBasePrice(), checkIn, checkOut);

        // --- Create reservation ---
        int newId = reservationDAO.createReservation(
                user.getId(), roomId, checkIn, checkOut, numberOfGuests, totalPrice);

        if (newId > 0) {
            resp.sendRedirect(req.getContextPath() + "/my-reservations?success=1");
        } else {
            resp.sendRedirect(req.getContextPath()
                    + "/available-rooms?checkIn=" + checkIn
                    + "&checkOut=" + checkOut
                    + "&error=db");
        }
    }
}

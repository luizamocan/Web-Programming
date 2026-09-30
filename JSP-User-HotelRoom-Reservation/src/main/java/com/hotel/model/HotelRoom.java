package com.hotel.model;

public class HotelRoom {
    private int id;
    private String roomNumber;
    private int capacity;
    private int basePrice;

    public HotelRoom() {}

    public HotelRoom(int id, String roomNumber, int capacity, int basePrice) {
        this.id = id;
        this.roomNumber = roomNumber;
        this.capacity = capacity;
        this.basePrice = basePrice;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public int getBasePrice() { return basePrice; }
    public void setBasePrice(int basePrice) { this.basePrice = basePrice; }
}

const express = require("express");
const router = express.Router();

const booking = require("../controllers/booking/bookingController");

router.post("/booking", (req, res) => booking.createBooking(req, res));
router.get("/booking/get-by-customer", (req, res) => booking.getBookingsByCustomer(req, res));
router.get("/booking/get-by-planner", (req, res) => booking.getBookingsByPlanner(req, res));
router.put("/booking/update/booking-status", (req, res) => booking.updateBookingStatus(req, res));
router.put("/booking/update/payment-status", (req, res) => booking.updateBookingPaymentStatus(req, res));

module.exports = router;

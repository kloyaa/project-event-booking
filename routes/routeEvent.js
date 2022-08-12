const express = require("express");
const router = express.Router();

const event = require("../controllers/event/eventController");


router.post("/event", (req, res) => event.createEvent(req, res));
router.get("/event/all", (req, res) => event.getAllEvents(req, res));
router.get("/event/get-by-planner", (req, res) => event.getEvents(req, res));
router.get("/event/category/get-by-planner", (req, res) => event.getEventsByPlanner(req, res));
router.put("/event", (req, res) => event.updateEvent(req, res));
router.delete("/event/:id", (req, res) => event.deleteEvent(req, res));

module.exports = router;

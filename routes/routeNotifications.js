const express = require("express");
const router = express.Router();

const message = require("../controllers/notification/messages");

router.post("/message", (req, res) => message.createMessage(req, res));
router.get("/message/all/:id", (req, res) => message.getAllMessages(req, res));
router.put("/message", (req, res) => message.updateMessage(req, res));
router.delete("/message/:id", (req, res) => message.deleteMessage(req, res));

module.exports = router;

const express = require("express");
const router = express.Router();

const user = require("../controllers/user/userController");

router.post("/user/register", (req, res) =>
    user.createUser(req, res)
);

router.post("/user/login", (req, res) =>
    user.loginUser(req, res)
);

router.put("/user/disable", (req, res) =>
    user.disableUser(req, res)
);
module.exports = router;

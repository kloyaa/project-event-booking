const express = require("express");
const router = express.Router();

const txnMonetization = require("../controllers/monetization/txnMonetizationController");

router.get("/monetization/txn", (req, res) => txnMonetization.getTxnMonetization(req, res));

module.exports = router;

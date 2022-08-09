const express = require("express");
const router = express.Router();

const billing = require("../controllers/billing/billingController");

router.post("/billing", (req, res) => billing.createBilling(req, res));
router.get("/billing/get-by-customer/:id", (req, res) => billing.getBillingsByCustomer(req, res));
router.get("/billing/get-by-planner/:id", (req, res) => billing.getBillingsByPlanner(req, res));

module.exports = router;

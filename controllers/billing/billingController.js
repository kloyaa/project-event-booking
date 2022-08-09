const Billing = require("../../models/billing");
const TxnMonetization = require("../../models/monetization");

const { v4: uuidv4 } = require("uuid");

const createBilling = async (req, res) => {
    try {
        const refNumber = uuidv4();;
        req.body.refNumber = refNumber;
        TxnMonetization({ refNumber: refNumber, amount: req.body.content.amount * 0.02 })
            .save()
            .then((value) => console.log(value))
            .catch((err) => console.log(err));

        return new Billing(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
};

const getBillingsByCustomer = async (req, res) => {
    try {
        const accountId = req.params.id;
        return Billing.find({ "header.customer.accountId": accountId })
            .sort({ "date.createdAt": "desc" }) // filter by date
            .select({ __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

const getBillingsByPlanner = async (req, res) => {
    try {
        const accountId = req.params.id;
        return Billing.find({ "header.planner.accountId": accountId })
            .sort({ "date.createdAt": "desc" }) // filter by date
            .select({ __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

module.exports = {
    createBilling,
    getBillingsByCustomer,
    getBillingsByPlanner
};
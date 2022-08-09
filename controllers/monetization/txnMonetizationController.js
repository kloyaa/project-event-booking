const TxnMonetization = require("../../models/monetization");

const getTxnMonetization = async (req, res) => {
    try {
        return TxnMonetization.find({})
            .sort({ "reatedAt": "desc" }) // filter by date
            .select({ __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

module.exports = { getTxnMonetization }
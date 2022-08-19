const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const TxnMonetizationSchema = new Schema({
    refNumber: {
        type: String,
        required: [true, "refNumber  is required"]
    },
    amount: {
        type: String,
        required: [true, "amount is required"]
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = TxnMonetization = mongoose.model("txn-monetizations", TxnMonetizationSchema);

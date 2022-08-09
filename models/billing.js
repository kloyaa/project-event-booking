const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const { paymentType } = require("../const/enum");

const BillingSchema = new Schema({
    refNumber: {
        type: String,
        required: [true, "refNumber  is required"]
    },
    header: {
        planner: {
            accountId: {
                type: mongoose.Types.ObjectId,
                required: [true, "accountId is required"]
            },
            name: {
                first: {
                    type: String,
                    required: [true, "firstName is required"],
                },
                last: {
                    type: String,
                    required: [true, "lastName is required"],
                },
            },
        },
        customer: {
            accountId: {
                type: mongoose.Types.ObjectId,
                required: [true, "accountId is required"]
            },
            name: {
                first: {
                    type: String,
                    required: [true, "firstName is required"],
                },
                last: {
                    type: String,
                    required: [true, "lastName is required"],
                },
            },
        },
    },
    content: {
        paymentMethod: {
            type: String,
            enum: paymentType,
            required: [true, "paymentMethod is required"]
        },
        paymentDetails: {
            type: Map,
            required: [true, "paymentDetails is required"],
        },
        amount: {
            type: Number,
            required: [true, "amount is required"]
        },
    },
    date: {
        createdAt: {
            type: Date,
            default: Date.now,
        },
        updatedAt: {
            type: Date,
        },
    },
})
module.exports = Billing = mongoose.model("billings", BillingSchema);

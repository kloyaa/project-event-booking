const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const { eventTypes } = require("../const/enum");

const EventSchema = new Schema({
    header: {
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
        address: {
            name: {
                type: String,
                required: [true, "name is required"],
            },
            coordinates: {
                latitude: {
                    type: String,
                    required: [true, "latitude is required"],
                },
                longitude: {
                    type: String,
                    required: [true, "longitude is required"],
                },
            },
        },
        contact: {
            email: {
                type: String,
            },
            number: {
                type: String,
            },
        },
    },
    event: {
        title: {
            type: String,
            required: [true, "title is required"]
        },
        details: {
            type: String,
            required: [true, "moreDetails is required"]
        },
        images: [],
        available: {
            type: Boolean,
            default: true
        },
        price: {
            from: {
                type: String,
                required: [true, "from is required"]
            },
            to: {
                type: String,
                required: [true, "to is required"]
            }
        },
        type: {
            type: String,
            enum: eventTypes,
            required: [true, "type is required"]
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
});

module.exports = Event = mongoose.model("events", EventSchema);

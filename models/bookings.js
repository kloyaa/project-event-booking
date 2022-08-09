const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const { eventTypes, eventStatus, paymentStatus, paymentType } = require("../const/enum");

const BookingSchema = new Schema({
    header: {
        customer: {
            accountId: {
                type: mongoose.Types.ObjectId,
                required: [true, "accountId is required"]
            },
            avatar: {
                type: String,
                required: [true, "avatar is required"],
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
        planner: {
            accountId: {
                type: mongoose.Types.ObjectId,
                required: [true, "accountId is required"]
            },
            avatar: {
                type: String,
                required: [true, "avatar is required"],
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
        }
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
    status: {
        type: String,
        enum: eventStatus,
        required: [true, "status is required"]

    },
    payment: {
        method: {
            type: String,
            enum: paymentType,
            required: [true, "method is required"]
        },
        status: {
            type: String,
            enum: paymentStatus,
            default: "unpaid",
        }
    },
    date: {
        event: {
            type: Date,
            required: [true, "event is required"]
        },
        createdAt: {
            type: Date,
            default: Date.now,
        },
        updatedAt: {
            type: Date,
        },
    },

});

module.exports = Booking = mongoose.model("bookings", BookingSchema);

const Booking = require("../../models/bookings");

const createBooking = async (req, res) => {
    try {
        return new Booking(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
};

const getBookingsByCustomer = async (req, res) => {
    try {
        const { accountId, status } = req.query;
        return Booking.find({ "header.customer.accountId": accountId, status })
            .sort({ "date.createdAt": "desc" }) // filter by date
            .select({ __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

const getBookingsByPlanner = async (req, res) => {
    try {
        const { accountId, status } = req.query;
        return Booking.find({ "header.planner.accountId": accountId, status })
            .sort({ "date.createdAt": "desc" }) // filter by date
            .select({ __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

const updateBookingStatus = async (req, res) => {
    try {
        const { _id, status } = req.body;
        Booking.findByIdAndUpdate(_id,
            {
                $set: {
                    status,
                    "date.updatedAt": Date.now(),
                },
            },
            { new: true, runValidators: true }
        )
            .then((value) => {
                if (!value)
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (e) {
        return res.status(400).json({ message: "Something went wrong" });
    }
};
const updateBookingPaymentStatus = async (req, res) => {
    try {
        const { _id, status } = req.body;
        Booking.findByIdAndUpdate(_id,
            {
                $set: {
                    "payment.status": status,
                    "date.updatedAt": Date.now(),
                },
            },
            { new: true, runValidators: true }
        )
            .then((value) => {
                if (!value)
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (e) {
        return res.status(400).json({ message: "Something went wrong" });
    }
};
module.exports = {
    createBooking,
    getBookingsByCustomer,
    getBookingsByPlanner,
    updateBookingStatus,
    updateBookingPaymentStatus

};
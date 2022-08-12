const Event = require("../../models/event");
const distanceBetween = require("../../helpers/distanceBetween");

const createEvent = async (req, res) => {
    try {
        return new Event(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
};

const getAllEvents = async (req, res) => {
    try {
        const { latitude, longitude, sortBy } = req.query;

        if (latitude == undefined || longitude == undefined)
            return res.status(400).json({ message: "exact coordinates is required" });

        return Event.find({ "event.available": true })
            .select({ __v: 0 }) // Do not return _id and __v
            .then((value) => {
                const result = value
                    .map((element, _) => {
                        const start = element.header.address.coordinates.latitude;
                        const end = element.header.address.coordinates.longitude;
                        const data = {
                            ...element._doc,
                            distance: distanceBetween(
                                start,
                                end,
                                latitude,
                                longitude,
                                "K"
                            ).toFixed(0) + "km",
                        };
                        return data;
                    })
                    .sort((a, b) => {
                        const value1 = parseFloat(a.distanceBetween);
                        const value2 = parseFloat(b.distanceBetween);
                        if (sortBy == "desc") return value2 - value1;
                        return value1 - value2;
                    });

                return res.status(200).json(result);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

const getEventsByPlanner = async (req, res) => {
    try {
        const { accountId, category } = req.query;
        if(category == undefined) {
              return Event.find({ "header.accountId": accountId, "event.type": category })
                 .select({ __v: 0 }) // Do not return _id and __v
                 .then((value) => res.status(200).json(value))
                 .catch((err) => res.status(400).json(err));
        }
        return Event.find({ "header.accountId": accountId, "event.type": category })
             .select({ __v: 0 }) // Do not return _id and __v
             .then((value) => res.status(200).json(value))
             .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}
const getEvents = async (req, res) => {
    try {
        const { accountId, latitude, longitude, sortBy } = req.query;

        if (latitude == undefined || longitude == undefined)
            return res.status(400).json({ message: "exact coordinates is required" });

        return Event.find({ "header.accountId": accountId })
            .select({ __v: 0 }) // Do not return _id and __v
            .then((value) => {
                const result = value
                    .map((element, _) => {
                        const start = element.header.address.coordinates.latitude;
                        const end = element.header.address.coordinates.longitude;
                        const data = {
                            ...element._doc,
                            distance: distanceBetween(
                                start,
                                end,
                                latitude,
                                longitude,
                                "K"
                            ).toFixed(0) + "km",
                        };
                        return data;
                    })
                    .sort((a, b) => {
                        const value1 = parseFloat(a.distanceBetween);
                        const value2 = parseFloat(b.distanceBetween);
                        if (sortBy == "desc") return value2 - value1;
                        return value1 - value2;
                    });

                return res.status(200).json(result);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

const updateEvent = async (req, res) => {
    try {
        const { _id, available } = req.body;
        Event.findByIdAndUpdate(_id,
            {
                $set: {
                    "event.available": available,
                    "date.updatedAt": Date.now(),
                },
            },
            { new: true }
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

const deleteEvent = async (req, res) => {
    try {
        const _id = req.params.id;
        return Event.findByIdAndDelete(_id)
            .then(() => res.status(200).json({ message: "success" }))
            .catch(() => res.status(400).json({ message: "failed" }));
    } catch (error) {
        console.log(error);
    }
};

module.exports = {
    createEvent,
    getEvents,
    getAllEvents,
    getEventsByPlanner,
    updateEvent,
    deleteEvent

};

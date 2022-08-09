const Message = require("../../models/messages");

const createMessage = async (req, res) => {
    try {
        return new Message(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
};

const getAllMessages = async (req, res) => {
    const accountId = req.params.id;
    try {
        return Message.find({ accountId })
            .sort({ createdAt: -1 }) // filter by date
            .select({ __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
};

const updateMessage = async (req, res) => {
    try {
        const { _id, opened } = req.body;
        return Message.findByIdAndUpdate(_id,
            { opened },
            { new: true })
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));

    } catch (error) {
        console.error(error);

    }
}
const deleteMessage = async (req, res) => {
    try {
        const _id = req.params.id;
        Message.findByIdAndDelete(_id)
            .then(() => res.status(200).json({ message: "success" }))
            .catch((err) => res.status(200).send(err));

    } catch (error) {
        console.log(error);
    }
};

module.exports = {
    createMessage,
    getAllMessages,
    updateMessage,
    deleteMessage
}
require("dotenv").config();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const User = require("../../models/user");

const createUser = async (req, res) => {
    try {
        const { email, password } = req.body;
        const doesExist = await User.findOne({ email });
        if (doesExist)
            return res.status(400).send({ message: "Email is currently used" });

        await bcrypt.hash(password, 12)
            .then(async (hashValue) => {
                new User({ email, hashValue })
                    .save()
                    .then((value) => res.status(200).json({ accountId: value._id, email, password: hashValue }))
                    .catch((err) => res.status(400).send(err));
            });
    } catch (error) {
        console.log(error);
    }
}

const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user)
            return res.status(400).json({ message: "Account doesn't exist" });

        await bcrypt.compare(password, user.hashValue)
            .then((value) => {
                if (value == false)
                    return res.status(400).json({ message: "Invalid login" });

                const accessToken = jwt.sign(
                    { data: user._id.toString() },
                    process.env.ACCESS_TOKEN_SECRET,
                    { expiresIn: "2h" }
                );

                return res.status(200).json({ ...user._doc, accessToken });
            });
    } catch (error) {
        console.log(error);
    }
}

const disableUser = async (req, res) => {
    try {
        const { _id, disabled } = req.body;
        User.findByIdAndUpdate(_id, { disabled }, { new: true })
            .then((value) => {
                if (!value)
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

module.exports = {
    createUser,
    loginUser,
    disableUser
};


//const { sendEmail } = require("../services/nodemailer/mail");
// sendEmail(email,
//   "development.mail.ph@gmail.com",
//   "#AUTOMATED_NODEJS_MAIL #ByKOLYA",
//   "Account created",
//   "<b>Thank you for creating your account"
// );
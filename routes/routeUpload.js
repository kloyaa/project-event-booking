
const express = require("express");
const router = express.Router();

router.post("/img", (req, res) {
  try {
    const accountId = req.body.accountId;
    const filePath = req.file.path;
    const options = {
      folder: process.env.CLOUDINARY_FOLDER + "/planner/event",
      unique_filename: true,
    };
    const uploadedImg = await cloudinary.uploader.upload(filePath, options);
    return res.status(200).json(uploadedImg)
  } catch (error) {
    console.log(error);
  }
});

module.exports = router;

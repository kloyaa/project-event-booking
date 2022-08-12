require("dotenv").config();
const port = process.env.PORT || 5000;
const express = require("express");
const multer = require("multer");
const mongoose = require("mongoose");
const app = express();

const { fileFilter, storage } = require("./services/img-upload/fileFilter");

try {
  mongoose
    .connect(process.env.CONNECTION_STRING)
    .then(() => console.log("SERVER IS CONNECTED"))
    .catch(() => console.log("SERVER CANNOT CONNECT"));

  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(multer({ storage, fileFilter }).single("img"));

  app.use("/api", require("./routes/routeUser"));
  app.use("/api", require("./routes/routeProfile"));
  app.use("/api", require("./routes/routeEvent"));
  app.use("/api", require("./routes/routeBooking"));
  app.use("/api", require("./routes/routeBilling"));
  app.use("/api", require("./routes/routeTicket"));
  app.use("/api", require("./routes/routeNotifications"));
  app.use("/api", require("./routes/routeMonetization"));
  app.use("/api", require("./routes/routeUpload"));

  app.listen(port, () => console.log(`SERVER IS RUNNING ON ${port}`));
} catch (error) {
  console.log(error);
}

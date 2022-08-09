const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const { userRoles } = require("../const/enum");

const ProfileSchema = new Schema({
  accountId: {
    type: Schema.Types.ObjectId,
    required: [true, "accountId is required"],
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
  avatar: { type: String },
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
  date: {
    createdAt: {
      type: Date,
      default: Date.now,
    },
    updatedAt: {
      type: Date,
    },
  },
  visibility: {
    type: Boolean,
    default: true,
  },
  verified: {
    type: Boolean,
    default: false,
  },
  links: [],
  gallery: [],
  role: {
    type: String,
    enum: userRoles,
    required: [true, "role is required"],
  },
});

module.exports = Profile = mongoose.model("profiles", ProfileSchema);



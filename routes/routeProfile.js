const express = require("express");
const router = express.Router();
const profile = require("../controllers/profile/profileController");
const protected = require("../middleware/authentication");

// PROFILE
router.post("/profile", (req, res) => profile.createProfile(req, res));
router.get("/profile/s/:id", (req, res) => profile.getProfile(req, res));
router.get("/profile/all", (req, res) => profile.getAllProfiles(req, res));
router.put("/profile", (req, res) => profile.updateProfile(req, res));

router.put("/profile/address", (req, res) => profile.updateProfileAddress(req, res));
router.put("/profile/avatar", (req, res) => profile.updateProfileAvatar(req, res));
router.put("/profile/visibility", (req, res) => profile.updateProfileVisibility(req, res));
router.delete("/profile/:id", (req, res) => profile.deleteProfile(req, res));

// GALLERY
router.put("/profile/gallery", (req, res) => profile.updateProfileGallery(req, res));
router.put("/profile/gallery/remove", (req, res) => profile.deleteInProfileGallery(req, res));

// LINKS
router.put("/profile/links", (req, res) => profile.updateProfileLink(req, res));
router.put("/profile/links/remove", (req, res) => profile.deleteProfileLink(req, res));

module.exports = router;

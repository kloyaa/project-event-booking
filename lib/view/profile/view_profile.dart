import 'dart:io';

import 'package:app/common/destroyFormFocus.dart';
import 'package:app/const/colors.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:app/services/location_name.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  Map? _addressCoord;
  bool _hasFocus = false;
  bool _hasProfileFocus = false;

  final _userCtrl = Get.put(UserController());
  final _profileCtrl = Get.put(ProfileController());

  final _fNameCtrl = TextEditingController();
  final _lNameCtrl = TextEditingController();

  final _fNameFocus = FocusNode();
  final _lNameFocus = FocusNode();

  final _emailCtrl = TextEditingController();
  final _emailFocus = FocusNode();

  final _numberCtrl = TextEditingController();
  final _numberFocus = FocusNode();

  final _addressCtrl = TextEditingController();
  final _addressFocus = FocusNode();

  final _picker = ImagePicker();

  String _img1Path = "";
  String _img1Name = "";

  Future<void> onSelectImage() async {
    setState(() {
      _hasFocus = false;
      _hasProfileFocus = false;
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _img1Path = image.path;
        _img1Name = image.name;
      });
      await updateAvatar({
        "accountId": _userCtrl.loginData["accountId"],
        "img": {"name": image.name, "path": image.path}
      });
      await _profileCtrl.getProfile(_userCtrl.loginData["accountId"]);
    }
  }

  Future<void> updateAvatar(data) async {
    await _profileCtrl.updateAvatar(data);
  }

  Future<void> updateProfile() async {
    final fName = _fNameCtrl.text.trim();
    final lName = _lNameCtrl.text.trim();
    final number = _numberCtrl.text.trim();

    Get.toNamed("/loading");
    await _profileCtrl.updateProfile(
      {
        "accountId": _userCtrl.loginData["accountId"],
        "name": {"first": fName, "last": lName},
        "contact": {"number": number}
      },
    );

    if (_addressCoord != null) {
      await _profileCtrl.updateProfileAddress(
        {
          "accountId": _userCtrl.loginData["accountId"],
          "address": {
            "coordinates": {
              "latitude": _addressCoord?["latitude"],
              "longitude": _addressCoord?["longitude"],
            },
            "name": _addressCtrl.text,
          }
        },
      );
    }
    Get.back();
    await _profileCtrl.getProfile(_userCtrl.loginData["accountId"]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fNameFocus.addListener(() {
      setState(() {
        _hasProfileFocus = _fNameFocus.hasFocus;
      });
    });
    _lNameFocus.addListener(() {
      setState(() {
        _hasProfileFocus = _lNameFocus.hasFocus;
      });
    });

    _numberFocus.addListener(() {
      setState(() {
        _hasProfileFocus = _numberFocus.hasFocus;
      });
    });
    _addressFocus.addListener(() {
      setState(() {
        _hasProfileFocus = _addressFocus.hasFocus;
      });
    });
    // Initialize txt value
    _fNameCtrl.text = _profileCtrl.profile["name"]["first"];
    _lNameCtrl.text = _profileCtrl.profile["name"]["last"];
    _emailCtrl.text = _profileCtrl.profile["contact"]["email"];
    _numberCtrl.text = _profileCtrl.profile["contact"]["number"];
    _addressCtrl.text = _profileCtrl.profile["address"]["name"];
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kWhite,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kDark,
        ),
      ),
      title: Text(
        "MY PROFILE",
        style: GoogleFonts.roboto(
          color: kDark,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return GestureDetector(
      onTap: () => destroyFormFocus(context),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: kLight,
        //     resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              _hasFocus
                  ? const SizedBox()
                  : _profileCtrl.profile["avatar"] != null
                      ? Row(
                          children: [
                            _img1Path == ""
                                ? GestureDetector(
                                    onTap: () async => await onSelectImage(),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(300),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            _profileCtrl.profile["avatar"],
                                        height: 110,
                                        width: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => onSelectImage(),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(300),
                                      ),
                                      child: Image.file(
                                        File(_img1Path),
                                        height: 110,
                                        width: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                children: [
                                  inputTextField(
                                    controller: _fNameCtrl,
                                    focusNode: _fNameFocus,
                                    color: kWhite,
                                    labelText: "First",
                                    textFieldStyle: GoogleFonts.roboto(
                                      color: kDark,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                    ),
                                    obscureText: false,
                                  ),
                                  const SizedBox(height: 10.0),
                                  inputTextField(
                                    controller: _lNameCtrl,
                                    focusNode: _lNameFocus,
                                    color: kWhite,
                                    labelText: "Last",
                                    textFieldStyle: GoogleFonts.roboto(
                                      color: kDark,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                    ),
                                    obscureText: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(300)),
                              child: _img1Path == ""
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async => await onSelectImage(),
                                      child: DottedBorder(
                                        borderType: BorderType.Circle,
                                        dashPattern: const [10, 10],
                                        color: kDark,
                                        strokeWidth: 4,
                                        child: Stack(
                                          children: const [
                                            SizedBox(
                                              height: 110,
                                              width: 110,
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  AntDesign.user,
                                                  color: kDark,
                                                  size: 34.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () => onSelectImage(),
                                      child: Image.file(
                                        File(_img1Path),
                                        height: 110,
                                        width: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                children: [
                                  inputTextField(
                                    controller: _fNameCtrl,
                                    focusNode: _fNameFocus,
                                    color: kWhite,
                                    labelText: "First",
                                    textFieldStyle: GoogleFonts.roboto(
                                      color: kDark,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                    ),
                                    obscureText: false,
                                  ),
                                  const SizedBox(height: 10.0),
                                  inputTextField(
                                    controller: _lNameCtrl,
                                    focusNode: _lNameFocus,
                                    color: kWhite,
                                    labelText: "Last",
                                    textFieldStyle: GoogleFonts.roboto(
                                      color: kDark,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                    ),
                                    obscureText: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
              const Spacer(),
              _hasFocus
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How people find and contact you",
                          style: GoogleFonts.roboto(
                            color: kDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        IgnorePointer(
                          ignoring: true,
                          child: inputTextField(
                            controller: _emailCtrl,
                            focusNode: _emailFocus,
                            color: Colors.grey.shade200,
                            labelText: "Email",
                            textFieldStyle: GoogleFonts.roboto(
                              color: kDark,
                              fontWeight: FontWeight.w300,
                              fontSize: 12.0,
                            ),
                            obscureText: false,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        inputPhoneTextField(
                          controller: _numberCtrl,
                          focusNode: _numberFocus,
                          color: kWhite,
                          labelText: "Contact Number",
                          textFieldStyle: GoogleFonts.roboto(
                            color: kDark,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
              _hasFocus == false && _hasProfileFocus == false
                  ? const Spacer()
                  : const SizedBox(),
              _hasProfileFocus
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location",
                          style: GoogleFonts.roboto(
                            color: kDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        IgnorePointer(
                          ignoring: true,
                          child: inputTextField(
                            controller: _addressCtrl,
                            focusNode: _addressFocus,
                            color: kWhite,
                            labelText: "Home Address",
                            textFieldStyle: GoogleFonts.roboto(
                              color: kDark,
                              fontWeight: FontWeight.w300,
                              fontSize: 12.0,
                            ),
                            obscureText: false,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 30.0,
                              width: Get.width * 0.37,
                              child: TextButton(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Ionicons.sync_icon,
                                      color: kDark,
                                      size: 12.0,
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      "Sync Location",
                                      style: GoogleFonts.roboto(
                                        color: kDark,
                                        fontSize: 10.0,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () async {
                                  final locationCoord = await getLocation();
                                  final locationName = await getLocationName(
                                    lat: locationCoord!.latitude,
                                    long: locationCoord.longitude,
                                  );
                                  _addressCoord?.addAll({
                                    "latitude": locationCoord.latitude,
                                    "longitude": locationCoord.longitude,
                                  });
                                  final String street = locationName[0]
                                          .street
                                          .toString()
                                          .contains("+")
                                      ? ""
                                      : "${locationName[0].street}, ";
                                  final String thoroughFare = locationName[0]
                                          .thoroughfare
                                          .toString()
                                          .isEmpty
                                      ? ""
                                      : "${locationName[0].thoroughfare}, ";
                                  final String locality = locationName[0]
                                          .locality
                                          .toString()
                                          .isEmpty
                                      ? ""
                                      : "${locationName[0].locality}";

                                  _addressCtrl.text =
                                      "$street$thoroughFare$locality";
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                      ],
                    ),
              _hasFocus == false && _hasProfileFocus == false
                  ? elevatedButton(
                      btnColor: kDark,
                      labelColor: kWhite,
                      label: "SAVE CHANGES",
                      function: () async => updateProfile(),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fNameCtrl.dispose();
    _fNameFocus.dispose();
    _emailCtrl.dispose();
    _emailFocus.dispose();
    _numberCtrl.dispose();
    _numberFocus.dispose();
    _addressCtrl.dispose();
    _addressFocus.dispose();
    super.dispose();
  }
}

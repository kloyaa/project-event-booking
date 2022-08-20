import 'package:app/common/destroyFormFocus.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:app/services/location_name.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewCreateProfile extends StatefulWidget {
  const ViewCreateProfile({Key? key}) : super(key: key);

  @override
  State<ViewCreateProfile> createState() => _ViewCreateProfileState();
}

class _ViewCreateProfileState extends State<ViewCreateProfile> {
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

  final Map _addressCoord = {};
  String _role = "customer";

  Future<void> createProfile() async {
    final firstName = _fNameCtrl.text.trim();
    final lastName = _lNameCtrl.text.trim();
    final number = _numberCtrl.text;

    if (firstName.isEmpty) {
      return _fNameFocus.requestFocus();
    }
    if (lastName.isEmpty) {
      return _lNameFocus.requestFocus();
    }
    if (number.isEmpty) {
      return _numberFocus.requestFocus();
    }
    if (_addressCtrl.text.isEmpty) {
      return _addressFocus.requestFocus();
    }
    Get.toNamed("/loading");
    final response = await _profileCtrl.createProfile(
      {
        "accountId": _userCtrl.loginData["accountId"],
        // "avatar": "http://img.io/kolya",
        "name": {
          "first": firstName,
          "last": lastName,
        },
        "address": {
          "name": _addressCtrl.text,
          "coordinates": _addressCoord,
        },
        "contact": {
          "email": _userCtrl.loginData["email"],
          "number": number,
        },
        "role": _role
      },
    );

    if (response == 200) {
      await _profileCtrl
          .getProfile(_userCtrl.loginData["accountId"])
          .then((value) {
        if (value["role"] == "customer") {
          Get.toNamed("/view-main-customer");
          return;
        }
        if (value["role"] == "planner") {
          Get.toNamed("/view-main-planner");
          return;
        }
        if (value["role"] == "organizer") {
          Get.toNamed("/view-main-organizer");
          return;
        }
      }).catchError((err) {
        Get.toNamed("/view-create-profile");
        return;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailCtrl.text = _userCtrl.loginData["email"];
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kLight,
      leading: const SizedBox(),
      leadingWidth: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile",
            style: GoogleFonts.roboto(
              color: kDark,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Let us know each other",
            style: GoogleFonts.roboto(
              color: kDark,
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () => destroyFormFocus(context),
      child: Scaffold(
        backgroundColor: kLight,
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: inputTextField(
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
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: inputTextField(
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
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              IgnorePointer(
                ignoring: true,
                child: inputTextField(
                  controller: _emailCtrl,
                  focusNode: _emailFocus,
                  color: Colors.grey.shade200,
                  labelText: "Email",
                  textFieldStyle: GoogleFonts.roboto(
                    color: kDark,
                    fontWeight: FontWeight.w400,
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
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 10.0),
              inputTextField(
                controller: _addressCtrl,
                focusNode: _addressFocus,
                color: kWhite,
                labelText: "Home Address",
                textFieldStyle: GoogleFonts.roboto(
                  color: kDark,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
                obscureText: false,
              ),
              const SizedBox(height: 10.0),
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
                        _addressCoord.addAll({
                          "latitude": locationCoord.latitude,
                          "longitude": locationCoord.longitude,
                        });
                        final String street =
                            locationName[0].street.toString().contains("+")
                                ? ""
                                : "${locationName[0].street}, ";
                        final String thoroughFare =
                            locationName[0].thoroughfare.toString().isEmpty
                                ? ""
                                : "${locationName[0].thoroughfare}, ";
                        final String locality =
                            locationName[0].locality.toString().isEmpty
                                ? ""
                                : "${locationName[0].locality}";

                        _addressCtrl.text = "$street$thoroughFare$locality";
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: kDefaultRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile(
                      activeColor: kDark,
                      title: Text(
                        "Customer",
                        style: GoogleFonts.roboto(
                          color: kDark,
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                        ),
                      ),
                      value: "customer",
                      groupValue: _role,
                      onChanged: (value) {
                        setState(() {
                          _role = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      activeColor: kDark,
                      title: Text(
                        "Event Planner",
                        style: GoogleFonts.roboto(
                          color: kDark,
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                        ),
                      ),
                      value: "planner",
                      groupValue: _role,
                      onChanged: (value) {
                        setState(() {
                          _role = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      activeColor: kDark,
                      title: Text(
                        "Event Organizer",
                        style: GoogleFonts.roboto(
                          color: kDark,
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                        ),
                      ),
                      value: "organizer",
                      groupValue: _role,
                      onChanged: (value) {
                        setState(() {
                          _role = value.toString();
                        });
                      },
                    )
                  ],
                ),
              ),
              const Spacer(),
              elevatedButton(
                btnColor: kDark,
                labelColor: kWhite,
                label: "UPDATE PROFILE",
                function: () async => createProfile(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _emailCtrl.dispose();
    _emailFocus.dispose();

    _fNameCtrl.dispose();
    _fNameFocus.dispose();

    _lNameCtrl.dispose();
    _lNameFocus.dispose();

    _numberCtrl.dispose();
    _numberFocus.dispose();

    _addressCtrl.dispose();
    _addressFocus.dispose();
  }
}

import 'dart:io';
import 'package:app/common/destroyFormFocus.dart';
import 'package:app/common/formatPrint.dart';
import 'package:app/const/bottomsheet_prompt.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/event_categories.dart';
import 'package:app/const/material.dart';
import 'package:app/const/uri.dart';
import 'package:app/controller/eventController.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:app/services/location_coordinates.dart';
import 'package:app/services/location_name.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:dio/dio.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ViewCreateEvents extends StatefulWidget {
  const ViewCreateEvents({Key? key}) : super(key: key);

  @override
  State<ViewCreateEvents> createState() => _ViewCreateEventsState();
}

class _ViewCreateEventsState extends State<ViewCreateEvents> {
  final _eventCtrl = Get.put(EventController());
  final _userCtrl = Get.put(UserController());
  final _profileCtrl = Get.put(ProfileController());

  final _picker = ImagePicker();

  final _titleCntrl = TextEditingController();
  final _titleFocus = FocusNode();

  final _detailsCntrl = TextEditingController();
  final _detailsFocus = FocusNode();

  final _priceStartCntrl = TextEditingController();
  final _priceStartFocus = FocusNode();

  final _priceEndCntrl = TextEditingController();
  final _priceEndFocus = FocusNode();

  final _addressCntrl = TextEditingController();
  final _addressFocus = FocusNode();

  List images = [];

  Future<void> onSelectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        images.add({
          "id": const Uuid().v4(),
          "name": image.name,
          "path": image.path,
        });
      });

      formatPrint("onSelectImage", images);
    }
  }

  Future<void> createPost() async {
    final title = _titleCntrl.text.trim();
    final details = _detailsCntrl.text.trim();
    final priceFrom = _priceStartCntrl.text.trim();
    final priceEnd = _priceEndCntrl.text.trim();

    if (title.isEmpty) {
      return _titleFocus.requestFocus();
    }
    if (details.isEmpty) {
      return _detailsFocus.requestFocus();
    }
    if (priceFrom.isEmpty) {
      return _priceStartFocus.requestFocus();
    }
    if (priceEnd.isEmpty) {
      return _priceEndFocus.requestFocus();
    }
    BottomPicker(
      items: events,
      title: "Event Categories",
      titleStyle: GoogleFonts.roboto(
        color: kDark,
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
      itemExtent: 40,
      height: Get.height * 0.70,
      pickerTextStyle: GoogleFonts.roboto(
        color: kDark,
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        height: 2.5,
      ),
      buttonText: "CREATE EVENT",
      buttonTextStyle: GoogleFonts.roboto(
        color: kWhite,
        fontWeight: FontWeight.w400,
        fontSize: 10.0,
      ),
      displayButtonIcon: false,
      buttonAlignement: MainAxisAlignment.end,
      buttonSingleColor: kDark,
      onSubmit: (value) async {
        String selectedCategory = "";
        String eventAddress = "";

        if (value == 0) {
          selectedCategory = "wedding";
        }
        if (value == 1) {
          selectedCategory = "kids-birthday-party";
        }
        if (value == 2) {
          selectedCategory = "adults-birthday-party";
        }
        if (value == 3) {
          selectedCategory = "casual-party";
        }
        if (value == 4) {
          selectedCategory = "disco";
        }
        final locationCoord = await getLocation();
        final locationName = await getLocationName(
          lat: locationCoord!.latitude,
          long: locationCoord.longitude,
        );
        final String street = locationName[0].street.toString().contains("+")
            ? ""
            : "${locationName[0].street}, ";
        final String thoroughFare =
            locationName[0].thoroughfare.toString().isEmpty
                ? ""
                : "${locationName[0].thoroughfare}, ";
        final String locality = locationName[0].locality.toString().isEmpty
            ? ""
            : "${locationName[0].locality}";

        eventAddress = "$street$thoroughFare$locality";

        Get.toNamed("/loading");

        final response = await http.Dio().post(
          "$baseUrl/img",
          data: http.FormData.fromMap({
            'img': await http.MultipartFile.fromFile(
              images[0]["path"],
              filename: images[0]["name"],
              contentType: MediaType("image", "jpeg"), //important
            ),
          }),
        );
        final response1 = await http.Dio().post(
          "$baseUrl/img",
          data: http.FormData.fromMap({
            'img': await http.MultipartFile.fromFile(
              images[1]["path"],
              filename: images[1]["name"],
              contentType: MediaType("image", "jpeg"), //important
            ),
          }),
        );
        final response2 = await http.Dio().post(
          "$baseUrl/img",
          data: http.FormData.fromMap({
            'img': await http.MultipartFile.fromFile(
              images[2]["path"],
              filename: images[2]["name"],
              contentType: MediaType("image", "jpeg"), //important
            ),
          }),
        );
        final response3 = await http.Dio().post(
          "$baseUrl/img",
          data: http.FormData.fromMap({
            'img': await http.MultipartFile.fromFile(
              images[3]["path"],
              filename: images[3]["name"],
              contentType: MediaType("image", "jpeg"), //important
            ),
          }),
        );
        final response4 = await http.Dio().post(
          "$baseUrl/img",
          data: http.FormData.fromMap({
            'img': await http.MultipartFile.fromFile(
              images[4]["path"],
              filename: images[4]["name"],
              contentType: MediaType("image", "jpeg"), //important
            ),
          }),
        );
        await _eventCtrl.createEvent(
          {
            "header": {
              "accountId": _userCtrl.loginData["accountId"],
              "name": {
                "first": _profileCtrl.profile["name"]["first"],
                "last": _profileCtrl.profile["name"]["last"],
              },
              "avatar": _profileCtrl.profile["avatar"],
              "address": {
                "name": eventAddress,
                "coordinates": {
                  "latitude": "${locationCoord.latitude}",
                  "longitude": "${locationCoord.longitude}"
                }
              },
              "contact": {
                "email": "madridano.kolya@gmail.com",
                "number": "09277522772"
              }
            },
            "event": {
              "title": title,
              "details": details,
              "images": [
                response.data["url"],
                response1.data["url"],
                response2.data["url"],
                response3.data["url"],
                response4.data["url"],
              ],
              "price": {"from": priceFrom, "to": priceEnd},
              "type": selectedCategory,
            }
          },
        );

        Get.toNamed("/view-planner-posted-events");
      },
    ).show(context);
  }

  Future<void> getLocationAutomatically() async {
    final locationCoord = await getLocation();
    final locationName = await getLocationName(
      lat: locationCoord!.latitude,
      long: locationCoord.longitude,
    );
    final String street = locationName[0].street.toString().contains("+")
        ? ""
        : "${locationName[0].street}, ";
    final String thoroughFare = locationName[0].thoroughfare.toString().isEmpty
        ? ""
        : "${locationName[0].thoroughfare}, ";
    final String locality = locationName[0].locality.toString().isEmpty
        ? ""
        : "${locationName[0].locality}";

    _addressCntrl.text = "$street$thoroughFare$locality";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationAutomatically();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2), () {
        createEventPrompt();
      });
    });
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
        "CREATE EVENT",
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
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(
            top: 30.0,
            left: 30.0,
            right: 30.0,
            bottom: 30.0,
          ),
          child: Column(
            children: [
              IgnorePointer(
                ignoring: true,
                child: inputTextArea(
                  controller: _addressCntrl,
                  focusNode: _addressFocus,
                  color: Colors.grey.shade200,
                  labelText: "Venue",
                  maxLines: 2,
                  textFieldStyle: GoogleFonts.roboto(
                    color: kDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              inputTextField(
                controller: _titleCntrl,
                focusNode: _titleFocus,
                color: kWhite,
                labelText: "Title",
                textFieldStyle: GoogleFonts.roboto(
                  color: kDark,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
                obscureText: false,
              ),
              const SizedBox(height: 15.0),
              inputTextArea(
                controller: _detailsCntrl,
                focusNode: _detailsFocus,
                color: kWhite,
                labelText: "Details",
                textFieldStyle: GoogleFonts.roboto(
                  color: kDark,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    child: inputNumberField(
                      controller: _priceStartCntrl,
                      focusNode: _priceStartFocus,
                      color: kWhite,
                      labelText: "Starting Price",
                      textFieldStyle: GoogleFonts.roboto(
                        color: kDark,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: inputNumberField(
                      controller: _priceEndCntrl,
                      focusNode: _priceEndFocus,
                      color: kWhite,
                      labelText: "End Price",
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
              const SizedBox(height: 15.0),
              images.length == 5
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30.0,
                          width: Get.width * 0.40,
                          child: TextButton(
                            onPressed: null,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  AntDesign.infocirlce,
                                  color: kDark.withOpacity(0.7),
                                  size: 12.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  "MAXIMUM OF 5 ONLY",
                                  style: GoogleFonts.roboto(
                                    color: kDark.withOpacity(0.7),
                                    fontSize: 10.0,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
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
                                  AntDesign.picture,
                                  color: kDark,
                                  size: 12.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  "ADD PHOTO",
                                  style: GoogleFonts.roboto(
                                    color: kDark,
                                    fontSize: 10.0,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async => onSelectImage(),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 130.0,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: images.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (_, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            images.removeWhere(
                              (element) => element["id"] == images[index]["id"],
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.file(
                            File(images[index]["path"]),
                            height: 130,
                            width: 170,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: images.length == 5 ? 1 : 0.5,
                child: IgnorePointer(
                  ignoring: images.length == 5 ? false : true,
                  child: elevatedButton(
                    btnColor: kDark,
                    labelColor: kWhite,
                    label: "SUBMIT",
                    function: () async => await createPost(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

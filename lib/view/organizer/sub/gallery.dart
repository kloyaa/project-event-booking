import 'dart:io';
import 'package:app/common/destroyFormFocus.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controller/globalController.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/dialog.dart';
import 'package:app/widget/form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';

class ViewGallery extends StatefulWidget {
  const ViewGallery({Key? key}) : super(key: key);

  @override
  State<ViewGallery> createState() => _ViewGalleryState();
}

class _ViewGalleryState extends State<ViewGallery> {
  final _profileCtrl = Get.put(ProfileController());
  final _globalCtrl = Get.put(GlobalController());
  final _userCtrl = Get.put(UserController());

  late Future _gallery;

  Future refresh() async {
    setState(() {
      _gallery = _profileCtrl.getGallery(_profileCtrl.profile["accountId"]);
    });
  }

  Future<void> _bottomSheetUploadImage() async {
    final descCtrl = TextEditingController();
    final descFocus = FocusNode();
    final picker = ImagePicker();
    String imgPath = "";
    String imgName = "";
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kLight,
      shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(17.0),
          //   topRight: Radius.circular(17.0),
          // ),
          // side: BorderSide(color: Colors.red),
          ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter newState) {
            Future<void> onSelectImage() async {
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                newState(() {
                  imgPath = image.path;
                  imgName = image.name;
                });
              }
            }

            Future<void> upload({description}) async {
              Get.toNamed("/loading");
              final response = await _profileCtrl.updateGallery({
                "description": description,
                "img": {
                  "name": imgName,
                  "path": imgPath,
                }
              });
              if (response == 200) {
                return Get.toNamed("/view-gallery");
              }
            }

            return Container(
              height: Get.height,
              color: kLight,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40.0, bottom: 10.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(AntDesign.close),
                            ),
                            Text(
                              "ADD TO GALLERY",
                              style: GoogleFonts.roboto(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: kDark,
                              ),
                            ),
                          ],
                        ),
                        IgnorePointer(
                          ignoring:
                              descCtrl.text.isNotEmpty && imgPath.isNotEmpty
                                  ? false
                                  : true,
                          child: AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            opacity:
                                descCtrl.text.isNotEmpty && imgPath.isNotEmpty
                                    ? 1
                                    : 0.3,
                            child: SizedBox(
                              width: 85.0,
                              height: 35.0,
                              child: elevatedButton(
                                btnColor: kDark,
                                labelColor: kWhite,
                                label: "UPLOAD",
                                function: () async => await upload(
                                  description: descCtrl.text,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 40.0),
                  inputTextArea(
                    controller: descCtrl,
                    focusNode: descFocus,
                    labelText: "Say something about this photo...",
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    textFieldStyle: GoogleFonts.roboto(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: kDark.withOpacity(0.8),
                    ),
                    color: kLight,
                  ),
                  imgPath.toString().isNotEmpty
                      ? GestureDetector(
                          onTap: () async => await onSelectImage(),
                          child: Container(
                            margin: const EdgeInsets.only(top: 25.0),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(imgPath),
                                  fit: BoxFit.cover,
                                  height: Get.height * 0.55,
                                  width: Get.width,
                                ),
                                Positioned(
                                  top: 30,
                                  right: 30.0,
                                  child: IconButton(
                                    onPressed: () {
                                      newState(() {
                                        imgPath = "";
                                        imgName = "";
                                      });
                                    },
                                    icon: const Icon(
                                      AntDesign.closecircle,
                                      color: kLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const Spacer(),
                  imgPath.toString().isNotEmpty
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () async => await onSelectImage(),
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 30.0,
                              right: 30.0,
                            ),
                            height: 50,
                            width: Get.width,
                            decoration: const BoxDecoration(
                              color: kWhite,
                              borderRadius: kDefaultRadius,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Select a Photo",
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 15.0),
                                const Icon(
                                  MaterialCommunityIcons.image_multiple,
                                  color: Colors.grey,
                                  size: 14,
                                )
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 15.0),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteImage(String id) async {
    await _profileCtrl.deleteFromGallery({
      "accountId": _userCtrl.loginData["accountId"],
      "_id": id,
    });
    await refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _gallery = _profileCtrl.getGallery(_profileCtrl.profile["accountId"]);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kWhite,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.toNamed("/view-main-organizer"),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kDark,
        ),
      ),
      title: Text(
        "MY GALLERY",
        style: GoogleFonts.roboto(
          color: kDark,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Get.toNamed("/view-profile"),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: 56,
            child: CircularProfileAvatar(_profileCtrl.profile["avatar"]),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => destroyFormFocus(context),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: kLight,
        body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: kLight,
                height: 10.0,
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () async => await _bottomSheetUploadImage(),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: kWhite,
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text(
                            "Upload to Gallery",
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              color: kDark,
                            ),
                          )),
                      const Expanded(
                        child: Icon(
                          MaterialCommunityIcons.image_multiple,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                color: kLight,
                child: FutureBuilder(
                  future: _gallery,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            for (int i = 0; i < 5; i++)
                              Column(
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    height: 220.0,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade100,
                                      highlightColor: Colors.grey.shade200,
                                      enabled: true,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          //borderRadius: kDefaultRadius,
                                          color: kDark,
                                        ),
                                        width: 100.0,
                                        height: 220.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 45.0),
                                ],
                              )
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            for (int i = 0; i < 5; i++)
                              Column(
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    height: 220.0,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade100,
                                      highlightColor: Colors.grey.shade200,
                                      enabled: true,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          //borderRadius: kDefaultRadius,
                                          color: kDark,
                                        ),
                                        width: 100.0,
                                        height: 220.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 45.0),
                                ],
                              )
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data.length == 0) {
                        return GestureDetector(
                          onTap: () async => await refresh(),
                          child: Scaffold(
                            body: Center(
                              child: Text(
                                "Empty",
                                style: GoogleFonts.roboto(
                                  color: kDark.withOpacity(0.8),
                                  fontSize: 11.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }

                    return RefreshIndicator(
                      onRefresh: () async => await refresh(),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          final id = snapshot.data[index]["id"];
                          final img = snapshot.data[index]["url"];
                          final dateUploaded =
                              snapshot.data[index]["date"]["createdAt"];
                          return GestureDetector(
                            onTap: () {
                              _globalCtrl.selectedPhoto = snapshot.data[index];
                              Get.toNamed("/view-photo-preview");
                            },
                            child: Container(
                              color: kWhite,
                              child: Column(
                                children: [
                                  Hero(
                                    tag: id,
                                    child: CachedNetworkImage(
                                      imageUrl: img,
                                      height: 220.0,
                                      width: Get.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Text(
                                            "Uploaded ${Jiffy(dateUploaded).fromNow()}",
                                            style: GoogleFonts.roboto(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          dialogDelete(
                                            context,
                                            message:
                                                "Do you wish to delete this photo? \n this action is cannot be undone",
                                            action: () async {
                                              Get.back();
                                              await deleteImage(id);
                                            },
                                          );
                                        },
                                        splashRadius: 30.0,
                                        icon: const Icon(
                                          AntDesign.delete,
                                          color: kDanger,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

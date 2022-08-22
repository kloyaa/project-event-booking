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
import 'package:url_launcher/url_launcher.dart';

class ViewSocialLinks extends StatefulWidget {
  const ViewSocialLinks({Key? key}) : super(key: key);

  @override
  State<ViewSocialLinks> createState() => _ViewSocialLinksState();
}

class _ViewSocialLinksState extends State<ViewSocialLinks> {
  final _profileCtrl = Get.put(ProfileController());
  final _userCtrl = Get.put(UserController());

  late Future _gallery;

  Future refresh() async {
    setState(() {
      _gallery = _profileCtrl.getLinks(_profileCtrl.profile["accountId"]);
    });
  }

  Future<void> _bottomSheetCreateLink() async {
    final nameCtrl = TextEditingController();
    final nameFocus = FocusNode();
    final urlCtrl = TextEditingController();
    final urlFocus = FocusNode();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kLight,
      // shape: const RoundedRectangleBorder(
      //     // borderRadius: BorderRadius.only(
      //     //   topLeft: Radius.circular(17.0),
      //     //   topRight: Radius.circular(17.0),
      //     // ),
      //     // side: BorderSide(color: Colors.red),
      //     ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter newState) {
            Future<void> createLink(jsonData) async {
              Get.toNamed("/loading");
              final response = await _profileCtrl.updateLinks(jsonData);
              if (response == 200) {
                return Get.toNamed("/view-social-links");
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
                              "NEW SOCIAL LINK",
                              style: GoogleFonts.roboto(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: kDark,
                              ),
                            ),
                          ],
                        ),
                        IgnorePointer(
                          ignoring: nameCtrl.text.isNotEmpty &&
                                  urlCtrl.text.isNotEmpty
                              ? false
                              : true,
                          child: AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            opacity: nameCtrl.text.isNotEmpty &&
                                    urlCtrl.text.isNotEmpty
                                ? 1
                                : 0.3,
                            child: SizedBox(
                              width: 85.0,
                              height: 35.0,
                              child: elevatedButton(
                                btnColor: kDark,
                                labelColor: kWhite,
                                label: "CREATE",
                                function: () async => createLink({
                                  "accountId": _userCtrl.loginData["accountId"],
                                  "content": {
                                    "url": urlCtrl.text.trim(),
                                    "title": nameCtrl.text.trim(),
                                  }
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: inputTextField(
                      controller: nameCtrl,
                      focusNode: nameFocus,
                      labelText: "Name",
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: kDark.withOpacity(0.8),
                      ),
                      color: kWhite,
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: inputTextField(
                      controller: urlCtrl,
                      focusNode: urlFocus,
                      labelText: "URL",
                      textFieldStyle: GoogleFonts.roboto(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: kDark.withOpacity(0.8),
                      ),
                      color: kWhite,
                      obscureText: false,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _gallery = _profileCtrl.getLinks(_profileCtrl.profile["accountId"]);
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
        "MY SOCIAL LINKS",
        style: GoogleFonts.roboto(
          color: kDark,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _profileCtrl.profile["avatar"] != null
            ? GestureDetector(
                onTap: () => Get.toNamed("/view-profile"),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 56,
                  child: CircularProfileAvatar(_profileCtrl.profile["avatar"]),
                ),
              )
            : const SizedBox(),
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
                onTap: () async => await _bottomSheetCreateLink(),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: kWhite,
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text(
                            "Create my new link",
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              color: kDark,
                            ),
                          )),
                      const Expanded(
                        child: Icon(
                          AntDesign.link,
                          color: kDark,
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
                            for (int i = 0; i < 20; i++)
                              Column(
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    height: 55.0,
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
                                        height: 55.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
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
                            for (int i = 0; i < 20; i++)
                              Column(
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    height: 55.0,
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
                                        height: 55.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
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
                          final url = snapshot.data[index]["url"];
                          final title = snapshot.data[index]["title"];
                          return GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(url))) {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Container(
                              color: kWhite,
                              margin: EdgeInsets.only(
                                top: index == 0 ? 0 : 10.0,
                              ),
                              child: ListTile(
                                title: Text(
                                  title,
                                  style: GoogleFonts.roboto(color: kDark),
                                ),
                                leading: IconButton(
                                  icon: const Icon(
                                    MaterialCommunityIcons.launch,
                                    color: kDark,
                                  ),
                                  onPressed: () {},
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    AntDesign.delete,
                                    color: kDanger,
                                    size: 16.0,
                                  ),
                                  onPressed: () {
                                    dialogDelete(
                                      context,
                                      action: () async {
                                        Get.back();
                                        await _profileCtrl.deleteFromLinks({
                                          "accountId":
                                              _userCtrl.loginData["accountId"],
                                          "_id": id
                                        });
                                        await refresh();
                                      },
                                      message:
                                          "Do you wish to delete \nyour $title?",
                                    );
                                  },
                                ),
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

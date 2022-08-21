import 'package:app/common/formatPrint.dart';
import 'package:app/const/colors.dart';
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
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewOrganizerMain extends StatefulWidget {
  const ViewOrganizerMain({Key? key}) : super(key: key);

  @override
  State<ViewOrganizerMain> createState() => _ViewOrganizerMainState();
}

class _ViewOrganizerMainState extends State<ViewOrganizerMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _profileCtrl = Get.put(ProfileController());
  final _userCtrl = Get.put(UserController());
  final _globalCtrl = Get.put(GlobalController());

  late Future _gallery;

  Future refresh() async {
    setState(() {
      _gallery = _profileCtrl.getGallery(_profileCtrl.profile["accountId"]);
    });
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
      backgroundColor: kLight,
      leading: const SizedBox(),
      leadingWidth: 0,
      actions: [
        IconButton(
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          icon: const Icon(
            Ionicons.menu,
            color: kDark,
          ),
        ),
      ],
      title: Text(
        "Hi, ${_profileCtrl.profile["name"]["first"]}!",
        style: GoogleFonts.roboto(
          color: kDark,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    final drawer = Drawer(
      backgroundColor: kWhite,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
              color: kDark,
            ),
            child: GestureDetector(
              onTap: () => Get.toNamed("/view-profile"),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.transparent),
                currentAccountPictureSize: const Size.square(70.0),
                margin: const EdgeInsets.all(0),
                currentAccountPicture: _profileCtrl.profile["avatar"] == null
                    ? const SizedBox()
                    : CircularProfileAvatar(
                        _profileCtrl.profile["avatar"],
                      ),
                accountName: Text(
                  _profileCtrl.profile["name"]["first"] +
                      " " +
                      _profileCtrl.profile["name"]["last"],
                  style: GoogleFonts.roboto(
                    color: kWhite,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                accountEmail: Text(
                  _userCtrl.loginData["email"],
                  style: GoogleFonts.roboto(
                    color: kWhite,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
          // const Divider(),
          ListTile(
            onTap: () => Get.toNamed("/view-profile"),
            leading: const Icon(
              AntDesign.user,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Profile",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          const Divider(),
          const Spacer(),
          ListTile(
            onTap: () => Get.toNamed("/view-gallery"),
            leading: const Icon(
              AntDesign.picture,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Gallery",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-social-links"),
            leading: const Icon(
              AntDesign.link,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Social Links",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              AntDesign.mail,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Inbox",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          const Spacer(),
          const Divider(),
          const Spacer(flex: 5),
          ListTile(
            onTap: () => _userCtrl.logout(),
            leading: Icon(
              AntDesign.logout,
              size: 22.0,
              color: kDark.withOpacity(0.8),
            ),
            title: Text(
              "Log out",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      drawer: drawer,
      backgroundColor: kLight,
      body: Scrollbar(
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
                shrinkWrap: true,
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
                          Container(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                const SizedBox(width: 10),
                              ],
                            ),
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
    );
  }
}

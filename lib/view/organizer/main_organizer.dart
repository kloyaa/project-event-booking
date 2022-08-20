import 'package:app/const/colors.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewOrganizerMain extends StatefulWidget {
  const ViewOrganizerMain({Key? key}) : super(key: key);

  @override
  State<ViewOrganizerMain> createState() => _ViewOrganizerMainState();
}

class _ViewOrganizerMainState extends State<ViewOrganizerMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _userCtrl = Get.put(UserController());
  final _profileCtrl = Get.put(ProfileController());

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
            onTap: () => {},
            leading: const Icon(
              Ionicons.add,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Upload Images",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              AntDesign.message1,
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
    );
  }
}

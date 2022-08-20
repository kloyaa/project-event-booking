import 'package:app/const/colors.dart';
import 'package:app/controller/eventController.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/common/format_currency.dart';
import 'package:app/const/material.dart';
import 'package:app/widget/dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

class ViewPlannerMain extends StatefulWidget {
  const ViewPlannerMain({Key? key}) : super(key: key);

  @override
  State<ViewPlannerMain> createState() => _ViewPlannerMainState();
}

class _ViewPlannerMainState extends State<ViewPlannerMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _userCtrl = Get.put(UserController());
  final _profileCtrl = Get.put(ProfileController());
  final _eventCtrl = Get.put(EventController());

  late Future _events;

  List<Widget> images(images) {
    List<Widget> listImage = [];
    for (var i = 0; i < images.length; i++) {
      final widget = ClipRRect(
        borderRadius: kDefaultRadius,
        child: Image.network(
          images[i],
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      );
      listImage.add(widget);
    }
    return listImage;
  }

  Future refresh() async {
    setState(() {
      _events = _eventCtrl.getEvents();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _events = _eventCtrl.getEvents();
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () => Get.toNamed("/view-planner-create-event"),
            leading: const Icon(
              Ionicons.add,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Create Events",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-planner-posted-events"),
            leading: const Icon(
              Ionicons.calendar_outline,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "My Events",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-planner-bookings"),
            leading: const Icon(
              Ionicons.receipt_outline,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Bookings",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-planner-billing"),
            leading: const Icon(
              MaterialCommunityIcons.credit_card_check_outline,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Transaction History",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          const Spacer(),
          const Divider(),
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      drawer: drawer,
      backgroundColor: kLight,
      body: FutureBuilder(
        future: _events,
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return Container(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 30.0,
                right: 30.0,
                bottom: 30.0,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade100,
                        highlightColor: Colors.grey.shade200,
                        enabled: true,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: kDefaultRadius,
                            color: kDark,
                          ),
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade200,
                              enabled: true,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: kDefaultRadius,
                                  color: kDark,
                                ),
                                width: 200.0,
                                height: 200.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 50,
                          height: 40.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.grey.shade200,
                            enabled: true,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: kDefaultRadius,
                                color: kDark,
                              ),
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade100,
                        highlightColor: Colors.grey.shade200,
                        enabled: true,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: kDefaultRadius,
                            color: kDark,
                          ),
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade200,
                              enabled: true,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: kDefaultRadius,
                                  color: kDark,
                                ),
                                width: 200.0,
                                height: 200.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 50,
                          height: 40.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.grey.shade200,
                            enabled: true,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: kDefaultRadius,
                                color: kDark,
                              ),
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 30.0,
                right: 30.0,
                bottom: 30.0,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade100,
                        highlightColor: Colors.grey.shade200,
                        enabled: true,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: kDefaultRadius,
                            color: kDark,
                          ),
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade200,
                              enabled: true,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: kDefaultRadius,
                                  color: kDark,
                                ),
                                width: 200.0,
                                height: 200.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 50,
                          height: 40.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.grey.shade200,
                            enabled: true,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: kDefaultRadius,
                                color: kDark,
                              ),
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade100,
                        highlightColor: Colors.grey.shade200,
                        enabled: true,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: kDefaultRadius,
                            color: kDark,
                          ),
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade200,
                              enabled: true,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: kDefaultRadius,
                                  color: kDark,
                                ),
                                width: 200.0,
                                height: 200.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 50,
                          height: 40.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.grey.shade200,
                            enabled: true,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: kDefaultRadius,
                                color: kDark,
                              ),
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
          if (snapshot.data == null) {
            return Container(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 30.0,
                right: 30.0,
                bottom: 30.0,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade100,
                        highlightColor: Colors.grey.shade200,
                        enabled: true,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: kDefaultRadius,
                            color: kDark,
                          ),
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade200,
                              enabled: true,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: kDefaultRadius,
                                  color: kDark,
                                ),
                                width: 200.0,
                                height: 200.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 50,
                          height: 40.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.grey.shade200,
                            enabled: true,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: kDefaultRadius,
                                color: kDark,
                              ),
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade100,
                        highlightColor: Colors.grey.shade200,
                        enabled: true,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: kDefaultRadius,
                            color: kDark,
                          ),
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.grey.shade200,
                              enabled: true,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: kDefaultRadius,
                                  color: kDark,
                                ),
                                width: 200.0,
                                height: 200.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 50,
                          height: 40.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.grey.shade200,
                            enabled: true,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: kDefaultRadius,
                                color: kDark,
                              ),
                              width: 200.0,
                              height: 200.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return Scrollbar(
            child: RefreshIndicator(
              onRefresh: () => refresh(),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemBuilder: (_, int index) {
                  final id = snapshot.data[index]["_id"];
                  final title = snapshot.data[index]["event"]["title"];
                  final location =
                      snapshot.data[index]["header"]["address"]["name"];

                  return Container(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 30.0,
                      right: 30.0,
                      bottom: 30.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CarouselSlider(
                          items:
                              images(snapshot.data[index]["event"]["images"]),
                          options: CarouselOptions(
                            height: 200,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 1,
                            enableInfiniteScroll: true,
                            reverse: false,
                            //autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 7),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10.0),
                                    Text(
                                      title,
                                      style: GoogleFonts.roboto(
                                        color: kDark.withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          value.format(
                                            int.parse(
                                              snapshot.data[index]["event"]
                                                  ["price"]["from"],
                                            ),
                                          ),
                                          style: GoogleFonts.roboto(
                                            color: kDark.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "  to  ",
                                          style: GoogleFonts.roboto(
                                            color: kDark.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          value.format(
                                            int.parse(
                                              snapshot.data[index]["event"]
                                                  ["price"]["to"],
                                            ),
                                          ),
                                          style: GoogleFonts.roboto(
                                            color: kDark.withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Entypo.location_pin,
                                          color: kDark.withOpacity(0.5),
                                          size: 12,
                                        ),
                                        Expanded(
                                          child: Text(
                                            location,
                                            style: GoogleFonts.roboto(
                                              color: kDark.withOpacity(0.5),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.0,
                                              height: 1.4,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                dialogDelete(
                                  context,
                                  action: () async {
                                    Get.back();
                                    await _eventCtrl.deleteEvent(id);
                                    await refresh();
                                  },
                                  message: "Do you wish to delete\n\"$title\"?",
                                );
                              },
                              splashRadius: 25.0,
                              icon: const Icon(
                                AntDesign.delete,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

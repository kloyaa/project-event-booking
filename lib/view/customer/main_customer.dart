import 'package:app/common/format_currency.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controller/bookingController.dart';
import 'package:app/controller/eventController.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:app/services/open_map.dart';
import 'package:app/view/common/oraganizer_list.dart';
import 'package:app/widget/button.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shimmer/shimmer.dart';

class ViewCustomerMain extends StatefulWidget {
  const ViewCustomerMain({Key? key}) : super(key: key);

  @override
  State<ViewCustomerMain> createState() => _ViewCustomerMainState();
}

class _ViewCustomerMainState extends State<ViewCustomerMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _userCtrl = Get.put(UserController());
  final _bookingCtrl = Get.put(BookingController());
  final _profileCtrl = Get.put(ProfileController());
  final _eventCtrl = Get.put(EventController());

  late Future _events;

  Future createBooking(data) async {
    BottomPicker.dateTime(
        title: "Event Date",
        titleStyle: GoogleFonts.roboto(
          color: kDark,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        height: Get.height * 0.70,
        pickerTextStyle: GoogleFonts.roboto(
          color: kDark,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
          height: 2.5,
        ),
        buttonText: "SUBMIT",
        buttonTextStyle: GoogleFonts.roboto(
          color: kWhite,
          fontWeight: FontWeight.w400,
          fontSize: 10.0,
        ),
        displayButtonIcon: false,
        buttonAlignement: MainAxisAlignment.end,
        buttonSingleColor: kDark,
        maxDateTime: DateTime(2022, 12, 30),
        onSubmit: (date) async {
          Get.toNamed("/loading");
          await _bookingCtrl.createBooking(
            {
              "header": {
                "customer": {
                  "accountId": _userCtrl.loginData["accountId"],
                  "avatar": _profileCtrl.profile["avatar"],
                  "name": {
                    "first": _profileCtrl.profile["name"]["first"],
                    "last": _profileCtrl.profile["name"]["last"]
                  },
                  "address": {
                    "name": _profileCtrl.profile["address"]["name"],
                    "coordinates": {
                      "latitude": _profileCtrl.profile["address"]["coordinates"]
                          ["latitude"],
                      "longitude": _profileCtrl.profile["address"]
                          ["coordinates"]["longitude"]
                    }
                  },
                  "contact": {
                    "email": _profileCtrl.profile["contact"]["email"],
                    "number": _profileCtrl.profile["contact"]["number"]
                  }
                },
                "planner": {
                  "accountId": data["header"]["accountId"],
                  "avatar": data["header"]["avatar"],
                  "name": {
                    "first": data["header"]["name"]["first"],
                    "last": data["header"]["name"]["last"]
                  },
                  "address": {
                    "name": data["header"]["address"]["name"],
                    "coordinates": {
                      "latitude": data["header"]["address"]["coordinates"]
                          ["latitude"],
                      "longitude": data["header"]["address"]["coordinates"]
                          ["longitude"]
                    }
                  },
                  "contact": {
                    "email": data["header"]["contact"]["email"],
                    "number": data["header"]["contact"]["number"]
                  }
                }
              },
              "event": {
                "title": data["event"]["title"],
                "details": data["event"]["details"],
                "images": data["event"]["images"],
                "price": {
                  "from": data["event"]["price"]["from"],
                  "to": data["event"]["price"]["to"]
                },
                "type": data["event"]["type"]
              },
              "payment": {"method": "cash", "status": "unpaid"},
              "status": "preparing",
              "date": {"event": date.toString()}
            },
          );
          Get.toNamed("/view-customer-bookings");
        }).show(context);
  }

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

  Future findLocation(data) async {
    final title = data["event"]["title"];
    final details = data["event"]["details"];

    await findInMap(
      Coords(
        double.parse(data["header"]["address"]["coordinates"]["latitude"]),
        double.parse(data["header"]["address"]["coordinates"]["longitude"]),
      ),
      title: title,
      description: details,
    );
  }

  Future previewPost(data) async {
    final id = data["_id"];
    final title = data["event"]["title"];
    final details = data["event"]["details"];
    final avatar = data["header"]["avatar"];
    final firstName = data["header"]["name"]["first"];

    final location = data["header"]["address"]["name"];
    final distance = data["distance"];
    final priceStart = data["event"]["price"]["from"];
    final priceEnd = data["event"]["price"]["to"];

    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(17.0),
            topRight: Radius.circular(17.0),
          ),
        ),
        height: Get.height * 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    color: kDark.withOpacity(0.5),
                    borderRadius: kDefaultRadius,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            CarouselSlider(
              items: images(data["event"]["images"]),
              options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: 2,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(
                  milliseconds: 800,
                ),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {},
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20),
              child: Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return const Icon(
                        Entypo.star,
                        color: Colors.orange,
                        size: 18,
                      );
                    }),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "4.9 (7,312)",
                    style: GoogleFonts.roboto(
                      color: kDark.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    distance,
                    style: GoogleFonts.roboto(
                      color: kDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 40,
                bottom: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10.0),
                        Text(
                          title,
                          style: GoogleFonts.roboto(
                            color: kDark.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 17.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              value.format(
                                int.parse(priceStart),
                              ),
                              style: GoogleFonts.roboto(
                                color: kDark.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "  to  ",
                              style: GoogleFonts.roboto(
                                color: kDark.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              value.format(
                                int.parse(priceEnd),
                              ),
                              style: GoogleFonts.roboto(
                                color: kDark.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          location,
                          style: GoogleFonts.roboto(
                            color: kDark.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40,
                      bottom: 40,
                    ),
                    child: Text(
                      details,
                      style: GoogleFonts.roboto(
                        color: kDark.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProfileAvatar(avatar),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        firstName,
                        style: GoogleFonts.roboto(
                          color: kDark.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return const Icon(
                              Entypo.star,
                              color: Colors.orange,
                              size: 10,
                            );
                          }),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "4.8/5",
                          style: GoogleFonts.roboto(
                            color: kDark.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                            fontSize: 9.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40,
                      bottom: 10,
                      top: 10.0,
                    ),
                    child: elevatedButton(
                      btnColor: kDark,
                      labelColor: kWhite,
                      label: "BOOK EVENT",
                      function: () async => await createBooking(data),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future refresh() async {
    setState(() {
      _events = _eventCtrl.getNearbyEvents();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _events = _eventCtrl.getNearbyEvents();
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
            onTap: () => Get.toNamed("/view-customer-bookings"),
            leading: const Icon(
              MaterialIcons.book_online,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "My Event Bookings",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
          ListTile(
            onTap: () => Get.toNamed("/view-customer-billing"),
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
          // ListTile(
          //   onTap: () {},
          //   leading: const Icon(
          //     AntDesign.mail,
          //     size: 20.0,
          //     color: kDark,
          //   ),
          //   title: Text(
          //     "Inbox",
          //     style: GoogleFonts.roboto(
          //       fontSize: 12.0,
          //       color: kDark,
          //     ),
          //   ),
          // ),
          const Spacer(),
          const Divider(),
          const Spacer(flex: 5),
          ListTile(
            onTap: () => Get.to(() => const ViewOrganizerList()),
            leading: const Icon(
              Entypo.tools,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Event Organizers",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                color: kDark,
              ),
            ),
          ),
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: appBar,
        drawer: drawer,
        backgroundColor: kLight,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: FutureBuilder(
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
                          final distance = snapshot.data[index]["distance"];

                          return GestureDetector(
                            onTap: () async =>
                                await previewPost(snapshot.data[index]),
                            child: Container(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 30 : 0,
                                left: 30.0,
                                right: 30.0,
                                bottom: 30.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      CarouselSlider(
                                        items: images(snapshot.data[index]
                                            ["event"]["images"]),
                                        options: CarouselOptions(
                                          height: 200,
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 1,
                                          initialPage: 1,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          //autoPlay: true,
                                          autoPlayInterval:
                                              const Duration(seconds: 7),
                                          autoPlayAnimationDuration:
                                              const Duration(
                                            milliseconds: 800,
                                          ),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          onPageChanged: (index, reason) {},
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                      Positioned.fill(
                                        bottom: 5,
                                        left: 5,
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            height: 30,
                                            width: Get.width * 0.60,
                                            decoration: BoxDecoration(
                                              color: kLight.withOpacity(0.8),
                                              borderRadius: kDefaultRadius,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  value.format(
                                                    int.parse(
                                                      snapshot.data[index]
                                                              ["event"]["price"]
                                                          ["from"],
                                                    ),
                                                  ),
                                                  style: GoogleFonts.roboto(
                                                    color: kDark,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10.0,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "  to  ",
                                                  style: GoogleFonts.roboto(
                                                    color:
                                                        kDark.withOpacity(0.8),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10.0,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  value.format(
                                                    int.parse(
                                                      snapshot.data[index]
                                                              ["event"]["price"]
                                                          ["to"],
                                                    ),
                                                  ),
                                                  style: GoogleFonts.roboto(
                                                    color: kDark,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10.0,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10.0),
                                              Text(
                                                title,
                                                style: GoogleFonts.roboto(
                                                  color: kDark.withOpacity(0.8),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13.0,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    distance + " - ",
                                                    style: GoogleFonts.roboto(
                                                      color: kDark
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10.0,
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 2.0),
                                                  Icon(
                                                    Entypo.location_pin,
                                                    color:
                                                        kDark.withOpacity(0.5),
                                                    size: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      location,
                                                      style: GoogleFonts.roboto(
                                                        color: kDark
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 10.0,
                                                        height: 1.4,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children:
                                                    List.generate(5, (index) {
                                                  return const Icon(
                                                    Entypo.star,
                                                    color: Colors.orange,
                                                    size: 8,
                                                  );
                                                }),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async =>
                                            await findLocation(
                                                snapshot.data[index]),
                                        splashRadius: 25.0,
                                        icon: const Icon(
                                          Ionicons.location_outline,
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

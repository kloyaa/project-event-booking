import 'package:app/common/direct_call.dart';
import 'package:app/common/formatPrint.dart';
import 'package:app/common/format_currency.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controller/bookingController.dart';
import 'package:app/controller/eventController.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:app/services/open_map.dart';
import 'package:app/view/billing/pay.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shimmer/shimmer.dart';

class ViewCustomerBookings extends StatefulWidget {
  const ViewCustomerBookings({Key? key}) : super(key: key);

  @override
  State<ViewCustomerBookings> createState() => _ViewCustomerBookingsState();
}

class _ViewCustomerBookingsState extends State<ViewCustomerBookings>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TabController? _tabController;
  String _currentStatus = "preparing";

  final _userCtrl = Get.put(UserController());
  final _bookingCtrl = Get.put(BookingController());
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

  Future findLocation(data) async {
    final title = data["event"]["title"];
    final details = data["event"]["details"];

    await findInMap(
      Coords(
        double.parse(
          data["header"]["planner"]["address"]["coordinates"]["latitude"],
        ),
        double.parse(
          data["header"]["planner"]["address"]["coordinates"]["longitude"],
        ),
      ),
      title: title,
      description: details,
    );
  }

  Future previewPost(data) async {
    final id = data["_id"];
    final title = data["event"]["title"];
    final details = data["event"]["details"];

    final location = data["header"]["planner"]["address"]["name"];
    final number = data["header"]["planner"]["contact"]["number"];

    final avatar = data["header"]["planner"]["avatar"];
    final status = data["status"];

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
        height: Get.height * 0.80,
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
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.only(
                left: 40.0,
                right: 40.0,
                bottom: 10.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProfileAvatar(avatar),
                      ),
                      const SizedBox(height: 5),
                      status == "in-progress"
                          ? IconButton(
                              onPressed: () async => await callNumber(number),
                              icon: const Icon(
                                Feather.phone_call,
                                color: kDark,
                                size: 22,
                              ),
                            )
                          : const SizedBox(),
                      IconButton(
                        onPressed: () async => await findLocation(data),
                        icon: const Icon(
                          Ionicons.location_outline,
                          color: kDark,
                          size: 22,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return const Icon(
                                  Entypo.star,
                                  color: Colors.orange,
                                  size: 12,
                                );
                              }),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "4.9 (7,312)",
                              style: GoogleFonts.roboto(
                                color: kDark.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 10.0,
                                height: 1.4,
                              ),
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
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 150,
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future refresh() async {
    setState(() {
      _events = _bookingCtrl.getCustomerBookings(
        {
          "accountId": _userCtrl.loginData["accountId"],
          "status": _currentStatus
        },
      );
    });
  }

  Future changeStatus(int index) async {
    String status = "";
    if (index == 0) {
      status = "preparing";
    }
    if (index == 1) {
      status = "in-progress";
    }
    if (index == 2) {
      status = "completed";
    }
    if (index == 3) {
      status = "cancelled";
    }
    setState(() {
      _currentStatus = status;
      _events = _bookingCtrl.getCustomerBookings(
        {
          "accountId": _userCtrl.loginData["accountId"],
          "status": _currentStatus
        },
      );
    });
  }

  Future updateBookingStatus(body) async {
    await _bookingCtrl.updateBookingStatus(body);
    await refresh();
  }

  Future payBooking(data) async {
    Get.toNamed("/loading");
    formatPrint("payBooking", data);
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(
        () => ViewPayOnline({
          "_id": data["_id"],
          "header": {
            "customer": {
              "accountId": data["header"]["customer"]["accountId"],
              "name": {
                "first": data["header"]["customer"]["name"]["first"],
                "last": data["header"]["customer"]["name"]["last"],
              }
            },
            "planner": {
              "accountId": data["header"]["planner"]["accountId"],
              "name": {
                "first": data["header"]["planner"]["name"]["first"],
                "last": data["header"]["planner"]["name"]["last"],
              }
            }
          },
        }),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _events = _bookingCtrl.getCustomerBookings(
      {"accountId": _userCtrl.loginData["accountId"], "status": "preparing"},
    );
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
          ListTile(
            onTap: () {},
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
            onTap: () {},
            leading: const Icon(
              AntDesign.message1,
              size: 20.0,
              color: kDark,
            ),
            title: Text(
              "Messages",
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
      leading: IconButton(
        onPressed: () => Get.toNamed("/view-main-customer"),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kDark,
        ),
      ),
      title: Text(
        "MY BOOKINGS",
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
      bottom: TabBar(
        indicatorColor: kDark, //Default Color of Indicator
        labelColor: kDark, // Base color of texts
        labelStyle: GoogleFonts.roboto(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 10,
          fontWeight: FontWeight.w300,
        ),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        isScrollable: true,
        tabs: const [
          Tab(text: "Pending"),
          Tab(text: "Preparing"),
          Tab(text: "Completed"),
          Tab(text: "Cancelled"),
        ],
        onTap: (value) async => await changeStatus(value),
        controller: _tabController,
      ),
    );

    return Scaffold(
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
                        final data = snapshot.data[index];
                        final title = snapshot.data[index]["event"]["title"];

                        final date = snapshot.data[index]["date"]["event"];
                        final dateUpdated =
                            snapshot.data[index]["date"]["updatedAt"];
                        final eventImages =
                            snapshot.data[index]["event"]["images"];
                        final status = snapshot.data[index]["status"];
                        final paymentStatus =
                            snapshot.data[index]["payment"]["status"];

                        return GestureDetector(
                          onTap: () async => await previewPost(data),
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
                                CarouselSlider(
                                  items: images(eventImages),
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
                                    autoPlayAnimationDuration: const Duration(
                                      milliseconds: 800,
                                    ),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, reason) {},
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 4,
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
                                            _currentStatus == "cancelled"
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesome
                                                            .calendar_times_o,
                                                        color: kDark
                                                            .withOpacity(0.5),
                                                        size: 10,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Expanded(
                                                        child: Text(
                                                          Jiffy(dateUpdated)
                                                              .yMMMMEEEEdjm,
                                                          style: GoogleFonts
                                                              .roboto(
                                                            color: kDark
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10.0,
                                                            height: 1.4,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            _currentStatus == "preparing"
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            AntDesign.calendar,
                                                            color: kDark
                                                                .withOpacity(
                                                                    0.5),
                                                            size: 10,
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              Jiffy(date)
                                                                  .yMMMMEEEEdjm,
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                color: kDark
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 10.0,
                                                                height: 1.4,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            _currentStatus == "in-progress"
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        AntDesign.calendar,
                                                        color: kDark
                                                            .withOpacity(0.5),
                                                        size: 10,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Expanded(
                                                        child: Text(
                                                          Jiffy(date)
                                                              .yMMMMEEEEdjm,
                                                          style: GoogleFonts
                                                              .roboto(
                                                            color: kDark
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10.0,
                                                            height: 1.4,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            _currentStatus == "completed"
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        AntDesign.calendar,
                                                        color: kDark
                                                            .withOpacity(0.5),
                                                        size: 10,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      Expanded(
                                                        child: Text(
                                                          Jiffy(date)
                                                              .yMMMMEEEEdjm,
                                                          style: GoogleFonts
                                                              .roboto(
                                                            color: kDark
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10.0,
                                                            height: 1.4,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    status == "preparing"
                                        ? IconButton(
                                            onPressed: () {
                                              dialogDelete(context,
                                                  message:
                                                      "Do you wish to cancel your \nbooking for $title?",
                                                  action: () {
                                                Get.back();
                                                updateBookingStatus({
                                                  "_id": id,
                                                  "status": "cancelled"
                                                });
                                              });
                                            },
                                            icon: const Icon(
                                              AntDesign.closecircle,
                                              color: kDark,
                                            ),
                                          )
                                        : const SizedBox(),
                                    status == "in-progress"
                                        ? paymentStatus == "unpaid"
                                            ? Expanded(
                                                child: SizedBox(
                                                  height: 40.0,
                                                  child: elevatedButton(
                                                    btnColor: kDark,
                                                    labelColor: kWhite,
                                                    label: "PAY",
                                                    function: () async =>
                                                        await payBooking(
                                                      snapshot.data[index],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()
                                        : const SizedBox(),
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
    );
  }
}

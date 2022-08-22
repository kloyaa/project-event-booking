import 'package:app/common/direct_call.dart';
import 'package:app/common/formatPrint.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controller/bookingController.dart';
import 'package:app/controller/eventController.dart';
import 'package:app/controller/profileController.dart';
import 'package:app/controller/userController.dart';
import 'package:app/widget/button.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';

class ViewPlannerBookings extends StatefulWidget {
  const ViewPlannerBookings({Key? key}) : super(key: key);

  @override
  State<ViewPlannerBookings> createState() => _ViewPlannerBookingsState();
}

class _ViewPlannerBookingsState extends State<ViewPlannerBookings>
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

  Future<void> updateBookingStatus(body) async {
    Get.back();
    await _bookingCtrl.updateBookingStatus(body);
    await refresh();
  }

  Future<void> previewPost(data) async {
    final cusAddress = data["header"]["customer"]["address"]["name"];
    final number = data["header"]["customer"]["contact"]["number"];

    final avatar = data["header"]["customer"]["avatar"];
    final cusName = data["header"]["customer"]["name"]["first"] +
        ", " +
        data["header"]["customer"]["name"]["last"];
    final status = data["status"];
    final paymentStatus = data["payment"]["status"];

    final id = data["_id"];

    if (status == "preparing") {
      return Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          decoration: const BoxDecoration(
            color: kLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17.0),
              topRight: Radius.circular(17.0),
            ),
          ),
          height: Get.height * 0.96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              CircularProfileAvatar(
                avatar,
                radius: 80,
              ),
              const SizedBox(height: 40),
              Text(
                cusName,
                style: GoogleFonts.roboto(
                  color: kDark.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: Get.width * 0.50,
                child: Text(
                  cusAddress,
                  style: GoogleFonts.roboto(
                    color: kDark.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    fontSize: 11.0,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async => await callNumber(number),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Feather.phone_call,
                      color: kDark,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Call",
                      style: GoogleFonts.roboto(
                        color: kDark.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              elevatedButton(
                btnColor: Colors.green,
                labelColor: kWhite,
                label: "ACCEPT",
                function: () async => await updateBookingStatus({
                  "_id": id,
                  "status": "in-progress",
                }),
              ),
              const SizedBox(height: 5),
              elevatedButton(
                btnColor: kWhite,
                labelColor: kDanger,
                label: "CANCEL BOOKING",
                function: () async => await updateBookingStatus({
                  "_id": id,
                  "status": "cancelled",
                }),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    }

    if (status == "in-progress") {
      return Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          decoration: const BoxDecoration(
            color: kLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17.0),
              topRight: Radius.circular(17.0),
            ),
          ),
          height: Get.height * 0.96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              CircularProfileAvatar(
                avatar,
                radius: 80,
              ),
              const SizedBox(height: 40),
              Text(
                cusName,
                style: GoogleFonts.roboto(
                  color: kDark.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: Get.width * 0.50,
                child: Text(
                  cusAddress,
                  style: GoogleFonts.roboto(
                    color: kDark.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    fontSize: 11.0,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async => await callNumber(number),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Feather.phone_call,
                      color: kDark,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Call",
                      style: GoogleFonts.roboto(
                        color: kDark.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              paymentStatus == "paid"
                  ? elevatedButton(
                      btnColor: Colors.green,
                      labelColor: kWhite,
                      label: "EVENT ENDED",
                      function: () async => await updateBookingStatus({
                        "_id": id,
                        "status": "completed",
                      }),
                    )
                  : elevatedButton(
                      btnColor: kDanger,
                      labelColor: kWhite,
                      label: "EVENT CANCELLED",
                      function: () async => await updateBookingStatus({
                        "_id": id,
                        "status": "cancelled",
                      }),
                    ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    }
  }

  Future<void> refresh() async {
    setState(() {
      _events = _bookingCtrl.getPlannerBookings(
        {
          "accountId": _userCtrl.loginData["accountId"],
          "status": _currentStatus
        },
      );
    });
  }

  Future<void> changeStatus(int index) async {
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

    setState(() {
      _currentStatus = status;
      _events = _bookingCtrl.getPlannerBookings(
        {
          "accountId": _userCtrl.loginData["accountId"],
          "status": _currentStatus
        },
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _events = _bookingCtrl.getPlannerBookings(
      {"accountId": _userCtrl.loginData["accountId"], "status": "preparing"},
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kLight,
      leading: IconButton(
        onPressed: () => Get.toNamed("/view-main-planner"),
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
          Tab(text: "In-Progress"),
          Tab(text: "Completed"),
        ],
        onTap: (value) async => await changeStatus(value),
        controller: _tabController,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
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
                          for (int i = 0; i < 10; i++)
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: Get.width,
                              height: 50.0,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade200,
                                enabled: true,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: kDefaultRadius,
                                    color: kDark,
                                  ),
                                  width: 100.0,
                                  height: 50.0,
                                ),
                              ),
                            )
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
                          for (int i = 0; i < 10; i++)
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: Get.width,
                              height: 50.0,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade200,
                                enabled: true,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: kDefaultRadius,
                                    color: kDark,
                                  ),
                                  width: 100.0,
                                  height: 50.0,
                                ),
                              ),
                            )
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
                          for (int i = 0; i < 10; i++)
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: Get.width,
                              height: 50.0,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade100,
                                highlightColor: Colors.grey.shade200,
                                enabled: true,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: kDefaultRadius,
                                    color: kDark,
                                  ),
                                  width: 100.0,
                                  height: 50.0,
                                ),
                              ),
                            )
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
                        final data = snapshot.data[index];
                        final cusName = snapshot.data[index]["header"]
                                ["customer"]["name"]["first"] +
                            ", " +
                            snapshot.data[index]["header"]["customer"]["name"]
                                ["last"];

                        final date = snapshot.data[index]["date"]["event"];

                        final status = snapshot.data[index]["status"];
                        final paymentStatus =
                            snapshot.data[index]["payment"]["status"];

                        return GestureDetector(
                          onTap: () async => await previewPost(data),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 30 : 0,
                              left: 30.0,
                              right: 30.0,
                              bottom: 13.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                              cusName,
                                              style: GoogleFonts.roboto(
                                                color: kDark.withOpacity(0.8),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13.0,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
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
                                    status == "in-progress"
                                        ? Expanded(
                                            child: Container(
                                              color: paymentStatus == "paid"
                                                  ? Colors.green
                                                  : Colors.grey,
                                              height: 25.0,
                                              child: Center(
                                                child: Text(
                                                  paymentStatus
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: kWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
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

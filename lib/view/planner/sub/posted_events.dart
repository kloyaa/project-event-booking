import 'package:app/common/format_currency.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controller/eventController.dart';
import 'package:app/widget/dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ViewPostedEvents extends StatefulWidget {
  const ViewPostedEvents({Key? key}) : super(key: key);

  @override
  State<ViewPostedEvents> createState() => _ViewPostedEventsState();
}

class _ViewPostedEventsState extends State<ViewPostedEvents> {
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
    final appBar = AppBar(
      backgroundColor: kWhite,
      leading: IconButton(
        onPressed: () => Get.toNamed("/view-main-planner"),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kDark,
        ),
      ),
      title: Text(
        "MY EVENTS",
        style: GoogleFonts.roboto(
          color: kDark,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
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

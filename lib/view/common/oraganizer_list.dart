import 'package:app/common/direct_call.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controller/globalController.dart';
import 'package:app/controller/profileController.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../organizer/sub/sub/gallery_preview.dart';

class ViewOrganizerList extends StatefulWidget {
  const ViewOrganizerList({Key? key}) : super(key: key);

  @override
  State<ViewOrganizerList> createState() => _ViewOrganizerListState();
}

class _ViewOrganizerListState extends State<ViewOrganizerList> {
  final _profileCtrl = Get.put(ProfileController());
  final _globalCtrl = Get.put(GlobalController());

  late Future _organizers;

  Future<void> refresh() async {
    setState(() {
      _organizers = _profileCtrl.getEventOrganizers();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _organizers = _profileCtrl.getEventOrganizers();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kLight,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Ionicons.arrow_back,
          color: kDark,
        ),
      ),
      title: Text(
        "Event Organizers",
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
    return Scaffold(
      appBar: appBar,
      backgroundColor: kLight,
      body: FutureBuilder(
        future: _organizers,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  for (int i = 0; i < 10; i++)
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: Get.width,
                      height: 240.0,
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
                          height: 240.0,
                        ),
                      ),
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
                  for (int i = 0; i < 10; i++)
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: Get.width,
                      height: 240.0,
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
                          height: 240.0,
                        ),
                      ),
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
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                final data = snapshot.data[index];
                var avatar = data["avatar"];
                var name = "${data["name"]["first"]}, ${data["name"]["last"]}";
                var address = data["address"]["name"];
                var gallery = data["gallery"];
                var links = data["links"];

                final number = data["contact"]["number"];

                if (gallery.length == 0) {
                  return const SizedBox();
                }
                if (links.length == 0) {
                  return const SizedBox();
                }
                return Container(
                  margin: EdgeInsets.only(top: index == 0 ? 0 : 10.0),
                  padding: const EdgeInsets.all(20.0),
                  color: kWhite,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: avatar == null
                                ? Container(
                                    color: kDark,
                                    child: Image.asset(
                                      "images/empty-avatar.png",
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    color: kDark,
                                    child: Image.network(
                                      avatar,
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.60,
                                child: Text(
                                  name,
                                  style: GoogleFonts.roboto(
                                    color: kDark,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.60,
                                child: Text(
                                  address,
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: List.generate(5, (index) {
                                  return const Icon(
                                    Entypo.star,
                                    color: Colors.orange,
                                    size: 8,
                                  );
                                }),
                              ),
                            ],
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async => await callNumber(number),
                              icon: const Icon(
                                Feather.phone_call,
                                color: kDark,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        height: 70,
                        child: ListView.builder(
                          itemCount: gallery.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemBuilder: (context, int index) {
                            final data = gallery[index];
                            return GestureDetector(
                              onTap: () {
                                _globalCtrl.selectedPhoto = data;
                                Get.to(() => const ViewGalleryPreview());
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 2.0),
                                color: kDark,
                                child: Hero(
                                  tag: data["id"],
                                  child: Image.network(
                                    gallery[index]["url"],
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        height: 56.0,
                        child: ListView.builder(
                          itemCount: links.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemBuilder: (context, int index) {
                            final data = links[index];
                            final url = links[index]["url"];

                            return GestureDetector(
                              onTap: () async {
                                if (!await launchUrl(Uri.parse(url))) {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: kDefaultRadius,
                                  color: kLight,
                                ),
                                margin: const EdgeInsets.only(right: 2.0),
                                width: 170,
                                child: ListTile(
                                  title: Text(
                                    data["title"],
                                    style: GoogleFonts.roboto(
                                      color: kDark,
                                      fontSize: 10.0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: IconButton(
                                    icon: const Icon(
                                      MaterialCommunityIcons.launch,
                                      color: kDark,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:app/const/colors.dart';
import 'package:app/controller/globalController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class ViewGalleryPreview extends StatefulWidget {
  const ViewGalleryPreview({Key? key}) : super(key: key);

  @override
  State<ViewGalleryPreview> createState() => _ViewGalleryPreviewState();
}

class _ViewGalleryPreviewState extends State<ViewGalleryPreview> {
  final _globalCtrl = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          AntDesign.close,
          color: kWhite,
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Hero(
              tag: _globalCtrl.selectedPhoto["id"],
              child: CachedNetworkImage(
                imageUrl: _globalCtrl.selectedPhoto["url"],
                width: Get.width,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _globalCtrl.selectedPhoto["description"],
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Posted ${Jiffy(_globalCtrl.selectedPhoto["date"]["createdAt"]).fromNow()}",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

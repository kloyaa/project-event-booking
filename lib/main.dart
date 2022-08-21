import 'package:app/const/colors.dart';
import 'package:app/view/account/login.dart';
import 'package:app/view/account/registration.dart';
import 'package:app/view/customer/main_customer.dart';
import 'package:app/view/customer/sub/my_billings.dart';
import 'package:app/view/customer/sub/my_bookings.dart';
import 'package:app/view/loading.dart';
import 'package:app/view/organizer/main_organizer.dart';
import 'package:app/view/organizer/sub/gallery.dart';
import 'package:app/view/organizer/sub/social_links.dart';
import 'package:app/view/organizer/sub/sub/gallery_preview.dart';
import 'package:app/view/planner/main_planner.dart';
import 'package:app/view/planner/sub/create_events.dart';
import 'package:app/view/planner/sub/my_billings.dart';
import 'package:app/view/planner/sub/my_bookings.dart';
import 'package:app/view/planner/sub/posted_events.dart';
import 'package:app/view/profile/create_profile.dart';
import 'package:app/view/profile/view_profile.dart';
import 'package:app/view/txn_successfull.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Event Booking',
      theme: ThemeData(primarySwatch: kPrimary),
      initialRoute: "/login",
      getPages: [
        GetPage(
          name: "/loading",
          page: () => const Loading(),
        ),
        GetPage(
          name: "/login",
          page: () => const ViewLogin(),
        ),
        GetPage(
          name: "/registration",
          page: () => const ViewRegistration(),
        ),
        GetPage(
          name: "/view-create-profile",
          page: () => const ViewCreateProfile(),
        ),
        GetPage(
          name: "/view-main-planner",
          page: () => const ViewPlannerMain(),
        ),
        GetPage(
          name: "/view-main-customer",
          page: () => const ViewCustomerMain(),
        ),
        GetPage(
          name: "/view-main-organizer",
          page: () => const ViewOrganizerMain(),
        ),
        GetPage(
          name: "/view-profile",
          page: () => const ViewProfile(),
        ),
        GetPage(
          name: "/view-planner-create-event",
          page: () => const ViewCreateEvents(),
        ),
        GetPage(
          name: "/view-planner-posted-events",
          page: () => const ViewPostedEvents(),
        ),
        GetPage(
          name: "/view-planner-billing",
          page: () => const ViewPlannerBilling(),
        ),
        GetPage(
          name: "/view-customer-bookings",
          page: () => const ViewCustomerBookings(),
        ),
        GetPage(
          name: "/view-customer-billing",
          page: () => const ViewCustomerBilling(),
        ),
        GetPage(
          name: "/view-planner-bookings",
          page: () => const ViewPlannerBookings(),
        ),
        GetPage(
          name: "/view-txn-success",
          page: () => const ViewTxnSuccess(),
        ),
        GetPage(
          name: "/view-social-links",
          page: () => const ViewSocialLinks(),
        ),
        GetPage(
          name: "/view-gallery",
          page: () => const ViewGallery(),
        ),   GetPage(
          name: "/view-photo-preview",
          page: () => const ViewGalleryPreview(),
        ),
      ],
    );
  }
}

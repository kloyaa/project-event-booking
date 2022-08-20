import 'package:app/const/colors.dart';
import 'package:app/controller/billingController.dart';
import 'package:app/controller/profileController.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';

class ViewCustomerBilling extends StatefulWidget {
  const ViewCustomerBilling({Key? key}) : super(key: key);

  @override
  State<ViewCustomerBilling> createState() => _ViewCustomerBillingState();
}

class _ViewCustomerBillingState extends State<ViewCustomerBilling> {
  final _profileCtrl = Get.put(ProfileController());
  final _billingCtrl = Get.put(BillingController());

  late Future _billings;

  Future refresh() async {
    setState(() {
      _billings = _billingCtrl.getCustomerBilling(
        _profileCtrl.profile["accountId"],
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _billings = _billingCtrl.getCustomerBilling(
      _profileCtrl.profile["accountId"],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        "Transaction History",
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
        future: _billings,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  for (int i = 0; i < 10; i++)
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      width: Get.width,
                      height: 140.0,
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
                          height: 140.0,
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
                      margin: const EdgeInsets.only(top: 5.0),
                      width: Get.width,
                      height: 140.0,
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
                          height: 140.0,
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

          return ListView.builder(
            itemBuilder: (context, int index) {
              final title = snapshot.data[index]["header"]["customer"]["name"]
                      ["first"] +
                  " paid " +
                  snapshot.data[index]["header"]["planner"]["name"]["first"];
              final cardNumber =
                  snapshot.data[index]["content"]["paymentDetails"]["number"];
              final recipientNumber = snapshot.data[index]["content"]
                  ["paymentDetails"]["recipientNumber"];
              final amount = snapshot.data[index]["content"]["amount"];
              final date = snapshot.data[index]["date"]["createdAt"];

              return Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: ListTile(
                  tileColor: kWhite,
                  contentPadding: const EdgeInsets.all(20.0),
                  title: Text(
                    title,
                    style: GoogleFonts.roboto(
                      color: kDark.withOpacity(0.6),
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(
                              AntDesign.creditcard,
                              color: kDark.withOpacity(0.6),
                              size: 10.0,
                            ),
                          ),
                          Text(
                            cardNumber,
                            style: GoogleFonts.roboto(
                              color: kDark.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 10.0,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Icon(
                              AntDesign.arrowright,
                              color: kDark.withOpacity(0.6),
                              size: 10.0,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(
                              AntDesign.creditcard,
                              color: kDark.withOpacity(0.6),
                              size: 10.0,
                            ),
                          ),
                          Text(
                            recipientNumber,
                            style: GoogleFonts.roboto(
                              color: kDark.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(
                        "P$amount",
                        style: GoogleFonts.robotoMono(
                          color: kDark.withOpacity(0.6),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      Text(
                        Jiffy(date).yMMMEdjm,
                        style: GoogleFonts.roboto(
                          color: kDark.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: snapshot.data.length,
          );
        },
      ),
    );
  }
}

import 'package:app/common/destroyFormFocus.dart';
import 'package:app/common/formatPrint.dart';
import 'package:app/const/colors.dart';
import 'package:app/const/material.dart';
import 'package:app/controller/billingController.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form_billing.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future createEventPrompt() {
  return Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(17.0),
          topRight: Radius.circular(17.0),
        ),
      ),
      height: Get.height * 0.40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            children: [
              const Icon(Fontisto.info, size: 16),
              const SizedBox(width: 5),
              Text(
                "Booking Standards",
                style: GoogleFonts.roboto(
                  color: kDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "To meet your client's expectations of the event location, we require you to go to the exact location when creating this event and take real pictures rather than downloading them from the internet.",
            style: GoogleFonts.roboto(
              color: kDark,
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "You may have noticed that we do not allow manual location. We do this to avoid fraudulent events and maintain a healthy community. Failure to comply may result in problems with your account.",
            style: GoogleFonts.roboto(
              color: kDark,
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    ),
  );
}

Future paymentPrompt() {
  return Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(17.0),
          topRight: Radius.circular(17.0),
        ),
      ),
      height: Get.height * 0.20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Entypo.warning, size: 16),
              const SizedBox(width: 5),
              Text(
                "Payment Caution",
                style: GoogleFonts.roboto(
                  color: kDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "A money transfer is irreversible and cannot be refunded by laservv. Please let the recipient know if you believe there has been an error or a payment issue.",
            style: GoogleFonts.roboto(
              color: kDark,
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    ),
  );
}

Future paymentAuthenticationPrompt(
  context, {
  required card,
  required body,
  required TextEditingController controller,
  required FocusNode focusNode,
  required TextEditingController amountController,
  required FocusNode amountFocusNode,
}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(17.0),
          topRight: Radius.circular(17.0),
        ),
        // side: BorderSide(color: Colors.red),
      ),
      builder: (BuildContext context) {
        bool hasError = false;

        return StatefulBuilder(builder: (context, StateSetter newState) {
          return GestureDetector(
            onTap: () => destroyFormFocus(context),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              height: Get.height * 0.96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 20),
                  CreditCardWidget(
                    cardNumber: card["number"],
                    expiryDate: card["expiry"],
                    cardHolderName: card["name"],
                    cvvCode: card["cvv"],
                    bankName: 'E-PAY',
                    showBackView: false,
                    cardBgColor: Colors.black,
                    glassmorphismConfig: Glassmorphism.defaultConfig(),
                    backgroundImage: 'images/card_bg.png',
                    //backgroundNetworkImage: 'image-url',
                    obscureCardNumber: false,
                    obscureCardCvv: false,
                    isHolderNameVisible: true,
                    textStyle: GoogleFonts.roboto(
                      color: Colors.yellow,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                    height: 175,
                    width: MediaQuery.of(context).size.width,
                    isChipVisible: true,
                    isSwipeGestureEnabled: true,
                    animationDuration: const Duration(milliseconds: 1000),
                    customCardTypeIcons: <CustomCardTypeIcon>[
                      CustomCardTypeIcon(
                        cardType: CardType.mastercard,
                        cardImage: Image.asset(
                          'images/mastercard.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                    ],
                    onCreditCardWidgetChange: (v) {},
                  ),
                  const SizedBox(height: 15),
                  inputNumberField(
                    controller: controller,
                    focusNode: focusNode,
                    color: kWhite,
                    labelText: "Recipient Card Number",
                    textFieldStyle: GoogleFonts.roboto(
                      color: kDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
                    hasError: hasError,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  inputNumberField(
                    controller: amountController,
                    focusNode: amountFocusNode,
                    color: kWhite,
                    labelText: "Amount",
                    textFieldStyle: GoogleFonts.roboto(
                      color: kDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
                    hasError: hasError,
                    obscureText: false,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Icon(Fontisto.info, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        "Transaction Fee",
                        style: GoogleFonts.roboto(
                          color: kDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "The recipient will only receive 97.75% of your payment after subtracting a 2.25% fee, and for our card validation feature, it might take several hours for processing before they will receive the desired amount.",
                    style: GoogleFonts.roboto(
                      color: kDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
                  ),
                  const Spacer(),
                  elevatedButton(
                    label: "PAY NOW",
                    function: () async {
                      final ccValidator = CreditCardValidator();
                      final ccNumResults = ccValidator.validateCCNum(
                        controller.text.replaceAll(' ', ''),
                      );

                      if (!ccNumResults.isValid) {
                        return newState(() {
                          hasError = true;
                        });
                      }
                      Get.toNamed("/loading");
                      final billingCtrl = Get.put(BillingController());

                      await billingCtrl.createBilling({
                        "_id": body["_id"],
                        "header": {
                          "customer": {
                            "accountId": body["header"]["customer"]
                                ["accountId"],
                            "name": {
                              "first": body["header"]["customer"]["name"]
                                  ["first"],
                              "last": body["header"]["customer"]["name"]
                                  ["last"],
                            }
                          },
                          "planner": {
                            "accountId": body["header"]["planner"]["accountId"],
                            "name": {
                              "first": body["header"]["planner"]["name"]
                                  ["first"],
                              "last": body["header"]["planner"]["name"]["last"],
                            }
                          }
                        },
                        "content": {
                          "paymentMethod": "card",
                          "paymentDetails": {
                            "name": card["name"],
                            "cvv": card["cvv"],
                            "expiry": card["expiry"],
                            "number": card["number"],
                            "recipientNumber": controller.text.trim(),
                          },
                          "amount": amountController.text.trim()
                        }
                      });
                      Get.toNamed("/view-txn-success");
                      Future.delayed(const Duration(seconds: 3), () {
                        Get.toNamed("/view-main-customer");
                      });
                    },
                    btnColor: kDark,
                    labelColor: kWhite,
                  ),
                ],
              ),
            ),
          );
        });
      });
}

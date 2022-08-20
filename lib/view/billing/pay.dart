import 'package:app/common/destroyFormFocus.dart';
import 'package:app/common/formatPrint.dart';
import 'package:app/const/bottomsheet_prompt.dart';
import 'package:app/const/colors.dart';
import 'package:app/widget/button.dart';
import 'package:app/widget/form_billing.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:extended_masked_text/extended_masked_text.dart' as masknumber;

import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewPayOnline extends StatefulWidget {
  final Map data;
  const ViewPayOnline(this.data, {Key? key}) : super(key: key);

  @override
  State<ViewPayOnline> createState() => _ViewPayOnlineState();
}

class _ViewPayOnlineState extends State<ViewPayOnline> {
  bool _cardIsValid = true;
  bool _cardExpiryIsValid = true;
  bool _cardCvvIsValid = true;

  final cardNumberCtrl = MaskedTextController(mask: '0000 0000 0000 0000');
  final receiverCardNumberCtrl =
      MaskedTextController(mask: '0000 0000 0000 0000');

  final cardExpiryCtrl = MaskedTextController(mask: '00/0000');
  final cardCvvCtrl = MaskedTextController(mask: '0000');
  final cardHolderCtrl = TextEditingController();
  final amountCtrl =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  final amountFocus = FocusNode();
  final cardNumberFocus = FocusNode();
  final cardExpiryFocus = FocusNode();
  final cardCvvFocus = FocusNode();
  final cardHolderFocus = FocusNode();

  final receiverCardNumberFocus = FocusNode();

  validateCreditCardInfo({number, expirydate, cvv}) {
    final CreditCardValidator ccValidator = CreditCardValidator();

    final ccNumResults = ccValidator.validateCCNum(number.replaceAll(' ', ''));
    final expDateResults = ccValidator.validateExpDate(expirydate);
    final cvvResults = ccValidator.validateCVV(cvv, ccNumResults.ccType);
    final cardHolder = cardHolderCtrl.text.trim();

    setState(() {
      _cardIsValid = ccNumResults.isValid;
      _cardExpiryIsValid = expDateResults.isValid;
      _cardCvvIsValid = cvvResults.isValid;
    });

    if (ccNumResults.isValid && expDateResults.isValid && cvvResults.isValid) {
      if (cardHolder.isEmpty) {
        return cardHolderFocus.requestFocus();
      }
      paymentAuthenticationPrompt(
        context,
        body: widget.data,
        card: {
          "number": number,
          "expiry": expirydate,
          "cvv": cvv,
          "name": cardHolderCtrl.text.trim().toUpperCase(),
        },
        amountController: amountCtrl,
        amountFocusNode: amountFocus,
        controller: receiverCardNumberCtrl,
        focusNode: receiverCardNumberFocus,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 1), () {
        paymentPrompt();
      });
    });

    formatPrint("initState()", widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: kLight,
      elevation: 0,
      leading: const SizedBox(),
      leadingWidth: 0,
      title: Text(
        "PAY ONLINE",
        style: GoogleFonts.roboto(
          color: kDark,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed("/view-main-customer"),
          icon: const Icon(
            AntDesign.close,
            color: kDark,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => destroyFormFocus(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kLight,
        appBar: appBar,
        body: Container(
          padding: const EdgeInsets.only(
            top: 30.0,
            bottom: 30.0,
            left: 30,
            right: 30.0,
          ),
          child: Column(
            children: [
              inputNumberField(
                controller: cardNumberCtrl,
                focusNode: cardNumberFocus,
                labelText: "CARD NUMBER",
                color: kWhite,
                obscureText: false,
                hasError: !_cardIsValid,
                textFieldStyle: GoogleFonts.roboto(
                  color: kDark,
                  fontSize: 10.0,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: inputNumberField(
                      controller: cardExpiryCtrl,
                      focusNode: cardExpiryFocus,
                      labelText: "EXPIRY DATE",
                      color: kWhite,
                      obscureText: false,
                      hasError: !_cardExpiryIsValid,
                      textFieldStyle: GoogleFonts.roboto(
                        color: kDark,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: inputNumberField(
                      controller: cardCvvCtrl,
                      focusNode: cardCvvFocus,
                      labelText: "CVV",
                      color: kWhite,
                      obscureText: false,
                      hasError: !_cardCvvIsValid,
                      textFieldStyle: GoogleFonts.roboto(
                        color: kDark,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              billingTextField(
                controller: cardHolderCtrl,
                focusNode: cardHolderFocus,
                labelText: "NAME",
                color: kWhite,
                textFieldStyle: GoogleFonts.roboto(
                  color: kDark,
                  fontSize: 10.0,
                ),
              ),
              const Spacer(),
              elevatedButton(
                label: "PROCEED",
                function: () => validateCreditCardInfo(
                  number: cardNumberCtrl.text,
                  cvv: cardCvvCtrl.text,
                  expirydate: cardExpiryCtrl.text,
                ),
                btnColor: kDark,
                labelColor: kWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

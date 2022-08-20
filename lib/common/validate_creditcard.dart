import 'package:credit_card_validator/credit_card_validator.dart';

Future<void> validateCreditCardInfo({
  required String ccNum,
  required String expDate,
  required String cvv,
}) async {
  CreditCardValidator ccValidator = CreditCardValidator();
  final ccNumResults = ccValidator.validateCCNum(ccNum);
  final expDateResults = ccValidator.validateExpDate(expDate);
  final cvvResults = ccValidator.validateCVV(cvv, ccNumResults.ccType);

  print({ccNumResults, expDateResults, cvvResults});
}

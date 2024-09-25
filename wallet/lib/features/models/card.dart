class CardModel {
  String holderName;
  String bankName;
  String cardNumber;
  String? status;
  String validDates;

  CardModel({
    required this.holderName,
    required this.bankName,
    required this.cardNumber,
    required this.validDates,
    this.status,
  });
}
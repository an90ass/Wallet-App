class CardModel {
  String holderName;
  String bankName;
  String accountNumber;
  String? status;
  String validDates;

  CardModel({
    required this.holderName,
    required this.bankName,
    required this.accountNumber,
    required this.validDates,
    this.status,
  });
}
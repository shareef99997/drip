class CreditCardModel {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;

  CreditCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
  });

  @override
  String toString() {
    return 'Cardholder: $cardHolderName\nCard Number: $cardNumber\nExpiry: $expiryDate\nCVV: $cvv';
  }
}

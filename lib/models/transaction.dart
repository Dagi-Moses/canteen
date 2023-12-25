
class Transactions {
  final String amount;
  final String reference;
  final String currency;
  final String email;

  Transactions(
      {required this.amount,
      required this.reference,
      required this.currency,
      required this.email});

 

  factory Transactions.fromJson(Map<String, dynamic> map) {
    return Transactions(
      amount: map['amount'] as String,
      reference: map['reference'] as String,
      currency: map['currency'] as String,
      email: map['email'] as String,
    );
  }
   Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'reference': reference,
      'currency': currency,
      'email': email,
    };
  }
}

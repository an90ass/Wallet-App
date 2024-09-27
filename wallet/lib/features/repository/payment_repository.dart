import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  PaymentRepository({
    required this.auth,
    required this.firestore,
  });


  Future<void> addPayment({
    required String cardNumber,
    required String paymentTitle,
    required String paymentDescription,
    required String amount,
    required String paymentMethod,
  }) async {
    try {
      User? currentUser = auth.currentUser;

      if (currentUser == null) {
        print("No authenticated user found.");
        return Future.error(Exception("No authenticated user found."));
      }

      DocumentSnapshot cardSnapshot = await firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("cards")
          .doc(cardNumber)
          .get();

      if (!cardSnapshot.exists) {
        return Future.error(Exception("Card not found."));
      }

      double balance = cardSnapshot.get('balance');
      double paymentAmount = double.tryParse(amount) ?? 0.0;

      if (balance < paymentAmount) {
        return Future.error(Exception("Insufficient balance."));
      }
 // add balance
      await firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("cards")
          .doc(cardNumber)
          .collection("payments")
          .doc()
          .set({
        "cardNumber": cardNumber,
        "paymentTitle": paymentTitle,
        "paymentDescription": paymentDescription,
        "amount": amount,
        "paymentMethod": paymentMethod,
        "timestamp": FieldValue.serverTimestamp(),
      });

      print("Payment saved successfully.");

      double newBalance = balance - paymentAmount;

      await firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("cards")
          .doc(cardNumber)
          .update({"balance": newBalance});

      print("Balance updated successfully. New Balance: $newBalance");
    } catch (e) {
      print("Error saving payment: $e");
      return Future.error(e);
    }
  }
Future<List<Map<String, dynamic>>> fetchUserPayments(String selectedCardNumber) async {
  try {
    User? currentUser = auth.currentUser;

    if (currentUser == null) {
      print("No authenticated user found.");
      return [];
    }

    selectedCardNumber = selectedCardNumber.trim();
    print("Selected Card Number: '$selectedCardNumber'");

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
            .collection("users").doc(currentUser.uid)

        .collection("cards")
        .doc(selectedCardNumber)
        .collection("payments")
        .get(); 

    print("QuerySnapshot docs length: ${querySnapshot.docs.length}");

    if (querySnapshot.docs.isEmpty) {
      print("No payments found for card number: $selectedCardNumber");
    } else {
      querySnapshot.docs.forEach((doc) {
        print("Payment document ID: ${doc.id}");
        print("Payment data: ${doc.data()}");
      });
    }

    List<Map<String, dynamic>> payments = querySnapshot.docs
        .map((doc) => doc.data())
        .toList();

    print("Fetched payments: $payments");

    return payments;
  } catch (e) {
    print("Error fetching payments: $e");
    return [];
  }
}


}

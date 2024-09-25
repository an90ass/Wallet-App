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

      // حفظ معلومات الدفع في Firestore
      await firestore.collection("users")
          .doc(currentUser.uid)
          .collection("cards")
          .doc(cardNumber)
          .collection("payments")
          .doc(paymentMethod)
          .set({
        "cardNumber": cardNumber,
        "paymentTitle": paymentTitle,
        "paymentDescription": paymentDescription,
        "amount": amount,
        "paymentMethod": paymentMethod,
        "timestamp": FieldValue.serverTimestamp(),
      });

      print("Payment saved successfully.");
    } catch (e) {
      print("Error saving payment: $e");
      return Future.error(e);
    }
  }
}

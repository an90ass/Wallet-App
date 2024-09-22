import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  TransactionRepository({required this.auth, required this.firestore});
  

  Future<void> addTransaction({
    required String cardNumber,
    required String type,
    required String value,
  }) async {
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      await firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("cards")
          .doc(cardNumber)
          .collection("transactions")
          .doc()
          .set({
        "type": type,
        "value": value,
        "timestamp": FieldValue.serverTimestamp(),
      });
      // calculateBalance(cardNumber);
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  Future<double> calculateBalance(String cardNumber) async {
    User? currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("No authenticated user found.");
    }

    QuerySnapshot<Map<String, dynamic>> transactionsSnapshot = await firestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("cards")
        .doc(cardNumber)
        .collection("transactions")
        .get();

    double balance = 0.0;

    for (var doc in transactionsSnapshot.docs) {
      Map<String, dynamic> transactionData = doc.data();
      String type = transactionData["type"];
      double value = double.tryParse(transactionData["value"]) ?? 0.0;

      if (type == "income") {
        balance += value;
      } else if (type == "outgoing") {
        balance -= value;
      }
    }
  print(balance);
    return balance;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransferRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TransferRepository({required this.firestore, required this.auth});
Future<void> transferAmount({
    required String firstCardNumber,
    required String secondCardNumber,
    required double amount,
  }) async {
    User? currentUser = auth.currentUser;

    if (currentUser == null) {
      throw Exception("No authenticated user found.");
    }

    try {
      double firstCardBalance = await getBalance(firstCardNumber);

      if (firstCardBalance < amount) {
        throw Exception("Insufficient balance in the first card.");
      }

      double secondCardBalance = await getBalance(secondCardNumber);

      double updatedFirstCardBalance = firstCardBalance - amount;

      double updatedSecondCardBalance = secondCardBalance + amount;

      await updateBalance(firstCardNumber, updatedFirstCardBalance);
      await updateBalance(secondCardNumber, updatedSecondCardBalance);

    
    } catch (e) {
      throw Exception("Failed to transfer amount: ${e.toString()}");
    }
  }

  Future<double> getBalance(String cardNumber) async {
    User? currentUser = auth.currentUser;

    if (currentUser == null) {
      return Future.error(Exception("No authenticated user found."));
    }

    DocumentSnapshot<Map<String, dynamic>> cardDoc = await firestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("cards")
        .doc(cardNumber)
        .get();

    if (cardDoc.exists) {
      double balance = cardDoc.data()?["balance"]?.toDouble() ?? 0.0;
      return balance;
    } else {
      return Future.error(Exception("Card not found."));
    }
  }

  Future<void> updateBalance(String cardNumber, double newBalance) async {
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      await firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("cards")
          .doc(cardNumber)
          .set({
        "balance": newBalance,
      }, SetOptions(merge: true));
    }
  }

}

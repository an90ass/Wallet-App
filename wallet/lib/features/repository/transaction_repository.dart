import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});
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
    } else {
      throw Exception("No authenticated user found.");
    }
  }
}
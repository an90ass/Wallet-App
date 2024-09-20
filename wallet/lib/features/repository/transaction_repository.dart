import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionReposiyoryProvider = Provider((ref) => TransactionReposiyory(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class TransactionReposiyory {
  FirebaseAuth auth;
  FirebaseFirestore firestore;

  TransactionReposiyory({required this.auth, required this.firestore});

  Future<void> addTransaction({
    required String type,
    required String value,
  }) async {
    User? currentUser = auth.currentUser;
    
    if (currentUser != null && currentUser.displayName != null) {
      await firestore
          .collection("users")
          .doc(currentUser.displayName)  
          .collection("transactions")  
          .doc()  
          .set({
        "type": type,
        "value": value,
        "timestamp": FieldValue.serverTimestamp(),  
      });
    } else {
      throw Exception("No authenticated user found or displayName is null.");
    }
  }
}


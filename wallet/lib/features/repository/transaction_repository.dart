import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final transactionReposiyoryProvider = Provider((ref) => TransactionReposiyory(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class TransactionReposiyory {
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  TransactionReposiyory({required this.auth, required this.firestore});

  Future<void> addTransaction(
      {required String type, required String value}) async {
    final uuid = const Uuid().v4();
    await firestore
        .collection("users")
        .doc("anas")
        .collection("transactions")
        .doc(uuid)
        .set({"type": type, "value": value});
  }
}

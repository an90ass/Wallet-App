import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardRepositoryProvider = Provider((ref) {
  return CardRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
});

class CardRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  CardRepository({required this.auth, required this.firestore});

  Future<void> addCard({
    required String holderName,
    required String bankName,
    required String accountNumber,
    required String status,
    required String validDates,
  }) async {
    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        await firestore
            .collection("users")
            .doc(currentUser.uid)
            .collection("cards")
            .doc(accountNumber)  
            .set({
          "holderName": holderName,
          "bankName": bankName,
          "accountNumber": accountNumber,
          "status": status,
          "validDates": validDates,
          "cardName": "$holderName - $bankName",  
        });
      } else {
        throw Exception("No authenticated user found.");
      }
    } catch (e) {
      throw Exception("Error adding card: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserCards() async {
    try {
      User? currentUser = auth.currentUser;

      if (currentUser == null) {
        throw Exception("No authenticated user found.");
      }

      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('cards')
          .get();

      return snapshot.docs.map((doc) {
        return {
          "cardName": doc['cardName'],
          "holderName": doc['holderName'],
          "bankName": doc['bankName'],
          "accountNumber": doc["accountNumber"],  
          "status": doc['status'],
          "validDates": doc['validDates'],
        };
      }).toList();
    } catch (e) {
      throw Exception("Error fetching cards: $e");
    }
  }
}


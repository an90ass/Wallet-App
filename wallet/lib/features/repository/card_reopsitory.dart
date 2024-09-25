import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  CardRepository({required this.auth, required this.firestore});

  Future<void> addCard({
    required String holderName,
    required String bankName,
    required String cardNumber,
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
            .doc(cardNumber)
            .set({
          "holderName": holderName,
          "bankName": bankName,
          "cardNumber": cardNumber,
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
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return {
        "cardName": data.containsKey('cardName')
            ? data['cardName']
            : "${data['holderName']} - ${data['bankName']}",
        "holderName": data['holderName'],
        "bankName": data['bankName'],
        "cardNumber": data["cardNumber"],
        "status": data['status'],
        "validDates": data['validDates'],
      };
    }).toList();
  } catch (e) {
    throw Exception("Error fetching cards: $e");
  }
}

  Future<void> deleteCard({required String cardNumber})async {
    try{
      User? currentUser = auth.currentUser;
  if (currentUser == null) {
        throw Exception("No authenticated user found.");
      }
       await firestore.collection('users').doc(currentUser.uid).collection('cards').doc(cardNumber).delete();
      

    }catch(e){
      throw Exception("Error deleting card: $e");

    }
  }
}

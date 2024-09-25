import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  UserRepository({required this.auth, required this.firestore});

  Future<void> createUser({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(userName);

      await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .collection("Account info")
          .doc()
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
        'userName': userName,
      });
    } catch (e) {
      throw Exception("Error creating user: $e");
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception("Error signing in: ${e.toString()}");
    }
  }

Future<void> getUserUidsByEmail() async {
  try {
    print('Starting Firestore query...');
    
    QuerySnapshot userSnapshot = await firestore.collection('users').get();

    print('Query completed, number of documents: ${userSnapshot.docs.length}');
    
    if (userSnapshot.docs.isEmpty) {
      print('No documents found.');
    } else {
      userSnapshot.docs.forEach((doc) {
        print('Document ID: ${doc.id}');
      });
    }
  } catch (e) {
    print('Error fetching document IDs: $e');
  }
}




}




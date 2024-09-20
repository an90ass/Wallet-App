import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance; 
  if (firestore == null) {
    throw Exception("FirebaseFirestore.instance is null");
  }
  return UserRepository(auth: auth, firestore: firestore);
});
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

    // Set the displayName immediately after the user is created
    await userCredential.user!.updateDisplayName(userName);

print(userCredential.user!.displayName);
    // Optionally, save other account info
    await firestore
        .collection('users')
        .doc(userName)
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
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Error signing in: ${e.toString()}");
    }
  }
}

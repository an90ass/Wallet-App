import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  UserRepository(
      {required this.auth, required this.firestore, required this.storage});

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

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'userName': userName,
        'profileImageUrl': '',
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

      print(
          'Query completed, number of documents: ${userSnapshot.docs.length}');

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

  // Future<String> forgotPassword({required String email}) async {
  //   try {
  //     final signInMethods = await auth.fetchSignInMethodsForEmail(email);

  //     if (signInMethods.isEmpty) {
  //       return "No user found with this email.";
  //     }

  //     await auth.sendPasswordResetEmail(email: email);
  //     return "Password reset link sent! Check your email.";
  //   } on FirebaseAuthException catch (e) {
  //     return e.message.toString();
  //   }
  // }

  Future<String> forgotPassword({required String email}) async {
  try {
    // Directly send the password reset email
    await auth.sendPasswordResetEmail(email: email);
    return "Password reset link sent! Check your email.";
  } on FirebaseAuthException catch (e) {
    // Handle errors in a generic way
    if (e.code == 'user-not-found') {
      return "No user found with this email.";
    } else if (e.code == 'invalid-email') {
      return "Invalid email address provided.";
    } else {
      // Return the error message for other FirebaseAuth exceptions
      return e.message.toString();
    }
  }
}

  Future<String> updateEmail({required String newEmail}) async {
    try {
      User? user = auth.currentUser;

      if (user == null) {
        return "No user is currently signed in.";
      }

      await user.verifyBeforeUpdateEmail(newEmail);

      await firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
      });

      return "Verification email sent! Please verify to complete the email update.";
    } catch (e) {
      return "Failed to update email: ${e.toString()}";
    }
  }

  Future<String> updatePassword({required String newPassword}) async {
    try {
      User? user = auth.currentUser;

      if (user == null) {
        return "No user is currently signed in.";
      }

      await user.updatePassword(newPassword);
      return "Password updated successfully.";
    } catch (e) {
      return "Failed to update password: ${e.toString()}";
    }
  }

  String? getCurrentUserEmail() {
    return auth.currentUser?.email;
  }

  Future<void> uploadProfileImage(File image) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        Reference storageRef =
            storage.ref().child('profile_images/${user.uid}.jpg');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;

        if (taskSnapshot.state == TaskState.success) {
          String downloadUrl = await storageRef.getDownloadURL();
          await firestore.collection('users').doc(user.uid).update({
            'profileImageUrl': downloadUrl,
          });
        }
      }
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  Future<String?> getProfileImageUrl() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();
        return userDoc['profileImageUrl'] as String?;
      }
    } catch (e) {
      throw Exception("Failed to get profile image URL: $e");
    }
    return null;
  }

  Future<String?> getUserName() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await firestore.collection('users').doc(user.uid).get();
          print("User Name ${doc['userName'] as String?}");
      return doc['userName'] as String?;
    }
    return null;
  }

  Future<void> updateUserName(String newName) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await firestore.collection('users').doc(user.uid).update({
          'userName': newName,
        });
      }
    } catch (e) {
      throw Exception("Failed to update username: $e");
    }
  }

  Future<void> reauthenticateUser({required String password}) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        String email = user.email!;
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
        print('User re-authenticated successfully.');
      }
    } catch (e) {
      throw Exception('Failed to re-authenticate user: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        String uid = user.uid;

        Reference storageRef = storage.ref().child('profile_images/$uid.jpg');

        try {
          await storageRef.getDownloadURL();

          await storageRef.delete();
        } catch (e) {
          if (e.toString().contains('object-not-found')) {
            print('No profile image found to delete.');
          } else {
            throw Exception('Failed to delete profile image: $e');
          }
        }

        await firestore.collection('users').doc(uid).delete();

        await user.delete();

        print('User account deleted successfully.');
      } else {
        throw Exception('No user is currently signed in.');
      }
    } catch (e) {
      print('Error deleting account: $e');
      throw Exception('Failed to delete account: $e');
    }
  }
}

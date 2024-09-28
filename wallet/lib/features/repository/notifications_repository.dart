import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  NotificationRepository({required this.auth, required this.firestore});

  Future<void> addNotificationTodb(String title, String body) async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      await firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("notifications")
          .doc()
          .set({
        "title": title,
        "body": body,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } else {
      print("User is not logged in");
    }
  }

Future<List<Map<String, dynamic>>> getNotifications() async {
  User? currentUser = auth.currentUser;
  if (currentUser != null) {
    QuerySnapshot snapshot = await firestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("notifications")
        .orderBy("timestamp", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['docId'] = doc.id;
      return data;
    }).toList();
  } else {
    throw Exception("User is not logged in");
  }
}


  // حذف الإشعار باستخدام docId
  Future<void> deleteNotification(String docId) async {
    User? currentUser = auth.currentUser;
    if (currentUser != null) {
      await firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("notifications")
          .doc(docId)
          .delete();
    } else {
      throw Exception("User is not logged in");
    }
  }
}

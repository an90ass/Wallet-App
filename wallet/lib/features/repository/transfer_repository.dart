// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class TransferRepository {
//   final FirebaseFirestore firestore;
//   final FirebaseAuth auth;

//   TransferRepository({required this.firestore, required this.auth});

//   // التحقق من رصيد المستخدم
//   Future<double> getUserBalance(String uid) async {
//     try {
//       DocumentSnapshot documentSnapshot = await firestore
//           .collection('users')
//           .doc(uid)
//           .collection('Account info')
//           .doc('balance')
//           .get();

//       if (documentSnapshot.exists) {
//         return documentSnapshot['balance'] as double;
//       } else {
//         throw Exception("Balance not found for user: $uid");
//       }
//     } catch (e) {
//       throw Exception("Error fetching balance: $e");
//     }
//   }

//   // إتمام التحويل بين المستخدمين
//   Future<void> transferMoney({
//     required String senderUid,
//     required String receiverUid,
//     required double amount,
//   }) async {
//     try {
//       // التحقق من رصيد المرسل
//       double senderBalance = await getUserBalance(senderUid);

//       if (senderBalance < amount) {
//         throw Exception("Insufficient balance");
//       }

//       // بدء المعاملة لتحديث الأرصدة والمعاملات
//       await firestore.runTransaction((transaction) async {
//         // تحديث رصيد المرسل
//         DocumentReference senderRef = firestore
//             .collection('users')
//             .doc(senderUid)
//             .collection('Account info')
//             .doc('balance');

//         transaction.update(senderRef, {
//           'balance': senderBalance - amount,
//         });

//         // تحديث رصيد المستلم
//         double receiverBalance = await getUserBalance(receiverUid);
//         DocumentReference receiverRef = firestore
//             .collection('users')
//             .doc(receiverUid)
//             .collection('Account info')
//             .doc('balance');

//         transaction.update(receiverRef, {
//           'balance': receiverBalance + amount,
//         });

//         // تسجيل التحويل لكل من المرسل والمستلم
//         DocumentReference senderTransactionRef = firestore
//             .collection('users')
//             .doc(senderUid)
//             .collection('transactions')
//             .doc();

//         transaction.set(senderTransactionRef, {
//           'type': 'sent',
//           'amount': amount,
//           'to': receiverUid,
//           'date': Timestamp.now(),
//         });

//         DocumentReference receiverTransactionRef = firestore
//             .collection('users')
//             .doc(receiverUid)
//             .collection('transactions')
//             .doc();

//         transaction.set(receiverTransactionRef, {
//           'type': 'received',
//           'amount': amount,
//           'from': senderUid,
//           'date': Timestamp.now(),
//         });
//       });

//       print("Transfer successful");
//     } catch (e) {
//       throw Exception("Error during transfer: $e");
//     }
//   }
// }

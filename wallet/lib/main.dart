// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/controller/card_controller.dart';
import 'package:wallet/features/controller/notification_controller.dart';
import 'package:wallet/features/controller/user_controller.dart';
import 'package:wallet/features/repository/card_reopsitory.dart';
import 'package:wallet/features/repository/notifications_repository.dart';
import 'package:wallet/features/repository/transaction_repository.dart';
import 'package:wallet/features/repository/transfer_repository.dart';  
import 'package:wallet/firebase_options.dart';
import 'package:wallet/my_app.dart';
import 'package:wallet/features/repository/user_repository.dart';

import 'features/controller/payment_controller.dart';
import 'features/controller/transactio_controller.dart';
import 'features/controller/transfer_controller.dart';
import 'features/repository/payment_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await LocalNotifications.init();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CardStateNotifier()),
        
        Provider<UserRepository>(
          create: (_) => UserRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
            storage: FirebaseStorage.instance, 

          ),
        ),
        
        ChangeNotifierProxyProvider<UserRepository, UserController>(
          create: (context) => UserController(userRepository: Provider.of<UserRepository>(context, listen: false)),
          update: (context, userRepository, userController) => UserController(userRepository: userRepository),
        ),

        Provider<CardRepository>(
          create: (_) => CardRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),

        ChangeNotifierProxyProvider<CardRepository,CardController>(
          create: (context)=>CardController(cardRepository: Provider.of<CardRepository>(context,listen: false)),
           update: (context,cardRepository,cardController)=>CardController(cardRepository: cardRepository)),
        
        // ChangeNotifierProxyProvider<CardRepository, CardController>(
        //   create: (context) => CardController(cardRepository: Provider.of<CardRepository>(context, listen: false)),
        //   update: (context, cardRepository, cardController) => CardController(cardRepository: cardRepository),
        // ),
        
        Provider<TransactionRepository>(
          create: (_) => TransactionRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
        
        ChangeNotifierProxyProvider<TransactionRepository, TransactionController>(
          create: (context) => TransactionController(transactionRepository: Provider.of<TransactionRepository>(context, listen: false)),
          update: (context, transactionRepository, transactionController) => TransactionController(transactionRepository: transactionRepository),
        ),
    Provider<PaymentRepository>(
      create: (context) => PaymentRepository(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    ),
        ChangeNotifierProxyProvider<PaymentRepository, PaymentController>(
      create: (context) => PaymentController(
        paymentRepository: Provider.of<PaymentRepository>(context, listen: false),
      ),
      update: (context, paymentRepository, paymentController) =>
          PaymentController(paymentRepository: paymentRepository),
          
    ),
        
    ChangeNotifierProvider(
      create: (context) => PaymentController(
        paymentRepository: Provider.of<PaymentRepository>(context, listen: false),
      ),
    ),

     Provider<NotificationRepository>(
          create: (_) => NotificationRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
         ChangeNotifierProvider(
      create: (context) => NotificationController(
        notificationRepository: Provider.of<NotificationRepository>(context, listen: false),
      ),
    ),
     Provider<TransferRepository>(
          create: (_) => TransferRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
          
        ),
          ChangeNotifierProvider(
      create: (context) => TransferController(
        transferRepository: Provider.of<TransferRepository>(context, listen: false),
      ),
    ),
      ],
      child: MyApp(),
    ),
  );
}

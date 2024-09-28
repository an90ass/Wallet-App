// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:rxdart/rxdart.dart';

// class LocalNotifications {
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
// //     static final onClickNotification = BehaviorSubject<String>();

// //     // on tap in notification
// //     static Future<void>   onNotificationTap(
// //       NotificationResponse noftificationResponse
// //     ) async {
// // onClickNotification.add(noftificationResponse.payload!);
// //     }

//   static Future init() async {
//     // initialise the plugin. app_icon needs to be added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//             onDidReceiveLocalNotification: (id, title, body, payload) => null);

//     final LinuxInitializationSettings initializationSettingsLinux =
//         LinuxInitializationSettings(defaultActionName: 'Open notification');

//     final InitializationSettings initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsDarwin,
//         linux: initializationSettingsLinux);

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (details)=>null,
//         // onDidReceiveBackgroundNotificationResponse: onNotificationTap
//         );
//   }

//   static Future showSimpleNotification(
//       {required String title,
//       required String body,
//       required String payload}) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'your_channel_id', 
//       'your_channel_name', 
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       playSound: true,
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     await _flutterLocalNotificationsPlugin.show(
//         0, title, body, notificationDetails,
//         payload: payload);
//   }
// }
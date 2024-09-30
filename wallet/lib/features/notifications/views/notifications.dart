// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wallet/config/items/app_colors.dart';
// import 'package:wallet/features/controller/notification_controller.dart';
// import 'package:intl/intl.dart'; 

// class NotificationsPage extends StatefulWidget {
//   @override
//   _NotificationsPageState createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<NotificationController>(context, listen: false)
//           .fetchNotifications();
//     });
//   }

//   bool isOldNotification(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp).inMinutes;
//     return difference > 5; 
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
    
//       body: Consumer<NotificationController>(
//         builder: (context, notificationController, child) {
//           if (notificationController.isLoading) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final recentNotifications = notificationController.notifications
//               .where((notification) =>
//                   !isOldNotification(notification['timestamp'].toDate()))
//               .toList();

//           final oldNotifications = notificationController.notifications
//               .where((notification) =>
//                   isOldNotification(notification['timestamp'].toDate()))
//               .toList();

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                                 SizedBox(height: 10),

//               const  Center(
//                   child: Text(
//                     'New Notifications',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors.darkPurpleColor),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: recentNotifications.isNotEmpty
//                       ? ListView.builder(
//                           itemCount: recentNotifications.length,
//                           itemBuilder: (context, index) {
//                             final notification = recentNotifications[index];
//                             return buildNotificationCard(
//                                 context, notification, notificationController, true);
//                           },
//                         )
//                       : Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.notifications_off,
//                                 color: Colors.grey[600],
//                                 size: 60.0,
//                               ),
//                               SizedBox(height: 16.0),
//                               Text(
//                                 "There are no new notifications at the moment.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                   color: Colors.grey[600],
//                                   fontWeight: FontWeight.w500,fontStyle: FontStyle.italic
//                                 ),
//                               ),
//                               SizedBox(height: 10.0),
//                               Text(
//                                 "Check back later or perform a new transaction.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//                                   color: Colors.grey[500],fontStyle: FontStyle.italic
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                 ),
//              const   SizedBox(height: 20),
                
//                const Center(
//                   child: Text(
//                     'Old Notifications',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors.darkPurpleColor),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: oldNotifications.isNotEmpty
//                       ? ListView.builder(
//                           itemCount: oldNotifications.length,
//                           itemBuilder: (context, index) {
//                             final notification = oldNotifications[index];
//                             return buildNotificationCard(
//                                 context, notification, notificationController, false);
//                           },
//                         )
//                       : Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.history,
//                                 color: Colors.grey[600],
//                                 size: 60.0,
//                               ),
//                               SizedBox(height: 16.0),
//                               Text(
//                                 "No old notifications available.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                   color: Colors.grey[600],
//                                   fontWeight: FontWeight.w500,fontStyle: FontStyle.italic
//                                 ),
//                               ),
//                               SizedBox(height: 10.0),
//                               Text(
//                                 "Perform some actions or check back later.",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//                                   color: Colors.grey[500],
//                                   fontStyle: FontStyle.italic
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildNotificationCard(BuildContext context, Map<String, dynamic> notification,
//       NotificationController notificationController, bool isNew) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: Icon(
//                 Icons.circle,
//                 color: isNew ? Colors.green : Colors.red,
//                 size: 10,
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     DateFormat('dd MMMM yyyy, h:mm a')
//                         .format(notification['timestamp'].toDate()),
//                     style: TextStyle(color: Colors.grey, fontSize: 14),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     notification['title'] ?? 'No Title',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     '"${notification['body'] ?? 'No Body'}"',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.cancel_presentation, color: Colors.red[700]),
//               onPressed: () {
//                 if (notification['docId'] != null && notification['docId'] is String) {
//                   _showDeleteConfirmationDialog(context, notificationController, notification['docId']);
//                 } else {
//                   print("docId is null or not a valid string.");
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmationDialog(BuildContext context, NotificationController notificationController, String docId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm Delete"),
//           content: Text("Are you sure you want to delete this notification?"),
//           actions: [
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Delete"),
//               onPressed: () async {
//                 await notificationController.deleteNotification(docId);
//                 Navigator.of(context).pop();

//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text("Notification deleted successfully!"),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/features/controller/notification_controller.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationController>(context, listen: false)
          .fetchNotifications();
    });
  }

  bool isOldNotification(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp).inMinutes;
    return difference > 10; // اعتبر الإشعارات القديمة بعد مرور 10 دقائق
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationController>(
        builder: (context, notificationController, child) {
          if (notificationController.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Sort the notifications by timestamp in descending order (الأحدث أولًا)
          final sortedNotifications = notificationController.notifications
              .map((notification) => {
                    'timestamp': notification['timestamp'].toDate(),
                    'data': notification
                  })
              .toList()
            ..sort((a, b) =>
                (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime)); // ترتيب عكسي للأحدث

          // Separate new and old notifications
          final recentNotifications = sortedNotifications
              .where((notification) =>
                  !isOldNotification(notification['timestamp'] as DateTime))
              .toList();

          final oldNotifications = sortedNotifications
              .where((notification) =>
                  isOldNotification(notification['timestamp'] as DateTime))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                const Center(
                  child: Text(
                    'New Notifications',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkPurpleColor),
                  ),
                ),
                SizedBox(height: 10),

                Expanded(
                  child: recentNotifications.isNotEmpty
                      ? ListView.builder(
                          itemCount: recentNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = recentNotifications[index]['data'];
                            return buildNotificationCard(context, notification,
                                notificationController, true);
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off,
                                color: Colors.grey[600],
                                size: 60.0,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "There are no new notifications at the moment.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                "Check back later or perform a new transaction.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Old Notifications',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkPurpleColor),
                  ),
                ),
                SizedBox(height: 10),

                Expanded(
                  child: oldNotifications.isNotEmpty
                      ? ListView.builder(
                          itemCount: oldNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = oldNotifications[index]['data'];
                            return buildNotificationCard(context, notification,
                                notificationController, false);
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.grey[600],
                                size: 60.0,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "No old notifications available.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                "Perform some actions or check back later.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildNotificationCard(
      BuildContext context,
      Map<String, dynamic> notification,
      NotificationController notificationController,
      bool isNew) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.circle,
                color: isNew ? Colors.green : Colors.red,
                size: 10,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd MMMM yyyy, h:mm a')
                        .format(notification['timestamp'].toDate()),
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    notification['title'] ?? 'No Title',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '"${notification['body'] ?? 'No Body'}"',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.cancel_presentation, color: Colors.red[700]), // أيقونة الحذف
              onPressed: () {
                if (notification['docId'] != null &&
                    notification['docId'] is String) {
                  _showDeleteConfirmationDialog(context, notificationController,
                      notification['docId']);
                } else {
                  print("docId is null or not a valid string.");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context,
      NotificationController notificationController, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this notification?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                await notificationController.deleteNotification(docId);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Notification deleted successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}


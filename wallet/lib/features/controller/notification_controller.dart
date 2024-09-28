import 'package:flutter/material.dart';
import 'package:wallet/features/repository/notifications_repository.dart';

class NotificationController extends ChangeNotifier {
  final NotificationRepository notificationRepository;
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = false;
  bool hasNewNotifications = false; 

  NotificationController({required this.notificationRepository});

  Future<void> addNotificationTodb(String title, String body) async {
    await notificationRepository.addNotificationTodb(title, body);
    fetchNotifications(); 
  }

  Future<void> fetchNotifications() async {
    isLoading = true;
    notifyListeners();

    try {
      notifications = await notificationRepository.getNotifications();
      hasNewNotifications = notifications.isNotEmpty; 
    } catch (e) {
      print("Failed to fetch notifications: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteNotification(String docId) async {
    try {
      await notificationRepository.deleteNotification(docId);
      notifications.removeWhere((notification) => notification['docId'] == docId);
      fetchNotifications(); 
    } catch (e) {
      print("Failed to delete notification: $e");
    }
  }
}

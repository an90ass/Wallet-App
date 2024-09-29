import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wallet/features/repository/user_repository.dart';

class UserController with ChangeNotifier {
  final UserRepository userRepository;

  UserController({required this.userRepository});
  String? _forgotPassword_message;
  String? get forgotPassword_message => _forgotPassword_message;
  String? _updateEmailMessage;
  String? get updateEmailMessage => _updateEmailMessage;

  String? _updatePasswordMessage;
  String? get updatePasswordMessage => _updatePasswordMessage;
  Future<void> createUser({
    required String email,
    required String password,
    required String userName,
  }) async {
    await userRepository.createUser(
        email: email, password: password, userName: userName);
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await userRepository.signIn(email: email, password: password);
    notifyListeners();
  }

  Future<void> getUserUidByEmail() async {
    await userRepository.getUserUidsByEmail();
  }

  Future<void> forgotPassword({required String email}) async {
    _forgotPassword_message = await userRepository.forgotPassword(email: email);
    notifyListeners();
  }

  Future<void> updateEmail({required String newEmail}) async {
    _updateEmailMessage = await userRepository.updateEmail(newEmail: newEmail);
    notifyListeners();
  }

  Future<void> updatePassword({required String newPassword}) async {
    _updatePasswordMessage =
        await userRepository.updatePassword(newPassword: newPassword);
    notifyListeners();
  }

  String? getCurrentUserEmail() {
    return userRepository.getCurrentUserEmail();
  }

  Future<void> uploadProfileImage(File image) async {
    await userRepository.uploadProfileImage(image);
    notifyListeners();
  }

  Future<String?> getProfileImageUrl() async {
    return await userRepository.getProfileImageUrl();
  }

  Future<String?> getUserName() async {
    return await userRepository.getUserName();
  }

  Future<void> updateUserName(String newName) async {
    await userRepository.updateUserName(newName);
    notifyListeners();
  }

  Future<void> reauthenticateUser({required String password}) async {
    try {
      await userRepository.reauthenticateUser(password: password);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to re-authenticate user: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await userRepository.deleteAccount();
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete account: $e');
    }
  }
}

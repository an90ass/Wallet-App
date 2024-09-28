import 'package:flutter/material.dart';
import 'package:wallet/features/repository/user_repository.dart';

class UserController with ChangeNotifier {
  final UserRepository userRepository;

  UserController({required this.userRepository});
String? _forgotPassword_message;
String? get forgotPassword_message=>_forgotPassword_message;

  Future<void> createUser({
    required String email,
    required String password,
    required String userName,
  }) async {
    await userRepository.createUser(email: email, password: password, userName: userName);
    notifyListeners(); 
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await userRepository.signIn(email: email, password: password);
    notifyListeners(); 
  }
  Future<void> getUserUidByEmail()async{
    await userRepository.getUserUidsByEmail();
  }
  Future<void> forgotPassword({required String email})async{
    _forgotPassword_message=await userRepository.forgotPassword(email: email);
    notifyListeners();
  }
}

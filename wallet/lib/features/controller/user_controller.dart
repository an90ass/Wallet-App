import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/features/repository/user_repository.dart';

final userControllerProvider = Provider((ref) => UserController(
    userRepository: ref.watch(userRepositoryProvider)));

class UserController {
  final UserRepository userRepository;

  UserController({required this.userRepository});

  Future<void> createUser({required String email, required String password, required String userName}) async {
    await userRepository.createUser(email: email, password: password, userName: userName);
  }

  Future<void> signIn({required String email, required String password}) async {
    await userRepository.signIn(email: email, password: password);
  }
}

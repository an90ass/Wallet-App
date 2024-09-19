import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/features/repository/transaction_repository.dart';

final transactionControllerProvider = Provider((ref) => TransactionController(
    transactionReposiyory: ref.watch(transactionReposiyoryProvider)));

class TransactionController {
  final TransactionReposiyory transactionReposiyory;

  TransactionController({required this.transactionReposiyory});
  
  Future<void> addTransaction(
      {required String type, required String value}) async {
    await transactionReposiyory.addTransaction(type: type, value: value);
  }
}

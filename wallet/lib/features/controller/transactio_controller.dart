import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/features/repository/transaction_repository.dart';

final transactionControllerProvider = Provider<TransactionController>((ref) {
  return TransactionController(
    transactionRepository: ref.watch(transactionRepositoryProvider), 
  );
});

class TransactionController {
  final TransactionRepository transactionRepository;

  TransactionController({required this.transactionRepository});

  Future<void> addTransaction({
    required String cardNumber,
    required String type,
    required String value,
  }) async {
    await transactionRepository.addTransaction(
      cardNumber: cardNumber,
      type: type,
      value: value,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wallet/features/repository/transfer_repository.dart';

class TransferController extends ChangeNotifier {
  final TransferRepository transferRepository;

  TransferController({required this.transferRepository});

  Future<void> transferAmount({
    required String firstCardNumber,
    required String secondCardNumber,
    required double amount,
    required BuildContext context,
  }) async {
    try {
      await transferRepository.transferAmount(
        firstCardNumber: firstCardNumber,
        secondCardNumber: secondCardNumber,
        amount: amount,
      );
    notifyListeners(); 
    } catch (e) {
            throw Exception(e.toString());  

      
    }
  }
}

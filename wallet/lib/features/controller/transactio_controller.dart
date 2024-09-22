import 'package:flutter/material.dart';
import 'package:wallet/features/repository/transaction_repository.dart';

class TransactionController extends ChangeNotifier {
  final TransactionRepository transactionRepository;
  double _balance = 0.0; 
   String? _currentCardNumber;
     String? get currentCardNumber => _currentCardNumber; // جلب رقم البطاقة الحالي

  double get balance => _balance;

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
    await calculateBalance( cardNumber: cardNumber);

    notifyListeners();
  }
  Future<void> calculateBalance({required String cardNumber}) async {
    _balance = await transactionRepository.calculateBalance(cardNumber);
        _currentCardNumber = cardNumber; 

    notifyListeners();
    
  }
}

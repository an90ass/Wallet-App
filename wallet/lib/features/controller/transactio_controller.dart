import 'package:flutter/material.dart';
import 'package:wallet/features/repository/transaction_repository.dart';

class TransactionController extends ChangeNotifier {
  final TransactionRepository transactionRepository;
  String? _currentCardNumber;
  String? get currentCardNumber => _currentCardNumber;
  double _balance = 0.0;

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
    addBalance(cardNumber);
  }

  Future<void> addBalance(String cardNumber) async {
    await transactionRepository.addBalance(cardNumber);
    notifyListeners();
  }

  Future<void> getBalance(String cardNumber) async {
    if (cardNumber.isEmpty) {
      print('Card number is empty');
      _balance = 0.0;
      notifyListeners();
      return;
    }

    try {
      double balance = await transactionRepository.getBalance(cardNumber);
      _balance = balance;
    } catch (e) {
      print('Error getting balance: $e');
      _balance = 0.0;
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
   // });
  }
}

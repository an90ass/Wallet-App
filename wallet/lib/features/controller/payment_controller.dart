import 'package:flutter/material.dart';
import '../repository/payment_repository.dart';

class PaymentController extends ChangeNotifier {
  final PaymentRepository paymentRepository;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  PaymentController({required this.paymentRepository});

  Future<void> addPayment({
    required String cardNumber,
    required String paymentTitle,
    required String paymentDescription,
    required String amount,
    required String paymentMethod,
  }) async {
    _isProcessing = true; 
    notifyListeners(); 

    try {
      await paymentRepository.addPayment(
        cardNumber: cardNumber,
        paymentTitle: paymentTitle,
        paymentDescription: paymentDescription,
        amount: amount,
        paymentMethod: paymentMethod,
      );
      _isProcessing = false; 
      notifyListeners(); 
    } catch (e) {
      _isProcessing = false; 
      notifyListeners(); 
      throw Exception("Error adding payment: $e"); 
    }
  }
}

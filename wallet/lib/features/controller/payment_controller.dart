import 'package:flutter/material.dart';
import '../repository/payment_repository.dart';

class PaymentController extends ChangeNotifier {
  final PaymentRepository paymentRepository;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;
  List<Map<String, dynamic>> _payments = [];
  List<Map<String, dynamic>> get payments => _payments;
  String? _errorMessage;
    bool _isLoading = false;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

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
Future<void> fetchUserPayments(String cardNumber) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      List<Map<String, dynamic>> payments = await paymentRepository.fetchUserPayments(cardNumber);
      payments.sort((a, b) {
      DateTime dateA = a['timestamp'].toDate();
      DateTime dateB = b['timestamp'].toDate();
      return dateB.compareTo(dateA);
    });

    _payments = payments;
      _payments = payments;
    } catch (e) {
      _errorMessage = "Error fetching payments: $e";
    }

    _isLoading = false;
    notifyListeners(); 
  }

}

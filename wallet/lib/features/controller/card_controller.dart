import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/controller/transactio_controller.dart';
import 'package:wallet/features/repository/card_reopsitory.dart';

class CardController extends ChangeNotifier {
  final CardRepository cardRepository;
  List<Map<String, dynamic>> _userCards = [];
  List<Map<String, dynamic>> get userCards => _userCards;

  CardController({required this.cardRepository});

 Future<bool> addCard({
    required String holderName,
    required String bankName,
    required String cardNumber,
    required String validDates,
    // required String status,
    required BuildContext context,
  }) async {
     List<Map<String, dynamic>> userCards = await fetchUserCards();

  bool cardExists = userCards.any((card) => card['cardNumber'] == cardNumber);

  if (cardExists) {
    return false;
  }

  await cardRepository.addCard(
    holderName: holderName,
    bankName: bankName,
    cardNumber: cardNumber,
    // status: status,
    validDates: validDates,
  );

  userCards = await fetchUserCards();

  if (userCards.isNotEmpty) {
    final newCard = userCards.last;
    Provider.of<CardStateNotifier>(context, listen: false).updateCardName(newCard["cardName"]);
  }

  notifyListeners();
  return true; // تمت إضافة الكرت بنجاح
}
Future<List<Map<String, dynamic>>> fetchUserCards() async {
    _userCards = await cardRepository.fetchUserCards();
    notifyListeners();
    return _userCards;
  }


  
Future<void> deleteCard(BuildContext context, String cardNumber) async {
  try {
    await cardRepository.deleteCard(cardNumber: cardNumber);

    List<Map<String, dynamic>> updatedCards = await fetchUserCards();

    if (updatedCards.isNotEmpty) {
      // Update the selected card and recalculate the balance
      final newCard = updatedCards.first;
      String newCardNumber = newCard["cardNumber"];
      Provider.of<CardStateNotifier>(context, listen: false).updateCardName(newCard["cardName"]);
      Provider.of<CardStateNotifier>(context, listen: false).updateCardNumber(newCardNumber);
      
      // Recalculate the balance for the new card
      await Provider.of<TransactionController>(context, listen: false).getBalance(newCardNumber);
    } else {
      // If no cards are left, reset the balance and card information
      Provider.of<CardStateNotifier>(context, listen: false).updateCardName('No Cards Available');
      Provider.of<CardStateNotifier>(context, listen: false).updateCardNumber('');
      await Provider.of<TransactionController>(context, listen: false).getBalance("");
    }

    notifyListeners();
  } catch (e) {
    print("Error deleting card: $e");
    throw Exception("Error deleting card: $e");
  }
}


}
class CardStateNotifier extends ChangeNotifier {
  String _cardName = 'No avalibale card select card';
  String _carNumber= 'Card Number';

  String get cardName => _cardName;
  String get cardNumber => _carNumber;

  void updateCardName(String newCardName) {
    _cardName = newCardName;
    notifyListeners();
  }

   void updateCardNumber(String newCardNumber) {
    _carNumber = newCardNumber;
    notifyListeners();
  }
}

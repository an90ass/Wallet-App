import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/repository/card_reopsitory.dart';

class CardController extends ChangeNotifier {
  final CardRepository cardRepository;

  CardController({required this.cardRepository});

 Future<void> addCard({
    required String holderName,
    required String bankName,
    required String accountNumber,
    required String validDates,
    required String status,
    required BuildContext context,
  }) async {
    await cardRepository.addCard(
      holderName: holderName,
      bankName: bankName,
      accountNumber: accountNumber,
      status: status,
      validDates: validDates,
    );

    List<Map<String, dynamic>> userCards = await fetchUserCards();

    if (userCards.isNotEmpty) {
      final newCard = userCards.last;
      Provider.of<CardStateNotifier>(context, listen: false).updateCard(newCard["cardName"]);
    }

    notifyListeners();
  }
  Future<List<Map<String, dynamic>>> fetchUserCards() async {
    return await cardRepository.fetchUserCards();
  }


  
 Future<void> deleteCard(BuildContext context, String accountNumber) async {
  try {
    await cardRepository.deleteCard(accountNumber: accountNumber);

    List<Map<String, dynamic>> updatedCards = await fetchUserCards();

    if (updatedCards.isNotEmpty) {
      final newCard = updatedCards.first;
      Provider.of<CardStateNotifier>(context, listen: false).updateCard(newCard["cardName"]);
    } else {
      Provider.of<CardStateNotifier>(context, listen: false).updateCard('No Cards Available');
    }

    notifyListeners();
  } catch (e) {
    print("Error deleting card: $e");
    throw Exception("Error deleting card: $e");
  }
}
}
class CardStateNotifier extends ChangeNotifier {
  String _cardName = 'Card Name';

  String get cardName => _cardName;

  void updateCard(String newCardName) {
    _cardName = newCardName;
    notifyListeners();
  }
}


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/features/repository/card_reopsitory.dart';

final cardProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await ref.read(cardControllerProvider).fetchUserCards();
});
final cardControllerProvider = Provider((ref) =>CardController(
  cardRepository:ref.watch(cardRepositoryProvider))
 );

class CardController {
  final CardRepository cardRepository;

  CardController({required this.cardRepository});

  Future<void> addCard({
    required String holderName,
    required String bankName,
    required String accountNumber,
    required String validDates,
    required String status,
    required WidgetRef ref, 
  }) async {
    await cardRepository.addCard(
      holderName: holderName,
      bankName: bankName,
      accountNumber: accountNumber,
      status: status,
      validDates: validDates,
    );
    // Trigger a refresh of the cardProvider to reload the cards list
    ref.invalidate(cardProvider);  // Use ref to invalidate the cardProvider
  }

  Future<List<Map<String, dynamic>>> fetchUserCards() async {
    return await cardRepository.fetchUserCards();
  }
}

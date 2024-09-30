import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';
import 'package:wallet/features/controller/card_controller.dart';

import '../../controller/transactio_controller.dart';

class CardDetail extends StatefulWidget {
  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  String? selectedCardName;
  Map<String, dynamic>? selectedCardInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedCardName =
          Provider.of<CardStateNotifier>(context, listen: false).cardName;
      _setSelectedCardInfo();
    });
  }

  void _setSelectedCardInfo() {
    final cardController = Provider.of<CardController>(context, listen: false);

    cardController.fetchUserCards().then((userCards) {
      if (selectedCardName != null && userCards.isNotEmpty) {
        try {
          final selectedCard = userCards.firstWhere(
            (card) => card['cardName'] == selectedCardName,
          );

          setState(() {
            selectedCardInfo = {
              "HolderName": selectedCard['holderName'].toString(),
              "CardName": selectedCard['cardName'].toString(),
              "BankName": selectedCard['bankName'].toString(),
              "cardNumber": selectedCard['cardNumber'].toString(),
              // "Status": selectedCard['status'].toString(),
              "Valid": selectedCard['validDates'].toString(),
            };
          });
          Provider.of<CardStateNotifier>(context, listen: false)
              .updateCardName(selectedCard['cardName']);
          Provider.of<CardStateNotifier>(context, listen: false)
              .updateCardNumber(selectedCard['cardNumber']);

          // Provider.of<TransactionController>(context, listen: false)
          //       .getBalance( selectedCard['cardNumber'],);
        } catch (e) {
          print('Card not found: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.containerColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: context.paddingAllDefault,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 10,
                ),
                _buildCardDropdown(context),
                SizedBox(
                  height: 40,
                ),
                buildTitle(),
                SizedBox(
                  height: 40,
                ),
                buildCardImage(),
                SizedBox(
                  height: 40,
                ),
                if (selectedCardInfo != null)
                  Column(
                    children: selectedCardInfo!.entries.map((entry) {
                      return CardInfoItem(
                        title: entry.key,
                        info: entry.value,
                      );
                    }).toList(),
                  ),
                SizedBox(
                  height: 50,
                ),
                buildCardDeleteButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardDropdown(BuildContext context) {
    final cardController = Provider.of<CardController>(context, listen: false);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: cardController.fetchUserCards(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildNoPaymentsFoundMessaj(context, 'No cards found',
              'It seems like there are no cards available yet');
        }

        List<Map<String, dynamic>> userCards = snapshot.data!;

        if (!userCards.any((card) => card['cardName'] == selectedCardName)) {
          selectedCardName = null;
        }

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Select Card",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            prefixIcon: Icon(Icons.card_travel_rounded),
            suffixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
          ),
          value: selectedCardName,
          hint: const Text("Select Card"),
          onChanged: (String? newValue) {
            setState(() {
              selectedCardName = newValue;

              final selectedCard = userCards.firstWhere(
                (card) => card['cardName'] == selectedCardName,
              );

              selectedCardInfo = {
                "HolderName": selectedCard['holderName'].toString(),
                "CardName": selectedCard['cardName'].toString(),
                "BankName": selectedCard['bankName'].toString(),
                "cardNumber": selectedCard['cardNumber'].toString(),
                // "Status": selectedCard['status'].toString(),
                "Valid": selectedCard['validDates'].toString(),
              };

              Provider.of<CardStateNotifier>(context, listen: false)
                  .updateCardName(selectedCard['cardName']);
              Provider.of<CardStateNotifier>(context, listen: false)
                  .updateCardNumber(selectedCard['cardNumber']);

              Provider.of<TransactionController>(context, listen: false)
                  .getBalance(
                selectedCard['cardNumber'],
              );
            });
          },
          items: userCards
              .map<DropdownMenuItem<String>>((Map<String, dynamic> card) {
            return DropdownMenuItem<String>(
              value: card['cardName'],
              child: Text(
                card['cardName'],
                style: const TextStyle(
                  color: AppColors.containerColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          style: const TextStyle(
            color: AppColors.containerColor,
            fontWeight: FontWeight.bold,
          ),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.containerColor),
          dropdownColor: Colors.white,
          isExpanded: true,
        );
      },
    );
  }

  Widget buildCardDeleteButton() {
    if (selectedCardInfo != null) {
      return TextButton(
        onPressed: () async {
          if (selectedCardInfo != null) {
            String cardNumber = selectedCardInfo!['cardNumber'];

            try {
              await Provider.of<CardController>(context, listen: false)
                  .deleteCard(context, cardNumber);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Card deleted successfully'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error deleting card: $e'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        },
        child: Text(
          "Delete Card",
          style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.containerColor,
            fontWeight: FontWeight.w500,
            fontSize: context.dynamicHeight(0.023),
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildTitle() {
    if (selectedCardInfo != null) {
      return Text(
        "Card Detail",
        style: context.textTheme.headlineMedium?.copyWith(
          color: AppColors.titleColor,
          fontWeight: FontWeight.bold,
          fontSize: context.dynamicHeight(0.035),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildCardImage() {
    return Image.asset(ImageEnum.horizontalCard.imagePath);
  }

  Widget buildNoPaymentsFoundMessaj(
      BuildContext context, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dynamicHeight(0.1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.lightPurpleColor,
            size: 80,
          ),
          SizedBox(height: context.dynamicHeight(0.02)),
          Text(
            title,
            style: context.textTheme.titleLarge?.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
              fontSize: context.dynamicHeight(0.03),
            ),
          ),
          // SizedBox(height: context.dynamicHeight(0.01)),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.subtitleColor,
              fontSize: context.dynamicHeight(0.02),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CardInfoItem extends StatelessWidget {
  const CardInfoItem({super.key, required this.title, required this.info});
  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(0.65),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.subtitleColor,
              fontSize: context.dynamicHeight(0.023),
            ),
          ),
          SizedBox(
            width: context.dynamicWidth(0.05),
          ),
          Text(
            info,
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.containerColor,
              fontSize: context.dynamicHeight(0.020),
            ),
          ),
        ],
      ),
    );
  }
}

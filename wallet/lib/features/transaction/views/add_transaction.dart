import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/features/controller/card_controller.dart';
import '../../../config/items/app_colors.dart';
import '../../controller/transactio_controller.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key, required this.type});
  final String type; 

  @override
  State<StatefulWidget> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String transaction_value = ""; 
  String? selectedCardNumber; 

  final List<Map<String, dynamic>> _keyboardItems = [
    {"value": "1"},
    {"value": "2"},
    {"value": "3"},
    {"value": "4"},
    {"value": "5"},
    {"value": "6"},
    {"value": "7"},
    {"value": "8"},
    {"value": "9"},
    {"value": "00"},
    {"value": "0"},
    {"value": null, "icon": Icons.close_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.containerColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.paddingAllDefault,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTransactionAmount(context),
            const SizedBox(height: 20),
            _buildCardDropdown(context),
            const SizedBox(height: 30),
            _buildKeyboard(context),
            const SizedBox(height: 20),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionAmount(BuildContext context) {
    return Align(
      child: Text(
        '\$ $transaction_value',
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.darkPurpleColor,
          fontSize: context.dynamicHeight(0.035),
        ),
      ),
    );
  }

  Widget _buildCardDropdown(BuildContext context) {
    return Consumer<CardController>(
      builder: (context, cardController, _) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: cardController.fetchUserCards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No cards found');
            }

            List<Map<String, dynamic>> userCards = snapshot.data!;

            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Card",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
                fillColor: AppColors.grayColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.dynamicWidth(0.01),
                  vertical: context.dynamicHeight(0.02),
                ),
              ),
              value: selectedCardNumber,
              hint: const Text("Please select a card"),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCardNumber = newValue;
                });
              },
              items: userCards.map((Map<String, dynamic> card) {
                return DropdownMenuItem<String>(
                  value: card['accountNumber'],
                  child: Text('${card['holderName']} - ${card['bankName']}'),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildKeyboard(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.5),
      width: context.dynamicWidth(1),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
        ),
        itemCount: _keyboardItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _keyboardItems[index];
          return Center(
            child: item["value"] != null
                ? _buildKeyboardButton(context, item["value"])
                : _buildBackspaceButton(context, item["icon"]),
          );
        },
      ),
    );
  }

  Widget _buildKeyboardButton(BuildContext context, String value) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        setState(() {
          transaction_value += value;
        });
      },
      child: Container(
        margin: EdgeInsets.all(context.dynamicWidth(0.05)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.darkPurpleColor,
            fontSize: context.dynamicHeight(0.028),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton(BuildContext context, IconData icon) {
    return IconButton(
      onPressed: () {
        setState(() {
          if (transaction_value.isNotEmpty) {
            transaction_value = transaction_value.substring(0, transaction_value.length - 1);
          }
        });
      },
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.darkPurpleColor, width: 2),
        ),
        child: Icon(icon, color: AppColors.darkPurpleColor),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, transactionController, child) {
        return MaterialButton(
          onPressed: () async {
            if (selectedCardNumber == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a card"),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            await transactionController
                .addTransaction(
                  cardNumber: selectedCardNumber!, 
                  type: widget.type, 
                  value: transaction_value, 
                )
                .whenComplete(() {
              const snackBar = SnackBar(
                content: Text("Transaction added successfully!"),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              
              Navigator.pop(context);
            });
          },
          color: AppColors.darkBlueColor,
          minWidth: context.dynamicWidth(0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: context.paddingVerticalDefault,
            child: Text(
              "Add Transaction",
              style: context.textTheme.titleLarge?.copyWith(color: AppColors.whiteColor),
            ),
          ),
        );
      },
    );
  }
}

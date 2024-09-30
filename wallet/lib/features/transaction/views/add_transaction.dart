import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/features/controller/card_controller.dart';
import '../../../config/items/app_colors.dart';
import '../../controller/notification_controller.dart';
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
    Provider.of<CardController>(context, listen: false).fetchUserCards();

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined,
            color: AppColors.containerColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.paddingAllDefault,
        child: SingleChildScrollView(
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
      builder: (context, cardController, child) {
        if (cardController.userCards.isEmpty) {
          return Text(
            "No cards available. Please add a card.!!",
            style: TextStyle(color: Colors.redAccent),
          );
        }

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // } else if (snapshot.hasError) {
        //   return Text('Error: ${snapshot.error}');
        // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //   return const Text('No cards found');
        // }

        // List<Map<String, dynamic>> userCards = snapshot.data!;

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
            selectedCardNumber = newValue;
          },
          items: cardController.userCards.map((Map<String, dynamic> card) {
            return DropdownMenuItem<String>(
              value: card['cardNumber'],
              child: Text('${card['holderName']} - ${card['bankName']}'),
            );
          }).toList(),
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
            transaction_value =
                transaction_value.substring(0, transaction_value.length - 1);
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

          if (widget.type == "outgoing") {
            await transactionController.getBalance(selectedCardNumber!);
            double? currentBalance = transactionController.balance;

            if (currentBalance == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Failed to retrieve balance. Please try again."),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            double transactionAmount = double.tryParse(transaction_value) ?? 0.0;

            if (currentBalance < transactionAmount) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Insufficient balance! Your balance is \$${currentBalance.toStringAsFixed(2)}'),
                  backgroundColor: Colors.red[700],
                  showCloseIcon: true,
                ),
              );
              return;
            }
          }

          await transactionController.addTransaction(
            cardNumber: selectedCardNumber!,
            type: widget.type,
            value: transaction_value,
          );
          try {
            final notificationController =
                Provider.of<NotificationController>(context, listen: false);

            String notificationMessage = ""; 

            if (widget.type == "income") {
              notificationMessage =
                  "You have received an amount of $transaction_value dollars from card number $selectedCardNumber.";
            } else if (widget.type == "outgoing") {
              notificationMessage =
                  "You have withdrawn an amount of $transaction_value dollars from card number $selectedCardNumber.";
            }

            await notificationController.addNotificationTodb(
              widget.type,
              notificationMessage,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Transaction and notification added successfully!"),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pop(context);
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to save notification."),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        color: AppColors.darkBlueColor,
        minWidth: context.dynamicWidth(0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: context.paddingVerticalDefault,
          child: Text(
            "Add Transaction",
            style:
                context.textTheme.titleLarge?.copyWith(color: AppColors.whiteColor),
          ),
        ),
      );
    },
  );
}


  // Widget _buildSubmitButton(BuildContext context) {
  //   return Consumer<TransactionController>(
  //     builder: (context, transactionController, child) {
  //       return MaterialButton(
  //         onPressed: () async {
  //           if (selectedCardNumber == null) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text("Please select a card"),
  //                 backgroundColor: Colors.red,
  //               ),
  //             );
  //             return;
  //           }
  //           if (widget.type == "outgoing") {
  //             await transactionController.getBalance(selectedCardNumber!);
  //             double? currentBalance = transactionController.balance;
  //             print("selectedCardNumber ${selectedCardNumber}");

  //             print("currentBalance ${currentBalance}");
  //             if (currentBalance == null) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content:
  //                       Text("Failed to retrieve balance. Please try again."),
  //                   backgroundColor: Colors.red,
  //                 ),
  //               );
  //               return;
  //             }

  //             double transactionAmount =
  //                 double.tryParse(transaction_value) ?? 0.0;

  //             if (currentBalance < transactionAmount) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: Text(
  //                       'Insufficient balance! Your balance is \$${currentBalance.toStringAsFixed(2)}'),
  //                   backgroundColor: Colors.red[700],
  //                   showCloseIcon: true,
  //                 ),
  //               );
  //               return;
  //             }
  //           }
  //           await transactionController
  //               .addTransaction(
  //             cardNumber: selectedCardNumber!,
  //             type: widget.type,
  //             value: transaction_value,
  //           )
  //               .whenComplete(() {
  //             const snackBar = SnackBar(
  //               content: Text("Transaction added successfully!"),
  //               duration: Duration(seconds: 3),
  //               backgroundColor: Colors.green,
  //             );
  //             ScaffoldMessenger.of(context).showSnackBar(snackBar);

  //             Navigator.pop(context);
  //           });
  //         },
  //         color: AppColors.darkBlueColor,
  //         minWidth: context.dynamicWidth(0.6),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //         child: Padding(
  //           padding: context.paddingVerticalDefault,
  //           child: Text(
  //             "Add Transaction",
  //             style: context.textTheme.titleLarge
  //                 ?.copyWith(color: AppColors.whiteColor),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

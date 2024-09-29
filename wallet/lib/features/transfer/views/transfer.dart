import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/features/controller/notification_controller.dart';
import 'package:wallet/features/controller/transfer_controller.dart';
import '../../controller/card_controller.dart';

class Transfer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TransferState();
  }
}

class TransferState extends State<Transfer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String? selectedFirstCardName;
  String? selectedSecondCardName;
  String? selectedFirstCardNumber;
  String? selectedSecondCardNumber;
  bool _isProcessing = false;

  void _showNotification(String message, {required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(),
              SizedBox(height: 16),
              buildSubTitle(),
              SizedBox(height: 50),
              buildFirstCardDropDown(context),
              SizedBox(height: 16),
              buildSecondCardDropDown(context),
              SizedBox(height: 16),
              buildAmountField(),
              SizedBox(height: 50),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstCardDropDown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.containerColor, width: 2),
        color: Colors.white,
      ),
      child: ListTile(
        leading: Icon(Icons.credit_card, color: AppColors.containerColor),
        title: Text(
          selectedFirstCardName ?? "Select the card to transfer from",
          style: TextStyle(
            color: selectedFirstCardName == null
                ? Colors.grey
                : AppColors.containerColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Choose the card you want to transfer money from.",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Icon(Icons.arrow_drop_down_circle_outlined,
            color: AppColors.containerColor, size: 30),
        onTap: () => _showCardPicker(
          context,
          excludeCard: null,
          onCardSelected: (cardName, cardNumber) {
            setState(() {
              selectedFirstCardName = cardName;
              selectedFirstCardNumber = cardNumber;
              selectedSecondCardName = null;
              selectedSecondCardNumber = null;
            });
          },
        ),
      ),
    );
  }

  Widget buildSecondCardDropDown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.containerColor, width: 2),
        color: Colors.white,
      ),
      child: ListTile(
        leading:
            Icon(Icons.credit_card_outlined, color: AppColors.containerColor),
        title: Text(
          selectedSecondCardName ?? "Select the card to transfer to",
          style: TextStyle(
            color: selectedSecondCardName == null
                ? Colors.grey
                : AppColors.containerColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Choose the card you want to transfer money to.",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Icon(Icons.arrow_drop_down_circle_outlined,
            color: AppColors.containerColor, size: 30),
        onTap: () => _showCardPicker(
          context,
          excludeCard: selectedFirstCardNumber,
          onCardSelected: (cardName, cardNumber) {
            setState(() {
              selectedSecondCardName = cardName;
              selectedSecondCardNumber = cardNumber;
            });
          },
        ),
      ),
    );
  }

  void _showCardPicker(BuildContext context,
      {required Function(String, String) onCardSelected, String? excludeCard}) {
    final cardController = Provider.of<CardController>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: cardController.fetchUserCards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No cards found'));
            }

            List<Map<String, dynamic>> userCards = snapshot.data!;

            List<Map<String, dynamic>> filteredCards = excludeCard != null
                ? userCards
                    .where((card) => card['cardNumber'] != excludeCard)
                    .toList()
                : userCards;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: filteredCards.length,
                itemBuilder: (context, index) {
                  var card = filteredCards[index];
                  return ListTile(
                    leading: Icon(Icons.credit_card,
                        color: AppColors.containerColor),
                    title: Text(
                      card['cardName'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.containerColor),
                    ),
                    onTap: () {
                      onCardSelected(card['cardName'], card['cardNumber']);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Enter Amount',
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        prefixIcon: Icon(Icons.attach_money, color: AppColors.containerColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  if (selectedFirstCardNumber == null ||
                      selectedSecondCardNumber == null) {
                    _showNotification('Please select both cards.',
                        isSuccess: false);
                  } else {
                    setState(() {
                      _isProcessing = true;
                    });

                    Provider.of<TransferController>(context, listen: false)
                        .transferAmount(
                      firstCardNumber: selectedFirstCardNumber!,
                      secondCardNumber: selectedSecondCardNumber!,
                      amount: double.parse(_amountController.text),
                      context: context,
                    )
                        .then((_) {
                      _showNotification('Amount transferred successfully!',
                          isSuccess: true);
                          Provider.of<NotificationController>(context, listen: false)
                        .addNotificationTodb(
                            'Transfer', 'You have transferred ${_amountController.text}\$ to ${selectedSecondCardName} card name.');
                    
                      setState(() {
                        selectedFirstCardName = null;
                        selectedSecondCardName = null;
                        selectedFirstCardNumber = null;
                        selectedSecondCardNumber = null;
                        _amountController.clear();
                      });
                    }).catchError((error) {
                      _showNotification(
                          'Failed to transfer: ${error.toString()}',
                          isSuccess: false);
                    }).whenComplete(() {
                      setState(() {
                        _isProcessing = false;
                      });
                    });
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPurpleColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isProcessing
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                'Send Money',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
    );
  }

  Widget buildTitle() {
    return const Text(
      'Transfer Money',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.containerColor,
      ),
    );
  }

  Widget buildSubTitle() {
    return Text(
      'Easily and securely transfer money between your cards with just a few taps',
      style: TextStyle(
          fontSize: 16, color: Colors.grey[700], fontStyle: FontStyle.italic),
    );
  }
}

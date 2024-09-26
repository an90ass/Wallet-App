import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/controller/payment_controller.dart';
import 'package:wallet/features/controller/transactio_controller.dart';
import '../../../config/items/app_colors.dart';
import '../../controller/card_controller.dart';
import '../../models/payment.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  String _balance = "0.00";
  final _formKey = GlobalKey<FormState>();
  final paymentModel = PaymentModel(
      cardNumber: '',
      paymentTitle: '',
      paymentDescription: '',
      amount: '',
      paymentMethod: '');

  final List<Map<String, dynamic>> quickMenuItems = [
    {
      "title": "NetFlex",
      "icon": const Icon(Icons.movie, color: Color(0xFFE50914)),
    },
    {
      "title": "PayPal",
      "icon": const Icon(Icons.payment, color: Color(0xFF003087)),
    },
    {
      "title": "Visa",
      "icon": const Icon(Icons.credit_card, color: Color(0xFF1A1F71)),
    },
    {
      "title": "MasterCard",
      "icon": const Icon(Icons.credit_card, color: Color(0xFFFF5F00)),
    },
    {
      "title": "Apple Pay",
      "icon": const Icon(Icons.phone_iphone, color: Colors.black),
    },
    {
      "title": "Google Pay",
      "icon": const Icon(Icons.android, color: Color(0xFF34A853)),
    },
    {
      "title": "Stripe",
      "icon": const Icon(Icons.attach_money, color: Color(0xFF6772E5)),
    },
    {
      "title": "Amazon Pay",
      "icon": const Icon(Icons.shopping_cart, color: Color(0xFFFF9900)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    Provider.of<CardController>(context, listen: false).fetchUserCards();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Make a Payment",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlueColor),
                ),
                const SizedBox(height: 20),
                buildBalanceField(context),
                const SizedBox(height: 50),
                buildPaymentTitleField(),
                const SizedBox(height: 20),
                buildCardsField(context),
                const SizedBox(height: 20),
                buildAmountField(),
                const SizedBox(height: 20),
                buildPaymentMethodField(),
                const SizedBox(height: 20),
                buildPaymentDescriptionField(),
                const SizedBox(height: 50),
                buildSubmitButton(context),
             
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBalanceField(BuildContext context) {
    return Text(
      'Balance: \$$_balance',
      style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.lightPurpleColor,
          fontStyle: FontStyle.italic),
    );
  }

  Widget buildCardsField(BuildContext context) {
    return Consumer<CardController>(
      builder: (context, cardController, child) {
        if (cardController.userCards.isEmpty) {
          return const Text(
            "No cards available. Please add a card.",
            style: TextStyle(color: Colors.redAccent),
          );
        }

        return DropdownButtonFormField<String>(
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          decoration: InputDecoration(
            labelText: "Select Card",
            labelStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon:
                const Icon(Icons.credit_card, color: AppColors.darkPurpleColor),
          ),
          items: cardController.userCards.map<DropdownMenuItem<String>>((card) {
            return DropdownMenuItem<String>(
              value: card['cardNumber'],
              child: Text(
                card['cardName'],
                style: const TextStyle(
                  color: AppColors.containerColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              paymentModel.cardNumber = value!;
              updateBalance(context, paymentModel.cardNumber);
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a card';
            }
            return null;
          },
        );
      },
    );
  }

  Widget buildPaymentTitleField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Enter payment title",
        labelText: "Payment Title",
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintStyle:
            TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.title, color: AppColors.darkPurpleColor),
      ),
      onSaved: (String? value) {
        paymentModel.paymentTitle = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a payment title';
        }
        return null;
      },
    );
  }

  Widget buildAmountField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter amount",
        labelText: "Amount",
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintStyle:
            TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon:
            const Icon(Icons.attach_money, color: AppColors.darkPurpleColor),
      ),
      onSaved: (String? value) {
        paymentModel.amount = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        }
        return null;
      },
    );
  }

  Widget buildPaymentMethodField() {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
      decoration: InputDecoration(
        labelText: "Payment Method",
        labelStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.payment, color: AppColors.darkPurpleColor),
      ),
      items: quickMenuItems.map((item) {
        return DropdownMenuItem<String>(
          value: item['title'],
          child: Row(
            children: [
              item['icon'],
              const SizedBox(width: 8),
              Text(item['title']),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        paymentModel.paymentMethod = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a payment method';
        }
        return null;
      },
    );
  }

  Widget buildPaymentDescriptionField() {
    return TextFormField(
      maxLines: null,
      minLines: 6,
      decoration: InputDecoration(
        hintText: "Enter payment description",
        labelText: "Payment Description",
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintStyle:
            TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon:
            const Icon(Icons.description, color: AppColors.darkPurpleColor),
      ),
      onSaved: (String? value) {
        paymentModel.paymentDescription = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a payment description';
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            getCardNumber(context);

            final transactionController =
                Provider.of<TransactionController>(context, listen: false);
            try {
              await transactionController.getBalance(paymentModel.cardNumber);
              double currentBalance = transactionController.balance;

              double paymentAmount =
                  double.tryParse(paymentModel.amount) ?? 0.0;

              if (currentBalance < paymentAmount) {
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

              final paymentController =
                  Provider.of<PaymentController>(context, listen: false);
              await paymentController.addPayment(
                cardNumber: paymentModel.cardNumber,
                paymentTitle: paymentModel.paymentTitle,
                paymentDescription: paymentModel.paymentDescription,
                amount: paymentModel.amount,
                paymentMethod: paymentModel.paymentMethod,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment Submitted Successfully!'),
                  backgroundColor: Colors.green[700],
                  showCloseIcon: true,
                ),
              );
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to submit payment: $error')),
              );
            }
          }
        },
        icon: const Icon(
          Icons.payment,
          color: AppColors.whiteColor,
        ),
        label: const Text(
          "Submit Payment",
          style: TextStyle(fontSize: 18, color: AppColors.whiteColor),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPurpleColor,
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 30.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  void updateBalance(BuildContext context, String cardNumber) async {
    final transactionController =
        Provider.of<TransactionController>(context, listen: false);
    await transactionController.getBalance(cardNumber);
    setState(() {
      _balance = transactionController.balance.toStringAsFixed(2);
    });
  }

  void getCardNumber(BuildContext context) {
    final cardController = Provider.of<CardController>(context, listen: false);
    final selectedCard = cardController.userCards.firstWhere(
      (card) => card['cardNumber'] == paymentModel.cardNumber,
      orElse: () => {},
    );

    if (selectedCard.isNotEmpty) {
      paymentModel.cardNumber = selectedCard['cardNumber'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Card number not found!')),
      );
      return;
    }
  }
}

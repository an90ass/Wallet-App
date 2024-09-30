import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';
import 'package:wallet/features/controller/transactio_controller.dart';
import '../../controller/card_controller.dart';
import '../../controller/payment_controller.dart';

class Stats extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatsState();
  }
}

class StatsState extends State<Stats> {
  int _currentIndex = 0;
  late PageController _pageController;
  List<Map<String, dynamic>>? _userCards;
  bool _isLoading = true;
  String? _errorMessage;
  late ScrollController _scrollController;

  final List<Map<String, dynamic>> quickMenuItems = [
    {
      "title": "NetFlex",
      "icon": ImageEnum.netflex.imagePath,
    },
    {
      "title": "PayPal",
      "icon": ImageEnum.paypal.imagePath,
    },
    {
      "title": "Visa",
      "icon": ImageEnum.visa.imagePath,
    },
    {
      "title": "MasterCard",
      "icon": ImageEnum.mastercard.imagePath,
    },
    {
      "title": "Apple Pay",
      "icon": ImageEnum.applepay.imagePath,
    },
    {
      "title": "Google Pay",
      "icon": ImageEnum.googlepay.imagePath,
    },
    {
      "title": "Stripe",
      "icon": ImageEnum.stripe.imagePath,
    },
    {
      "title": "Amazon Pay",
      "icon": ImageEnum.amazonpay.imagePath,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
    _scrollController = ScrollController();

    _loadUserCards();
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _loadUserCards() async {
    try {
      final cardController =
          Provider.of<CardController>(context, listen: false);
      List<Map<String, dynamic>> cards = await cardController.fetchUserCards();
      if (cards.isNotEmpty) {
        final selectedCardNumber = cards[0]['cardNumber'];
        Provider.of<PaymentController>(context, listen: false)
            .fetchUserPayments(selectedCardNumber);
      }
      setState(() {
        _userCards = cards;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _userCards == null || _userCards!.isEmpty
                    ?   Center(child: buildNoPaymentsFoundMessaj('No card found','It seems like there are no cards available yet'))
                    : Padding(
                        padding: context.paddingAllDefault,
                        child: Column(
                          children: [
                            buildTitle(),
                            buildCardImages(_userCards!),
                            buildPageIndicatorRow(_userCards!.length),
                            buildCardInfoSection(_userCards!),
                            buildTransactionHeader(),
                            buildTransactionList(),
                          ],
                        ),
                      ),
      ),
    );
  }

  Widget buildTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Income Stats",
        style: context.textTheme.titleMedium?.copyWith(
            color: AppColors.titleColor,
            fontWeight: FontWeight.bold,
            fontSize: context.dynamicHeight(0.027)),
      ),
    );
  }

  Widget buildCardImages(List<Map<String, dynamic>> userCards) {
    return SizedBox(
      height: context.dynamicHeight(0.3),
      child: PageView.builder(
        controller: _pageController,
        itemCount: userCards.length,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
            final selectedCardNumber = _userCards![value]['cardNumber'];
            Provider.of<PaymentController>(context, listen: false)
                .fetchUserPayments(selectedCardNumber);
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.02)),
            child: Image.asset(
              userCards[index]['imagePath'] ??
                  ImageEnum.horizontalCard.imagePath,
            ),
          );
        },
      ),
    );
  }

  Widget buildPageIndicatorRow(int userCardsLength) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < userCardsLength; i++)
          Padding(
            padding: EdgeInsets.only(right: context.dynamicWidth(0.02)),
            child: CircleAvatar(
              radius: context.dynamicWidth(0.020),
              backgroundColor: _currentIndex == i
                  ? AppColors.darkPurpleColor
                  : AppColors.subtitleColor,
            ),
          )
      ],
    );
  }

  Widget buildCardInfoSection(List<Map<String, dynamic>> userCards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: context.paddingTopDefault,
          child: Text(
            userCards[_currentIndex]['cardName'] ?? "Card ${_currentIndex + 1}",
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.subtitleColor,
              fontSize: context.dynamicHeight(0.023),
            ),
          ),
        ),
        Padding(
          padding: context.paddingTopDefault,
          child: Consumer<TransactionController>(
            builder: (context, transactionController, child) {
              transactionController
                  .getBalance(userCards[_currentIndex]['cardNumber']);
              final cardBalance =
                  transactionController.balance.toStringAsFixed(2);
              return Text(
                '\$ ${cardBalance}',
                style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightPurpleColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              );
            },
          ),
        )
      ],
    );
  }

  Row buildTransactionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Transaction",
          style: context.textTheme.titleMedium?.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
              fontSize: context.dynamicHeight(0.027)),
        ),
        TextButton(
          onPressed: scrollToTop,
          child: Text(
            "Latest",
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.lightPurpleColor,
              fontSize: context.dynamicHeight(0.027),
            ),
          ),
        ),
      ],
    );
  }

  Expanded buildTransactionList() {
    return Expanded(
      child: Consumer<PaymentController>(
        builder: (context, paymentController, child) {
          if (paymentController.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (paymentController.errorMessage != null) {
            return Center(child: Text(paymentController.errorMessage!));
          }

          if (paymentController.payments.isEmpty) {
            return buildNoPaymentsFoundMessaj('No payments found','It seems like there are no payments available yet');
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: paymentController.payments.length,
            itemBuilder: (BuildContext context, int index) {
              final payment = paymentController.payments[index];
              final paymentTitle = payment['paymentMethod'];

              final paymentIcon = quickMenuItems.firstWhere(
                (element) => element['title'] == paymentTitle,
                orElse: () => {"icon": ImageEnum.profilePicture.imagePath},
              )['icon'];

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  payment['paymentTitle'] ?? "Payment",
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.blackColor,
                    fontSize: context.dynamicHeight(0.023),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Text(
                  payment['paymentDescription'] ?? "Payment Description",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.subtitleColor,
                    fontSize: context.dynamicHeight(0.02),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: Column(children: [
                  Text(
                    "\$${payment['amount'] ?? "0"}",
                    style: context.textTheme.labelMedium?.copyWith(
                      color: AppColors.darkBlueColor,
                      fontSize: context.dynamicHeight(0.02),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(
                      _formatTimestamp(payment['timestamp']),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ]),
                leading: CircleAvatar(
                  radius: context.dynamicWidth(0.08),
                  backgroundImage: AssetImage(paymentIcon),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildNoPaymentsFoundMessaj(String title,String subtitle) {
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
           subtitle ,
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

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return "No Date";
    }

    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is DateTime) {
      date = timestamp;
    } else {
      return "Invalid Date";
    }

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);

    return formattedDate;
  }
}

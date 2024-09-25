import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';
import 'package:wallet/features/controller/transactio_controller.dart';
import '../../controller/card_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
    _loadUserCards(); 
  }

  Future<void> _loadUserCards() async {
    try {
      final cardController = Provider.of<CardController>(context, listen: false);
      List<Map<String, dynamic>> cards = await cardController.fetchUserCards();
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
                    ? const Center(child: Text('No cards found'))
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
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.02)),
            child: Image.asset(
              userCards[index]['imagePath'] ?? ImageEnum.horizontalCard.imagePath,
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
      transactionController.getBalance(userCards[_currentIndex]['cardNumber']);
      final cardBalance = transactionController.balance.toStringAsFixed(2);
      return Text('\$ ${cardBalance}',
      style: context.textTheme.bodyMedium?.copyWith(
        color: AppColors.lightPurpleColor,
        fontSize: 30,
        fontWeight: FontWeight.bold
      ),);
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
          onPressed: () {},
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
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "Payment",
              style: context.textTheme.labelMedium?.copyWith(
                color: AppColors.blackColor,
                fontSize: context.dynamicHeight(0.023),
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              "Payment Description",
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor,
                fontSize: context.dynamicHeight(0.02),
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Text(
              "\$ 12",
              style: context.textTheme.labelMedium?.copyWith(
                color: AppColors.darkBlueColor,
                fontSize: context.dynamicHeight(0.02),
                fontWeight: FontWeight.w400,
              ),
            ),
            leading: CircleAvatar(
              radius: context.dynamicWidth(0.08),
              backgroundImage: AssetImage(
                ImageEnum.profilePicture.imagePath,
              ),
            ),
          );
        },
      ),
    );
  }
}

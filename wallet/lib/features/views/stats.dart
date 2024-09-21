import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';

import '../controller/card_controller.dart';

class Stats extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StatsState();
  }
}

class StatsState extends State<Stats> {
  int _currentIndex = 0;
  late PageController _pageController;

  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Consumer(
          builder: (context, ref, child) {
            final cardsAsync = ref.watch(cardProvider);
            return cardsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (userCards) {
                return Padding(
                  padding: context.paddingAllDefault,
                  child: Column(
                    children: [
                      buildTitle(),
                      buildCardImages(userCards),
                      buildPageIndicatorRow(userCards.length),
                      buildCardInfoSection(userCards),
                      buildTransactionHeader(),
                      buildTransactionList(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Column buildTiteleAndSubTitel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Wallet",
          style: context.textTheme.headlineMedium?.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
              fontSize: context.dynamicHeight(0.035)),
        ),
        Text(
          "Active",
          style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.subtitleColor,
              fontSize: context.dynamicHeight(0.025)),
        ),
      ],
    );
  }

  CircleAvatar buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: context.dynamicWidth(0.08),
      backgroundImage: AssetImage(ImageEnum.profilePicture.imagePath),
    );
  }

  Padding builCardInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.dynamicWidth(0.1),
        vertical: context.dynamicWidth(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Balance",
                style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: context.dynamicHeight(0.027)),
              ),
              Text(
                '\$ 1000',
                style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: context.dynamicHeight(0.035)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Card",
                style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: context.dynamicHeight(0.027)),
              ),
              Text(
                '\$ Mabank',
                style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: context.dynamicHeight(0.035)),
              ),
            ],
          ),
        ],
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
      child: userCards.isEmpty
          ? const Center(
              child: Text(
                'No cards found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : PageView.builder(
              controller: _pageController,
              itemCount: userCards.length,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
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
            userCards.isEmpty
                ? "No cards found"
                : userCards[_currentIndex]['cardName'] ??
                    "Card ${_currentIndex + 1}",
            style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.subtitleColor,
                fontSize: context.dynamicHeight(0.023)),
          ),
        ),
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
                fontSize: context.dynamicHeight(0.027)),
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
                  fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              "Payment Description",
              style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtitleColor,
                  fontSize: context.dynamicHeight(0.02),
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              "\$ 12",
              style: context.textTheme.labelMedium?.copyWith(
                  color: AppColors.darkBlueColor,
                  fontSize: context.dynamicHeight(0.02),
                  fontWeight: FontWeight.w400),
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

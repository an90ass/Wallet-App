// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/routes/route_name.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';
import 'package:wallet/features/controller/card_controller.dart';

import '../../controller/transactio_controller.dart';

class Wallet extends StatelessWidget {
  final List<Map<String, String>> quickMenuItems = [
    {
      "title": "Transfer",
      "svgPath": ImageEnum.transfer.svgPath,
    },
    {
      "title": "Payment",
      "svgPath": ImageEnum.payment.svgPath,
    },
    {
      "title": "Outgoing",
      "svgPath": ImageEnum.payout.svgPath,
    },
    {
      "title": "Income",
      "svgPath": ImageEnum.topup.svgPath,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCardName = Provider.of<CardStateNotifier>(context).cardName; 

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: context.paddingAllDefault,
          child: Column(
            children: [
              Padding(
                padding: context.paddingVerticalDefault,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTitleAndSubtitle(context),
                    buildAvatar(context),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RouteNames.cardDetail),
                child: Card(
                  elevation: 5,
                  color: AppColors.containerColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: buildCardInfo(context, selectedCardName),
                ),
              ),
              Padding(
                padding: context.paddingVerticalDefault,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: quickMenuItems.map((item) {
                    return QuickMenuItem(
                      title: item['title']!,
                      svgPath: item['svgPath']!,
                      onTap: () {
                        handleMenuItemTap(context, item['title']!);
                      },
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last Transaction",
                    style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: context.dynamicHeight(0.027)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightPurpleColor,
                          fontSize: context.dynamicHeight(0.027)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Payment",
                        style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.blackColor,
                            fontSize: context.dynamicHeight(0.02),
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
                        backgroundImage:
                            AssetImage(ImageEnum.profilePicture.imagePath),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.addCard);
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.containerColor,
        splashColor: AppColors.whiteColor,
      ),
    );
  }

  void handleMenuItemTap(BuildContext context, String title) {
    switch (title) {
      case "Outgoing":
        Navigator.pushNamed(context, RouteNames.addTransaction, arguments: {
          "type": "outgoing",
        });
        break;
      case "Income":
        Navigator.pushNamed(context, RouteNames.addTransaction, arguments: {
          "type": "income",
        });
        break;
      default:
        break;
    }
  }

  Column buildTitleAndSubtitle(BuildContext context) {
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

 Padding buildCardInfo(BuildContext context, String selectedCardName) {
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
                  fontSize: context.dynamicHeight(0.020)),
            ),
                        SizedBox(height: context.dynamicHeight(0.02),),
Consumer<TransactionController>(
  builder: (context, transactionController, child) {
    return Text(
      '\$ ${transactionController.balance.toStringAsFixed(2)}', 
      style: context.textTheme.bodyMedium?.copyWith(
        color: AppColors.whiteColor,
        fontSize: context.dynamicHeight(0.02),
      ),
    );
  },
),


          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Card Name",
              style: context.textTheme.headlineMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: context.dynamicHeight(0.020)),
            ),
            SizedBox(height: context.dynamicHeight(0.02),),
            Text(
              selectedCardName.isNotEmpty ? selectedCardName : 'No Cards Available',
              style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: context.dynamicHeight(0.020)),
            ),
          ],
        ),
      ],
    ),
  );
}
}

class QuickMenuItem extends StatelessWidget {
  final String title;
  final String svgPath;
  final Function()? onTap;

  const QuickMenuItem({
    Key? key,
    required this.title,
    required this.svgPath,
   
 this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: context.paddingAllLow,
              child: SvgPicture.asset(svgPath),
            ),
          ),
          Padding(
            padding: context.paddingTopLow,
            child: Text(
              title,
              style: context.textTheme.labelMedium?.copyWith(
                color: AppColors.extraLightPurple,
                fontSize: context.dynamicWidth(0.040),
              ),
            ),
          ),
        ],
      ),
    );
    
  }
  
}


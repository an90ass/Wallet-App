// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/routes/route_name.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';
import 'package:wallet/features/controller/card_controller.dart';
import 'package:wallet/features/controller/user_controller.dart';

import '../../controller/payment_controller.dart';
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
  final List<Map<String, dynamic>> listViewItems = [
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
  Widget build(BuildContext context) {
    final selectedCardName = Provider.of<CardStateNotifier>(context).cardName;
    final selectedCardNumber =
        Provider.of<CardStateNotifier>(context).cardNumber;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PaymentController>(context, listen: false)
          .fetchUserPayments(selectedCardNumber);
    });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.addCard);
                  },
                  icon: Icon(
                    Icons.add_card_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Add new card",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.containerColor,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                    // buildAvatar(context),
                    buildPictuerAvatar(context)
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.cardDetail),
                child: Card(
                  elevation: 5,
                  color: AppColors.containerColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: buildCardInfo(
                      context, selectedCardName, selectedCardNumber),
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
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Text(
                  //     "See All",
                  //     style: context.textTheme.bodyMedium?.copyWith(
                  //         color: AppColors.lightPurpleColor,
                  //         fontSize: context.dynamicHeight(0.027)),
                  //   ),
                  // ),
                ],
              ),
              Expanded(
                child: Consumer<PaymentController>(
                  builder: (context, paymentController, child) {
                    if (paymentController.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (paymentController.errorMessage != null) {
                      return Center(
                          child: Text(paymentController.errorMessage!));
                    }

                    if (paymentController.payments.isEmpty) {
                      return buildNoPaymentsFoundMessaj(context);
                    }

                    return ListView.builder(
                      itemCount: paymentController.payments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final payment = paymentController.payments[index];
                        final paymentTitle = payment['paymentMethod'];

                        final paymentIcon = listViewItems.firstWhere(
                          (element) => element['title'] == paymentTitle,
                          orElse: () =>
                              {"icon": ImageEnum.profilePicture.imagePath},
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
                            payment['paymentDescription'] ??
                                "Payment Description",
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
                          leading: 
                          CircleAvatar(
                            radius: context.dynamicWidth(0.08),
                            backgroundImage: AssetImage(paymentIcon),
                          ),
                          // leading: ClipRRect(
                          //   borderRadius:
                          //       BorderRadius.circular(context.dynamicWidth(0.08)),
                          //   child: Image.asset(
                          //     paymentIcon,
                          //     fit: BoxFit.cover,
                          //     width: context.dynamicWidth(0.16),
                          //     height: context.dynamicWidth(0.16),
                          //   ),
                          // ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
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
      case "Transfer":
        Navigator.pushNamed(context, RouteNames.transfer);
        break;
      case "Payment":
        Navigator.pushNamed(context, RouteNames.payments);
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
          "Walletly",
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

  // CircleAvatar buildAvatar(BuildContext context) {
  //   return CircleAvatar(
  //     radius: context.dynamicWidth(0.08),
  //     backgroundImage: AssetImage(ImageEnum.profilePicture.imagePath),
  //   );
  // }

  // Padding buildCardInfo(BuildContext context, String selectedCardName,
  //     String selectedCardNumber) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: context.dynamicWidth(0.1),
  //       vertical: context.dynamicWidth(0.05),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Balance",
  //               style: context.textTheme.headlineMedium?.copyWith(
  //                   color: AppColors.whiteColor,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: context.dynamicHeight(0.020)),
  //             ),
  //             SizedBox(height: context.dynamicHeight(0.02)),
  //             Consumer<TransactionController>(
  //               builder: (context, transactionController, child) {
  //                 if (selectedCardNumber !=
  //                     transactionController.currentCardNumber) {
  //                   transactionController.getBalance(selectedCardNumber);
  //                 }
  //                 return Text(
  //                   '\$ ${transactionController.balance.toStringAsFixed(2)}',
  //                   style: context.textTheme.bodyMedium?.copyWith(
  //                     color: AppColors.whiteColor,
  //                     fontSize: context.dynamicHeight(0.02),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Card Name",
  //               style: context.textTheme.headlineMedium?.copyWith(
  //                   color: AppColors.whiteColor,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: context.dynamicHeight(0.020)),
  //             ),
  //             SizedBox(height: context.dynamicHeight(0.02)),
  //             Text(
  //               selectedCardName.isNotEmpty
  //                   ? selectedCardName
  //                   : 'No Cards Available',
  //               style: context.textTheme.bodyMedium?.copyWith(
  //                   color: AppColors.whiteColor,
  //                   fontSize: context.dynamicHeight(0.020)),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
 Padding buildCardInfo(BuildContext context, String selectedCardName,
      String selectedCardNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.dynamicWidth(0.1),
        vertical: context.dynamicWidth(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Balance",
                  style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: context.dynamicHeight(0.020)),
                ),
                SizedBox(height: context.dynamicHeight(0.02)),
                Consumer<TransactionController>(
                  builder: (context, transactionController, child) {
                    if (selectedCardNumber !=
                        transactionController.currentCardNumber) {
                      transactionController.getBalance(selectedCardNumber);
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Enable horizontal scroll
                      child: Text(
                        '\$ ${transactionController.balance.toStringAsFixed(2)}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: context.dynamicHeight(0.02),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: context.dynamicWidth(0.05)), // Add some space between columns
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Card Name",
                  style: context.textTheme.headlineMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: context.dynamicHeight(0.020)),
                ),
                SizedBox(height: context.dynamicHeight(0.02)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Enable horizontal scroll
                  child: Text(
                    selectedCardName.isNotEmpty
                        ? selectedCardName
                        : 'No Cards Available',
                    style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: context.dynamicHeight(0.020)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNoPaymentsFoundMessaj(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dynamicHeight(0.1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.lightPurpleColor,
            size: 60,
          ),
          Text(
            'No payments found',
            style: context.textTheme.titleLarge?.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
              fontSize: context.dynamicHeight(0.02),
            ),
          ),
          Text(
            'It seems like there are no payments available yet',
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

  buildPictuerAvatar(BuildContext context) {
    final userController = Provider.of<UserController>(context, listen: false);

    return FutureBuilder<String?>(
      future: userController.getProfileImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.png'),
          );
        } else {
          return CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(snapshot.data!),
          );
        }
      },
    );
  }
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

class QuickMenuItem extends StatelessWidget {
  final String title;
  final String svgPath;
  final Function()? onTap;

  const QuickMenuItem(
      {Key? key, required this.title, required this.svgPath, this.onTap});

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

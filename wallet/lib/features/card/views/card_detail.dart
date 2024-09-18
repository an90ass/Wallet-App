import 'package:flutter/material.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';

class CardDetail extends StatelessWidget {
  final List<Map<String, String>> cardInfo = [
    {
      "title": "Name",
      "info": "Anas Almaqtari",
    },
    {
      "title": "Bank",
      "info": "Mabank",
    },
    {
      "title": "Account",
      "info": "--- ---- 123",
    },
    {
      "title": "Status",
      "info": "Active",
    },
    {
      "title": "Valid",
      "info": "2020 - 2025",
    },
  ];
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
          child: Container(
            alignment: Alignment.center,
            padding: context.paddingAllDefault,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Card Detail",
                    style: context.textTheme.headlineMedium?.copyWith(
                        color: AppColors.titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: context.dynamicHeight(0.035)),
                  ),
                  Image.asset(ImageEnum.horizontalCard.imagePath),
                  Column(
                    children: cardInfo.map((item) {
                      return CardInfoItem(
                        title: item['title']!,
                        info: item['info']!,
                      );
                    }).toList(),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Delete Card",
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.containerColor,
                        fontWeight: FontWeight.w500,
                        fontSize: context.dynamicHeight(0.023),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
          ),
        ));
  }
}

class CardInfoItem extends StatelessWidget {
  const CardInfoItem({super.key, required this.title, required this.info});
  final String title;
  final String info;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth((0.65)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.subtitleColor,
                fontSize: context.dynamicHeight(0.023)),
          ),
          SizedBox(
            width: context.dynamicWidth(0.05),
          ),
          Text(
            info,
            style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.blackColor,
                fontSize: context.dynamicHeight(0.023)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';

class AddCard extends StatelessWidget {
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
            padding:context.paddingAllDefault, 
          
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Add Card",
                      style: context.textTheme.headlineMedium?.copyWith(
                          color: AppColors.titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: context.dynamicHeight(0.035)),
                    ),
                    Image.asset(ImageEnum.verticalCard.imagePath),
                    Container(
                      width: context.dynamicWidth(0.6),
                      child: Text(
                        "Add a new card on your wallet for easy life",
                        style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.blackColor,
                            fontSize: context.dynamicHeight(0.023),
                            fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            ),
          
        ));
  }
}

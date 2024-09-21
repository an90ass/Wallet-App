import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';

import '../../controller/card_controller.dart';
import '../../models/card.dart';

class AddCard extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final CardModel card = CardModel(
      holderName: "", bankName: "", accountNumber: "", validDates: "");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: buildAppBar(context), body: buildBody(context, ref));
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: AppColors.containerColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        padding: context.paddingAllDefault,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTitle(context),
              SizedBox(height: context.dynamicHeight(0.02)),
              buildImage(),
              buildForm(context),
              buildText(context),
              buildSubmitButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Text(
      "Add Card",
      style: context.textTheme.headlineMedium?.copyWith(
          color: AppColors.titleColor,
          fontWeight: FontWeight.bold,
          fontSize: context.dynamicHeight(0.035)),
    );
  }

  Widget buildImage() {
    return Image.asset(ImageEnum.verticalCard.imagePath);
  }

  Widget buildText(BuildContext context) {
    return Container(
      width: context.dynamicWidth(0.6),
      child: Text(
        "Add a new card on your wallet for easy life",
        style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.blackColor,
            fontSize: context.dynamicHeight(0.023),
            fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: context.dynamicHeight(0.02)),
          buildNameField(context),
          SizedBox(height: context.dynamicHeight(0.02)),
          buildBankNameField(context),
          SizedBox(height: context.dynamicHeight(0.02)),
          buildAccountNumberField(context),
          SizedBox(height: context.dynamicHeight(0.02)),
          buildValidDatesField(context),
          SizedBox(height: context.dynamicHeight(0.02)),
          buildStatusField(context),
        ],
      ),
    );
  }

  Widget buildNameField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Cardholder Name",
        hintText: "Enter cardholder's name",
        border: OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.lightPurpleColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the cardholder's name";
        }
        return null;
      },
      onSaved: (String? value) {
        card.holderName = value!;
      },
    );
  }

  Widget buildBankNameField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Bank Name",
        hintText: "Enter bank name",
        border: OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.lightPurpleColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the bank name";
        }
        return null;
      },
      onSaved: (String? value) {
        card.bankName = value!;
      },
    );
  }

  Widget buildAccountNumberField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Account Number",
        hintText: "Enter account number",
        border: OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.lightPurpleColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the account number";
        }
        return null;
      },
      onSaved: (String? value) {
        card.accountNumber = value!;
      },
    );
  }

  Widget buildValidDatesField(BuildContext context) {
    final List<String> validDates = [
      '2024 - 2025',
      '2024 - 2026',
      '2024 - 2027',
      '2024 - 2028',
      '2024 - 2029',
    ];

    String? selectedDate;
    return DropdownButtonFormField<String>(
      
      decoration: InputDecoration(
        
        labelText: "Valid Dates",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        filled: true,
        fillColor: AppColors.lightPurpleColor,
      ),
      value: selectedDate,
      hint: Text("Select valid dates"),
      
      onChanged: (String? newValue) {
        selectedDate = newValue;
      },
      items: validDates.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onSaved: (String? value) {
        card.validDates = value!;
      },
    );
  }

  Widget buildStatusField(BuildContext context) {

    final List<String> status = ["Active", "Inactive"];
    String? selectedStatus;

    return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Status",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          filled: true,
          fillColor: AppColors.lightPurpleColor,
          
        ),
        value: selectedStatus,
        hint: Text("Select status"),
        onChanged: (String? newValue) {
          selectedStatus = newValue;
        },
        items: status.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onSaved: (String? value) {
          card.status = value;
        });
  }

 Widget buildSubmitButton(BuildContext context, WidgetRef ref) {
  return Padding(
    padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
    child: ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          ref
              .read(cardControllerProvider)
              .addCard(
                holderName: card.holderName,
                bankName: card.bankName,
                accountNumber: card.accountNumber,  // Used as document ID
                validDates: card.validDates,
                status: card.status ?? 'Active',
                ref: ref,  // Pass ref here
              )
              .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Card added successfully"),
                backgroundColor: Colors.green[600],
              ),
            );
          }).catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error: $e"),
                backgroundColor: Colors.red[600],
              ),
            );
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.containerColor,
        padding: EdgeInsets.symmetric(
            horizontal: context.dynamicWidth(0.3),
            vertical: context.dynamicHeight(0.02)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        "Save",
        style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.whiteColor,
            fontSize: context.dynamicHeight(0.025)),
      ),
    ),
  );
}

}

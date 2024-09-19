// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/features/controller/transactio_controller.dart';
import '../../../config/items/app_colors.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key, required this.type});
  final String type;

  @override
  State<StatefulWidget> createState() {
    return _AddTransactionState();
  }
}

List<Map<String, dynamic>> keyboard_arrow_down_rounded_List = [
  {"value": "1"},
  {"value": "2"},
  {"value": "3"},
  {"value": "4"},
  {"value": "5"},
  {"value": "6"},
  {"value": "7"},
  {"value": "8"},
  {"value": "9"},
  {"value": "00"},
  {"value": "0"},
  {"value": null, "icon": Icons.close_rounded},
];

class _AddTransactionState extends State<AddTransaction> {
  String _value = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(context), body: buildBody(context));
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

  Widget buildBody(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: context.paddingAllDefault,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              child: Text(
                '\$ $_value',
                style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkPurpleColor,
                    fontSize: context.dynamicHeight(0.035)),
              ),
            ),
            SizedBox(
              height: context.dynamicHeight(0.05),
            ),
            DropdownMenu(
              width: context.dynamicWidth(0.6),
              initialSelection: "Please select a card",
              trailingIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.darkPurpleColor,
              ),
              inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: AppColors.grayColor,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: context.dynamicWidth(0.01),
                      vertical: context.dynamicHeight(0.02))),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: "Card 1", label: "Card 1"),
                DropdownMenuEntry(value: "Card 2", label: "Card 2"),
              ],
            ),
            SizedBox(
                height: context.dynamicHeight(0.5),
                width: context.dynamicWidth(1),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 1.5),
                    itemCount: keyboard_arrow_down_rounded_List.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Center(
                          child: keyboard_arrow_down_rounded_List[index]
                                      ["value"] !=
                                  null
                              ? InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    setState(() {
                                      if (keyboard_arrow_down_rounded_List[
                                              index]["value"] ==
                                          "00") {
                                        _value += "00";
                                      } else if (keyboard_arrow_down_rounded_List[
                                              index]["value"] ==
                                          null) {
                                        _value =
                                            _value.substring(0, _value.length);
                                      } else {
                                        _value +=
                                            keyboard_arrow_down_rounded_List[
                                                index]["value"];
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(
                                        context.dynamicWidth(0.05)),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      keyboard_arrow_down_rounded_List[index]
                                          ["value"],
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                              color: AppColors.darkPurpleColor,
                                              fontSize:
                                                  context.dynamicHeight(0.028)),
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_value.isNotEmpty) {
                                        _value = _value.substring(
                                            0, _value.length - 1);
                                      }
                                    });
                                  },
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.darkPurpleColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      keyboard_arrow_down_rounded_List[index][
                                          "icon"],
                                      color: AppColors.darkPurpleColor,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    })),
            Consumer(
              builder: (context, ref, child) {
                return MaterialButton(
                  onPressed: () async {
                    await ref
                        .read(transactionControllerProvider)
                        .addTransaction(type: widget.type, value: _value)
                        .whenComplete(() {
                    const snackBar = SnackBar(
                        content: Text("Transaction added successfully!"),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.green,
                      );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    });
                  },
                  color: AppColors.darkBlueColor,
                  minWidth: context.dynamicWidth(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: context.paddingVerticalDefault,
                    child: Text(
                      "Add Transaction",
                      style: context.textTheme.titleLarge
                          ?.copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                );
              },
            ),
          ]),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';
import 'package:wallet/features/wallet/views/wallet.dart';
import 'package:wallet/features/stats/views/stats.dart';

class Home extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  List<Widget> _widgetOptions = <Widget>[
    Wallet(),
    Stats(),
    Text('2'),
    const Text('3'),
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected Index: $_selectedIndex');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     leading: IconButton(
        icon: const Icon(
          Icons.logout_sharp,
          color: AppColors.containerColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ),
          extendBody: true,
        body: 
         _widgetOptions.elementAt(_selectedIndex),
        
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.05)),
          child: BottomAppBar(
            surfaceTintColor: Colors.transparent,
            height: context.dynamicHeight(0.15),
            padding: context.paddingBottomHigh,
            color: Colors.transparent,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 10,
              color: AppColors.containerColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => _onItemTapped(0),
                    icon: SvgPicture.asset(ImageEnum.wallet.svgPath,
                        colorFilter: ColorFilter.mode(
                            _selectedIndex == 0
                                ? AppColors.lightPurpleColor
                                : AppColors.whiteColor,
                            BlendMode.srcIn
                            )
                            ),
                  ),
                  IconButton(
                      onPressed: () => _onItemTapped(1),
                      icon: SvgPicture.asset(ImageEnum.chart.svgPath,colorFilter: ColorFilter.mode(
                            _selectedIndex == 1
                                ? AppColors.lightPurpleColor
                                : AppColors.whiteColor,
                            BlendMode.srcIn
                            ))
                      ),
                  IconButton(
                      onPressed: () => _onItemTapped(2),
                      icon: SvgPicture.asset(ImageEnum.notification.svgPath,colorFilter: ColorFilter.mode(
                            _selectedIndex == 2
                                ? AppColors.lightPurpleColor
                                : AppColors.whiteColor,
                            BlendMode.srcIn
                            ))),
                  IconButton(
                      onPressed: () => _onItemTapped(3),
                      icon: SvgPicture.asset(ImageEnum.settings.svgPath,colorFilter: ColorFilter.mode(
                            _selectedIndex == 3
                                ? AppColors.lightPurpleColor
                                : AppColors.whiteColor,
                            BlendMode.srcIn
                            ))),
                ],
              ),
            ),
          ),
        ));
  }
}

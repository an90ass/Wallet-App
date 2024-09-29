import 'package:flutter/material.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/routes/route_name.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: buildSettingsPage(context),
        ),
      ),
    );
  }

  Widget buildSettingsPage(BuildContext context) {
    return Column(
      children: [
       const SizedBox(height: 30),
        buildTitle(),
       const SizedBox(height: 30),
        buildCards(context),
      const  SizedBox(height: 60),
        buildLogOutButton(),
      ],
    );
  }

  Widget buildTitle() {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        "Settings",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.titleColor,
        ),
      ),
    );
  }

  Widget buildCards(BuildContext context) {
    return Column(
      children: [
        buildSettingCard(
          context,
          Icons.account_circle_outlined,
          "Profile",
          Icons.navigate_next,
          () {
            Navigator.pushNamed(context, RouteNames.profileSettings);
          },
        ),
        buildSettingCard(
          context,
          Icons.settings_outlined,
          "Login Settings",
          Icons.navigate_next,
          () {
                        Navigator.pushNamed(context, RouteNames.loginSettings);

          },
        ),
        buildSettingCard(
          context,
          Icons.phone_in_talk_outlined,
          "Service Center",
          Icons.navigate_next,
          () {
                                    Navigator.pushNamed(context, RouteNames.serviceCenter);

          },
        ),
      ],
    );
  }

  Widget buildSettingCard(BuildContext context, IconData icon, String title,
      IconData trailingIcon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          AppColors.lightPurpleColor.withOpacity(0.2),
                      child: Icon(icon,
                          size: 28, color: AppColors.darkPurpleColor),
                    ),
                    SizedBox(width: 20),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkPurpleColor,
                      ),
                    ),
                  ],
                ),
                Icon(trailingIcon, size: 28, color: AppColors.darkPurpleColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogOutButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              elevation: 0,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.logout,
                  color: AppColors.darkPurpleColor,
                  size: 30,
                ),
                SizedBox(height: 8),
                Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.darkPurpleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

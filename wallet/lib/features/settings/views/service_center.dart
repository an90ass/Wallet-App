import 'package:flutter/material.dart';
import '../../../config/items/app_colors.dart';

class ServiceCenter extends StatelessWidget {
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                SizedBox(height: 20),
                buildInfoCard(
                  icon: Icons.phone,
                  title: 'Phone',
                  subtitle: '+905397924923', 
                ),
                buildInfoCard(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: 'anass12976@gmail.com', 
                ),
                buildInfoCard(
                  icon: Icons.link,
                  title: 'LinkedIn',
                  subtitle: 'https://www.linkedin.com/in/anas-a-12815124b/',
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Need Help?",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Feel free to reach us through the information below.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.deepPurple.withOpacity(0.1),
          child: Icon(icon, color: Colors.deepPurple, size: 30),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ),
    );
  }
}

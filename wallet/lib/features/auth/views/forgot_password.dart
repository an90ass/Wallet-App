import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/items/app_colors.dart';
import '../../controller/user_controller.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

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
      body: Center(    
        child: SingleChildScrollView(   
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,   
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
             buildTitle(),
              SizedBox(height: 16),
             buildTextField(),
              SizedBox(height: 20),
             buildSentButton(context),
              SizedBox(height: 20),
          //     Consumer<UserController>(
          //       builder: (context, userController, child) {
          //         final message = userController.forgotPassword_message;
          //         return message != null
          //             ? Center(
          //                 child: Container(
          //                   padding: EdgeInsets.all(12),
          //                   decoration: BoxDecoration(
          //                     color: AppColors.lightPurpleColor,
          //                     borderRadius: BorderRadius.circular(8),
          //                   ),
          //                   child: Text(
          //                     message,
          //                     style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
          //                   ),
          //                 ),
          //               )
          //             : SizedBox.shrink();
          //       },
          //     ),
            ],
          ),
        ),
      ),
    );
  }
  
 Widget buildTitle() {
  return const Padding(
    padding:  EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
    child: Text(
      'Please enter your email address to receive a password reset link',
      style: TextStyle(
        fontSize: 20, 
        fontWeight: FontWeight.bold, 
        color: AppColors.containerColor, 
        shadows: [
          Shadow(
            blurRadius: 5.0, 
            color: Colors.black12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      textAlign: TextAlign.center, 
    ),
  );
}

  
 Widget buildTextField() {
   return  TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Enter your Email',
                  labelStyle: TextStyle(color: AppColors.subtitleColor),
                  prefixIcon: Icon(Icons.email, color: AppColors.darkPurpleColor),
                ),
              );
  }
  
  Widget buildSentButton(BuildContext context) {
    return  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPurpleColor,  
                  foregroundColor: AppColors.whiteColor, 
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty && email.contains("@")) {
                    await Provider.of<UserController>(context, listen: false)
                        .forgotPassword(email: email);
                    final message = Provider.of<UserController>(context, listen: false).forgotPassword_message;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          message!
                        ),
                        backgroundColor: message == "Password reset link sent! Check your email."
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter a valid email',
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                        backgroundColor: Colors.red[700],
                      ),
                    );
                  }
                },
                child: Text('Send Reset Link', style: TextStyle(fontSize: 16)),
              );
  }
}

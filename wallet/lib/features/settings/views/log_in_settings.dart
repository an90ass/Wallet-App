import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/controller/user_controller.dart';

import '../../../config/items/app_colors.dart';

class LoginInSettings extends StatefulWidget {
  @override
  _LoginInSettingsState createState() => _LoginInSettingsState();
}

class _LoginInSettingsState extends State<LoginInSettings> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Email & Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 50),
                  buildCurrentEmailField(context),
                  SizedBox(height: 20),
                  buildNewEmailField(),
                  SizedBox(height: 20),
                  buildPasswordField(),
                  SizedBox(height: 20),
                  buildConfirmPasswordField(),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _updateUserInfo(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 18,color: AppColors.whiteColor),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.lightPurpleColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCurrentEmailField(BuildContext context) {
    String currentUserEmail = _getCurrentUserEmail(context);
    return TextFormField(
      controller: TextEditingController(text: currentUserEmail), 
      enabled: false, 
      decoration: InputDecoration(
        labelText: 'Current Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget buildNewEmailField() {
    return TextFormField(
      controller: _newEmailController,
      decoration: InputDecoration(
        labelText: 'New Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the new email';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'New Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      obscureText: !_isConfirmPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        } else if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  String _getCurrentUserEmail(BuildContext context) {
    final userController = Provider.of<UserController>(context, listen: false);
    return userController.getCurrentUserEmail() ?? '';
  }

  Future<void> _updateUserInfo(BuildContext context) async {
    final userController = Provider.of<UserController>(context, listen: false);

    try {
      await userController.updateEmail(newEmail: _newEmailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please check your email to verify the new email address.'),
        backgroundColor: Colors.orange,
      ));

      await userController.updatePassword(newPassword: _passwordController.text.trim());

      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update user info: $e'),
        backgroundColor: Colors.red[700],
      ));
    }
  }
}

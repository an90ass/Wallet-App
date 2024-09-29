import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/routes/route_name.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';
import 'package:wallet/features/controller/user_controller.dart';
import 'package:wallet/features/models/user.dart';

import '../../../config/items/app_colors.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  User user = User(userName: "", password: "", email: "");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  User _user = User(userName: "", password: "", email: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageEnum.signUp.imagePath),
                    fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sign up",
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.darkBlueColor, fontSize: 24),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            buildUserNameField(),
                            buildEmailField(),
                            buildPasswordField(),
                            buildSignUpButton(),
                            builSignInButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "Example: anass12976@gmail.com",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.lightPurpleColor),
          ),
        ),
        onSaved: (String? value) {
          _user.email = value!.trim();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an email';
          }
          return null;
        },
      ),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Example: anasAlmaqtari@gmail.com",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.lightPurpleColor),
          ),
        ),
        onSaved: (String? value) {
          _user.password = value!.trim();
        },
        validator: (value) {
          if (value == null || value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  buildSignUpButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        minWidth: double.infinity,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final userController =
                Provider.of<UserController>(context, listen: false);
            try {
              await userController.createUser(
                userName: _user.userName,
                email: _user.email,
                password: _user.password,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User created successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
              _emailController.text = "";
              _passwordController.text = "";
              _userNameController.text = "";
              Navigator.pop(context);
            } catch (e) {
              print("errrrror ${e}");
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Sign-up failed..try again."),
                  backgroundColor: Colors.red[700],
                ));
              });
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Sign up",
              style: TextStyle(color: AppColors.whiteColor, fontSize: 20)),
        ),
        color: AppColors.lightPurpleColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget builSignInButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don you have an account ? "),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Sign in",
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600]),
              ))
        ],
      ),
    );
  }

  buildUserNameField() {
    return TextFormField(
      controller: _userNameController,
      decoration: InputDecoration(
        labelText: "User Name",
        hintText: "Example: Anas",
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.lightPurpleColor),
        ),
      ),
      onSaved: (String? value) {
        _user.userName = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
    );
  }
}

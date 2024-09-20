import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet/config/routes/route_name.dart';
import 'package:wallet/features/models/user.dart';
import '../../controller/user_controller.dart'; 
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  User _user = User(userName: "", password: "", email: "");
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildEmailField(),
              buildPasswordField(),
              SizedBox(height: 10),
              buildSignInButton(),
              buildSignUpInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Example: Anas@gmail.com",
      ),
       onSaved: (String? value) {
        _user.email = value!;
      
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Example: 24141",
      ),
       onSaved: (String? value) {
        _user.password = value!;
      
      },
      obscureText: true,
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget buildSignInButton() {
    return Consumer(builder: (context, ref, child) {
      final userController = ref.read(userControllerProvider);

      return ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            try {
              await userController.signIn(
                  email: _user.email,
                  password: _user.password);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                content: Text("Logged in successfully!"),
                backgroundColor: Colors.green,
              ));
              Navigator.pushNamed(context, RouteNames.home);
            } catch (e) {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Sign-in failed. Please check your email and password and try again."),
                  backgroundColor: Colors.red[700],
                ));
              });
            }
          }
        },
        child:const  Text('Sign in'),
      );
    });
  }

  Widget buildSignUpInButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, RouteNames.signUp);
      },
      child: Text('Sign up'),
    );
  }
}

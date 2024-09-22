import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/routes/route_name.dart';
import 'package:wallet/features/controller/user_controller.dart';
import 'package:wallet/features/models/user.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  User user = User(userName: "", password: "", email: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildUserNameField(),
              buildEmailField(),
              buildPasswordField(),
              const SizedBox(height: 30.0),
              buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "User Name",
        hintText: "Example: Anas",
      ),
      onSaved: (String? value) {
        user.userName = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Example: Anas@gmail.com",
      ),
      onSaved: (String? value) {
        user.email = value!;
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
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Example: 24141",
      ),
      obscureText: true,
      onSaved: (String? value) {
        user.password = value!;
      },
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();

          final userController = Provider.of<UserController>(context, listen: false);

          try {
            await userController.createUser(
              email: user.email,
              password: user.password,
              userName: user.userName,
            );
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("User created successfully!"),
              backgroundColor: Colors.green,
            ));
            Navigator.pushNamed(context, RouteNames.signIn);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Error: $e"),
              backgroundColor: Colors.red,
            ));
          }
        }
      },
      child: Text("Sign Up"),
    );
  }
}

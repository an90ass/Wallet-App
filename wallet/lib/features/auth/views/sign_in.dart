import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/config/extensions/context_extension.dart';
import 'package:wallet/config/items/app_colors.dart';
import 'package:wallet/config/routes/route_name.dart';
import 'package:wallet/config/utility/enums/image_enum.dart';
import 'package:wallet/features/models/user.dart';
import '../../controller/user_controller.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible =false;
  final _formKey = GlobalKey<FormState>();
  User _user = User(userName: "", password: "", email: "");
  final formKey = GlobalKey<FormState>();

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
                      image: AssetImage(ImageEnum.signIn.imagePath),
                      fit: BoxFit.cover),
                )),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sign in ",
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.darkBlueColor, fontSize: 24),
                      ),
                    ),
                    Form(
                      key: _formKey,
                        child: Column(
                      children: [
                        buildEmailField(),
                        buildPasswordField(),
                        buildSignInButton(),
                        buildForgetPasswordButton(),
                        builSignUpButton(),
                      ],
                    ))
                  ],
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
                borderSide: BorderSide(color: AppColors.lightPurpleColor))),
                onSaved: (String? value){
                  _user.email = value!;
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
          hintText: "Example: 141@aaf3!",
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
        ),
        onSaved: (String? value){
          _user.password = value!;
        },
      ),
    );
  }
  buildSignInButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:5),
 
      child: MaterialButton(
        minWidth: double.infinity,
        onPressed: () async{
          if (_formKey.currentState!.validate()) {
_formKey.currentState!.save();
final userController = Provider.of<UserController>(context, listen: false);
          try {
            await userController.signIn(
              email: _user.email,
              password: _user.password,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Logged in successfully!"),
                backgroundColor: Colors.green,
              ),
            );
            _emailController.text ="";
            _passwordController.text ="";
            Navigator.pushNamed(context, RouteNames.home);
          } catch (e) {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Sign-in failed. Please check your email and password and try again.",
                ),
                backgroundColor: Colors.red[700],
              ));
            });
          }
        }
      
          },
          
        
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Sign in",
              style: TextStyle(color: AppColors.whiteColor, fontSize: 20)),
        ),
        color:  AppColors.lightPurpleColor,
      
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      
    );
  }

  Widget buildForgetPasswordButton() {
    return Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteNames.forgotPassword);
            },
            child: InkWell(
              child: Text(
                "Forget Password ?",
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600]),
              ),
            )));
  }
  
  Widget builSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top:20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't haven't an account ? "),
          GestureDetector(onTap: (){
            Navigator.pushNamed(context,RouteNames.signUp);
          }, child: Text("Sign up",  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600]),
          ))
        ],
      
      ),
    );
  }
}

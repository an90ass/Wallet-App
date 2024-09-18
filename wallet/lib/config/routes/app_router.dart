// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:wallet/features/auth/views/sign_up.dart';
import 'package:wallet/features/home/views/views/home.dart';
import '../../features/auth/views/sign_in.dart';
import 'route_name.dart';

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
      return MaterialPageRoute(builder: (context)=> SignIn());
      case RouteNames.signIn:
          return MaterialPageRoute(builder: (context)=> SignIn());
      case RouteNames.home:
          return MaterialPageRoute(builder: (context)=> Home());
      case RouteNames.signUp:
          return MaterialPageRoute(builder: (context)=> SignUp());

       default:
        return MaterialPageRoute(builder: (_) =>  SignIn());
    }
      
    }
  }





// import '../../features/auth/views/sign_in.dart';
// import '../../features/auth/views/sign_up.dart';
// import '../../features/card/views/add_card.dart';
// import '../../features/card/views/card_detail.dart';
// import '../../features/home/views/views/home.dart';
// import '../../features/transaction/views/add_transaction.dart';
// 

// class AppRouter {
//   static Route onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => const SignIn());
//       case RouteNames.signIn:
//         return MaterialPageRoute(builder: (_) => const SignIn());
//       case RouteNames.signUp:
//         return MaterialPageRoute(builder: (_) => const SignUp());
//       case RouteNames.home:
//         return MaterialPageRoute(builder: (_) => const Home());
//       case RouteNames.addCard:
//         return MaterialPageRoute(builder: (_) => const AddCard());
//       case RouteNames.cardDetail:
//         return MaterialPageRoute(builder: (_) => const CardDetail());
//       case RouteNames.addTransaction:
//         return MaterialPageRoute(builder: (_) => const AddTransaction());
//       default:
//         return MaterialPageRoute(builder: (_) => const SignIn());
//     }
//   }
// }

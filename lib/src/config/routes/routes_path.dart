import 'package:flutter/material.dart';
import '../../pages/cards_page/pages/credit_cards_pages/credit_card_page.dart';
import '../../pages/cards_page/pages/id_pages/id_Page.dart';
import '../../pages/registry/Home.dart';
import '../../pages/registry/login.dart';
import '../../pages/registry/signup.dart';
import 'route_names.dart';

class RoutesPath {
  static final routes = <String, WidgetBuilder>{
    Routes.HomePage: (context) => const HomePage(),
    Routes.IdPage: (context) => const IdPage(),
    Routes.CreditCardPage: (context) => const CreditCardPage(),
    Routes.LoginPage: (context) => LoginPage(),
    Routes.SignupPage: (context) =>  const SignupPage(),




  };
}

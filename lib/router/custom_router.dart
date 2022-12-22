import 'package:flutter/material.dart';
import 'package:flutter_app/views/first_page.dart';
import 'package:flutter_app/views/login_page.dart';
import 'package:flutter_app/views/chat_page.dart';
import 'package:flutter_app/views/register.dart';
import 'package:flutter_app/router/route_constants.dart';
import 'package:flutter_app/views/not_found_page.dart';
import 'package:flutter_app/views/settings_page.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case firstPageRoute:
        return MaterialPageRoute(builder: (_) => const FirstPage());
      case chatRoute:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}

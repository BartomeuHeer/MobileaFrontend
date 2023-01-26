import 'dart:html';

import 'package:flutter/material.dart';
/* import 'package:flutter_app/views/first_page.dart';
import 'package:flutter_front/views/profile_page.dart';
import 'package:flutter_front/views/route_list_page.dart';
import 'package:flutter_app/views/register.dart';
import 'package:flutter_app/views/login_page.dart';
import 'package:flutter_front/views/update_page.dart'; */
import 'package:flutter_app/models/language.dart';
import 'package:flutter_app/models/language_constants.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/router/route_constants.dart';
import 'package:flutter_app/utils/authentication.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import '../services/userServices.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreen();
}

final LocalStorage storage = LocalStorage('key');

@override
class _DrawerScreen extends State<DrawerScreen> {
  // TODO: implement createState
  bool userLogged() {
    var isLogged = storage.getItem('token');
    if (isLogged == null) {
      setState(() {});
      return false;
    }
    setState(() {});
    return true;
  }

  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    UserServices userProvider = Provider.of<UserServices>(context);

    return SafeArea(
        child: SizedBox(
            child: Drawer(
                child: Container(
      color: const Color.fromARGB(222, 57, 215, 250),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 35),
              ),
            ),
          ),
          /* ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Available Routes',
            ),
            onTap: () {
              /* Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RouteListPage())); */
            },
          ), */
          Visibility(
              visible: userLogged(),
              replacement: Column(children: [
                ListTile(
                  leading: const Icon(
                    Icons.login,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: const Text('Log In'),
                  onTap: () {
                    // To close the Drawer
                    Navigator.pop(context);
                    // Navigating to About Page
                    Navigator.pushNamed(context, loginRoute);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.app_registration,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: const Text('Register'),
                  onTap: () {
                    // To close the Drawer
                    Navigator.pop(context);
                    // Navigating to About Page
                    Navigator.pushNamed(context, registerRoute);
                  },
                ),
              ]),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: Text(
                      translation(context).settings,
                    ),
                    onTap: () {
                      // To close the Drawer
                      Navigator.pop(context);
                      // Navigating to About Page
                      Navigator.pushNamed(context, settingsRoute);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: const Text('Chat'),
                    onTap: () {
                      // To close the Drawer
                      Navigator.pop(context);
                      // Navigating to About Page
                      Navigator.pushNamed(context, chatRoute);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.route_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: const Text('Routes'),
                    onTap: () {
                      // To close the Drawer
                      Navigator.pop(context);
                      // Navigating to About Page
                      Navigator.pushNamed(context, routeRoute);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: const Text('Logout'),
                    onTap: () async {
                      // To close the Drawer
                      Navigator.pop(context);
                      // Navigating to About Page
                      storage.deleteItem('token');
                      setState(() {
                        _isSigningOut = true;
                      });
                      await Authentication.signOut(context: context);
                      setState(() {
                        _isSigningOut = false;
                      });
                    },
                  ),
                ],
              ))
        ],
      ),
    ))));
  }
}

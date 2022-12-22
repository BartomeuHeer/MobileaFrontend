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

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            child: Drawer(
                child: Container(
      color: Color.fromARGB(222, 57, 215, 250),
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
        ],
      ),
    ))));
  }
}

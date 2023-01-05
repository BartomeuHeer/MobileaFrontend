import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/msg.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/services/routeServices.dart';
/* import 'package:flutter_app/views/my_profile.dart';
import 'package:flutter_app/views/result_routes.dart';
import 'package:flutter_app/views/route_list_page.dart'; */
import 'package:web_date_picker/web_date_picker.dart';
import '../models/route.dart';
import '../widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyprofilePage extends StatefulWidget {
  const MyprofilePage({Key? key}) : super(key: key);

  @override
  State<MyprofilePage> createState() => _MyprofilePageState();
}

class _MyprofilePageState extends State<MyprofilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF4cbfa6),
          title: const Text("My Profile"),
        ),
        body: Container(
          //width: double.infinity,
          color: Color(0xFFF6EBF4),
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
                child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            )),
            SizedBox(
              height: 30,
              width: 30,
            ),
            Flexible(
                child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: 'Surname',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            )),
            SizedBox(
              height: 30,
              width: 30,
            ),
            Flexible(
                child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            )),
            SizedBox(
              height: 30,
              width: 30,
            ),
            Flexible(
                child: SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: 'Birthday',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            )),
            SizedBox(
              height: 30,
              width: 30,
            ),
          ]),
        ));
  }
}

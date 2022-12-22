import 'package:flutter/material.dart';
import 'package:flutter_app/services/routeServices.dart';
/* import 'package:flutter_app/views/my_profile.dart';
import 'package:flutter_app/views/result_routes.dart';
import 'package:flutter_app/views/route_list_page.dart'; */
import 'package:web_date_picker/web_date_picker.dart';
import '../models/route.dart';
import '../widgets/drawer.dart';
import 'package:intl/intl.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  final startPointController = TextEditingController();
  final stopPointController = TextEditingController();
  final dateInputController = TextEditingController();
  final time1InputController = TextEditingController();
  final time2InputController = TextEditingController();
  bool buttonEnabled = false;
  @override
  void dispose() {
    startPointController.dispose();
    stopPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerScreen(),
        appBar: AppBar(
          backgroundColor: Color(0xFF4cbfa6),
          /* leading: Icon(
            Icons.time_to_leave,
            color: Color(0xFFF6EBF4),
            size: 50,
          ), */
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  /*   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyProfile())); */
                },
                child: const Text(
                  'My Profile',
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ))
          ],
        ),
        body: Container(
          //width: double.infinity,
          color: Color(0xFFF6EBF4),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  controller: startPointController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText: 'From',
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
                  controller: stopPointController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText: "To",
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
                      child: Container(
                          child: WebDatePicker(
                        dateformat: 'yyyy-MM-dd',
                        onChange: (value) {
                          var outputFormat = DateFormat('yyyy-MM-dd');
                          dateInputController.text =
                              outputFormat.format(value!).toString();
                        },
                      )))),
              SizedBox(
                height: 30,
                width: 30,
              ),
              Flexible(
                  child: SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  controller: time1InputController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText: "Hour",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              )),
              Flexible(
                  child: SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  controller: time2InputController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText: "Hour",
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
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF4cbfa6),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      if ((startPointController.text.isNotEmpty) &&
                          (stopPointController.text.isNotEmpty) &&
                          (dateInputController.text.isNotEmpty) &&
                          (time1InputController.text.isNotEmpty) &&
                          (time2InputController.text.isNotEmpty)) {
                        String startDate = dateInputController.text +
                            'T' +
                            time1InputController.text +
                            ':00.000Z';
                        String stopDate = dateInputController.text +
                            'T' +
                            time2InputController.text +
                            ':00.000Z';
                        setState(() {
                          buttonEnabled = true;
                        });

                        /* var res = await routeService.getSearchedRoutes(
                            startPointController.text,
                            stopPointController.text,
                            dateInputController.text,
                            startDate,
                            stopDate); */
                        /* Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RouteListPage(
                                startPoint: startPointController.text,
                                stopPoint: stopPointController.text,
                                dateStart: startDate,
                                dateStop: stopDate))); */
                      }
                    },
                    child: const Text(
                      'SEARCH',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                ),
              )),
            ],
          ),
        )
        /* body: Stack(children: [
          Container(
            padding: EdgeInsets.only(left: 35, top: 130),
            child: Text(
              'Welcome\nBack',
              style: TextStyle(color: Colors.black, fontSize: 45),
            ),
          ),
          SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.5),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(children: [
                          TextField(
                            controller: startPointController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: stopPointController,
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ]),
                      )
                    ],
                  )))
        ]) */
        /* body: Row(
        children: [
          TextField(
              controller: startPointController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Start point",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
          TextField(
              controller: startPointController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Start point",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )))
        ],
      ), */
        );
  }
}

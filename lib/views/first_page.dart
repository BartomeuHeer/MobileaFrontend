import 'package:flutter/material.dart';
import 'package:flutter_app/services/routeServices.dart';
import 'package:provider/provider.dart';
/* import 'package:flutter_app/views/my_profile.dart';
import 'package:flutter_app/views/result_routes.dart';
import 'package:flutter_app/views/route_list_page.dart'; */
import 'package:date_time_picker/date_time_picker.dart';
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
  @override
  void dispose() {
    startPointController.dispose();
    stopPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Route2>? totalRoutes;
    RouteServices routeprovder = Provider.of<RouteServices>(context);
    return Scaffold(
        drawer: const DrawerScreen(),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 200, vertical: 90),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("5660740.jpg"), fit: BoxFit.fill),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: startPointController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'From',
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: TextField(
                        controller: stopPointController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: "To",
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: DateTimePicker(
                          controller: dateInputController,
                          type: DateTimePickerType.date,
                          initialValue: null,
                          dateMask: 'd MMM yyyy',
                          firstDate: DateTime(1980),
                          lastDate: DateTime(2100),
                          icon: const Icon(Icons.event),
                          dateLabelText: 'Select date',
                          onChanged: (val) => print(val),
                          validator: (value) {
                            print(value);
                            return null;
                          },
                          onSaved: (newValue) => print(newValue),
                        )),
                    Flexible(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () async {
                              print("date: " + dateInputController.text);
                              String date =
                                  dateInputController.text.toString() +
                                      "T00:00:00.000Z";
                              print(date);
                              totalRoutes =
                                  await routeprovder.getSearchedRoutes(
                                      startPointController.text,
                                      stopPointController.text,
                                      date);
                              print(totalRoutes);
                            },
                            child: const Text("Search")))
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  color: Colors.grey,
                ))
          ],
        ));
  }
}

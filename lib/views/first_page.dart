import 'package:flutter/material.dart';
import 'package:flutter_app/services/routeServices.dart';

import 'package:flutter_app/views/route_info.dart';
import 'package:flutter_app/views/videocall_lobby.dart';

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

  void _routesAvaiable() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Route2>? totalRoutes;
    RouteServices routeprovder = Provider.of<RouteServices>(context);
    bool isEmpty = false;
    RouteServices routeProvider = Provider.of<RouteServices>(context);
    return Scaffold(
        drawer: DrawerScreen(),
        appBar: AppBar(
          title: const Text("Menu"),
          actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.video_call),
            tooltip: 'Initiate a video call',
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideocallPage()));
            },
          ),
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
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 200, vertical: 90),
                decoration: const BoxDecoration(
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
                              await routeProvider.getSearchedRoutes(
                                  startPointController.text,
                                  stopPointController.text,
                                  dateInputController.text);
                              isEmpty = false;
                              setState(() {});
                              print(routeProvider.listRoute);
                            },
                            child: const Text("Search")))
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                    color: Colors.white,
                    child: Visibility(
                        visible: !isEmpty,
                        replacement: const Center(
                          child: Text("There are no routes for this data."),
                        ),
                        child: ListView.builder(
                            itemCount: routeProvider.listRoute.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: const Color(0xFF4cbfa6),
                                child: ListTile(
                                  title: Text(
                                      routeProvider.listRoute[index].name!),
                                  subtitle: Text(
                                      "Inicio:${routeProvider.listRoute[index].startPoint}| Final: ${routeProvider.listRoute[index].endPoint}"),
                                  trailing: SizedBox(
                                      width: 120,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: IconButton(
                                              icon: const Icon(Icons.article),
                                              onPressed: () {
                                                routeProvider.setRouteData(
                                                    routeProvider
                                                        .listRoute[index]);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const RouteInfo()));
                                              },
                                              tooltip: 'Details',
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            }))))
          ],
        ));
  }
}

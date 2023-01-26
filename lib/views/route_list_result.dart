import 'package:flutter/material.dart';
import 'package:flutter_app/services/routeServices.dart';

import 'package:flutter_app/views/route_info.dart';

import 'package:provider/provider.dart';
/* import 'package:flutter_app/views/my_profile.dart';
import 'package:flutter_app/views/result_routes.dart';
import 'package:flutter_app/views/route_list_page.dart'; */
import 'package:date_time_picker/date_time_picker.dart';
import '../models/route.dart';
import '../widgets/drawer.dart';
import 'package:intl/intl.dart';

class RouteResult extends StatefulWidget {
  const RouteResult({super.key});

  @override
  State<RouteResult> createState() => _RouteResultState();
}

class _RouteResultState extends State<RouteResult> {
  @override
  Widget build(BuildContext context) {
    RouteServices routeProvider = Provider.of<RouteServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routes result"),
      ),
      body: Container(
          color: Colors.white,
          child: Visibility(
              visible: routeProvider.listRoute.isNotEmpty,
              replacement: const Center(
                child: Text("There are no routes for this data."),
              ),
              child: ListView.builder(
                  itemCount: routeProvider.listRoute.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xFF4cbfa6),
                      child: ListTile(
                        title: Text(routeProvider.listRoute[index].name!),
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
                                          routeProvider.listRoute[index]);
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
                  }))),
    );
  }
}

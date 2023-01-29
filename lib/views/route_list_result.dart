import 'package:flutter/material.dart';
import 'package:flutter_app/services/routeServices.dart';

import 'package:flutter_app/views/route_info.dart';
import '../data/constants.dart';

import 'package:provider/provider.dart';
/* import 'package:flutter_app/views/my_profile.dart';
import 'package:flutter_app/views/result_routes.dart';
import 'package:flutter_app/views/route_list_page.dart'; */
import 'package:date_time_picker/date_time_picker.dart';
import '../models/points.dart';
import '../models/route.dart';
import '../widgets/drawer.dart';
import 'package:intl/intl.dart';

class RouteResult extends StatefulWidget {
  final String stopPoint;
  final String date;
  const RouteResult({super.key, required this.stopPoint, required this.date});

  @override
  State<RouteResult> createState() => _RouteResultState();
}

class _RouteResultState extends State<RouteResult> {
  String formatDate(String dateTo) {
    DateFormat dateFormat = DateFormat("yMMMMEEEd");
    String result = dateFormat.format(dateFormat.parse(dateTo));
    print(result);
    return result;
  }

  String formatTextbox(List<PointLoc> stopPoints) {
    String text = "";
    stopPoints.forEach((element) {
      text = "$text \n ${element.placeName}";
    });
    return text;
  }

  @override
  Widget build(BuildContext context) {
    RouteServices routeProvider = Provider.of<RouteServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routes result"),
      ),
      body: Row(
        children: [
          Column(
            children: [
              Flexible(
                flex: 1,
                child: Text(widget.date),
              ),
              Expanded(
                flex: 3,
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 350, vertical: 60),
                    color: Colors.white,
                    child: Visibility(
                        visible: routeProvider.listRoute.isNotEmpty,
                        replacement: const Center(
                          child: Text("There are no routes for this data."),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 90, vertical: 40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 15,
                                  ),
                              itemCount: routeProvider.listRoute.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: mainColor),
                                      borderRadius: BorderRadius.circular(20)),
                                  color: mainColor,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: ListTile(
                                          leading: Icon(Icons.route),
                                          title: Text(
                                              "${routeProvider.listRoute[index].startPoint!.placeName!} - ${routeProvider.listRoute[index].endPoint!.placeName!}"),
                                          subtitle: RichText(
                                              text: const TextSpan(children: [
                                            TextSpan(
                                                text: "Stop Point",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ])),

                                          //"Stop Points: \n ${formatTextbox(routeProvider.listRoute[index].stopPoint!)}"),

                                          /* trailing: SizedBox(
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
                                              )), */
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        child: Text(formatTextbox(routeProvider
                                            .listRoute[index].stopPoint!)),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.account_circle),
                                        title: Text("The driver is: "),
                                        subtitle: Text(
                                            "${routeProvider.listRoute[index].creator!.name}"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            ElevatedButton(
                                                onPressed: () => {
                                                      routeProvider.setRouteData(
                                                          routeProvider
                                                                  .listRoute[
                                                              index]),
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const RouteInfo()))
                                                    },
                                                child: Text('Details')),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

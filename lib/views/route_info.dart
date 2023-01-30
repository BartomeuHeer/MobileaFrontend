import 'package:flutter/material.dart';
import 'package:flutter_app/data/constants.dart';
import 'package:flutter_app/services/routeServices.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:flutter_app/views/first_page.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';

import '../models/points.dart';
import '../models/userclient.dart';
import '../widgets/drawer.dart';
import 'package:flutter_app/models/language_constants.dart';

class RouteInfo extends StatefulWidget {
  const RouteInfo({super.key});

  _RoutePageState createState() => _RoutePageState();
}

final LocalStorage storage = LocalStorage('key');

class _RoutePageState extends State<RouteInfo> {
  @override
  Widget build(BuildContext context) {
    String formatTextbox(List<PointLoc> stopPoints) {
      String text = "";
      stopPoints.forEach((element) {
        text = "$text \n ${element.placeName}";
      });
      if (text.isEmpty) {
        return "There are no stops in this route";
      }

      return text;
    }

    RouteServices routeProvider = Provider.of<RouteServices>(context);
    UserServices userProvider = Provider.of<UserServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Participate in route"),
        backgroundColor: const Color(0xFF4cbfa6),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(200),
          child: Card(
            color: mainColor,
            elevation: 10,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.route),
                    title: Text(
                      "${routeProvider.routeData.startPoint!.placeName!} - ${routeProvider.routeData.endPoint!.placeName!}",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text:
                              "Stop Points:${formatTextbox(routeProvider.routeData.stopPoint!)}",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ])),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total number of seats reserved for this route: "),
                      SizedBox(width: 4),
                      Text(
                          "${routeProvider.routeData.participants!.length}/${routeProvider.routeData.maxParticipants}"),
                      Icon(Icons.airline_seat_recline_normal),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("The price for all the route: "),
                      Text("${routeProvider.routeData.price}"),
                      SizedBox(width: 4),
                      Icon(Icons.euro),
                    ],
                  ),
                  Divider(height: 15),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text("The driver is: "),
                    subtitle: Text("${routeProvider.routeData.creator!.name}"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            final Map<String, dynamic> res =
                                await routeProvider.newParticipant(
                                    routeProvider.routeData.id!,
                                    storage.getItem("userId"));
                            print(res);

                            final Map<String, dynamic> res2 =
                                await routeProvider.newRouteInUser(
                                    routeProvider.routeData.id!,
                                    storage.getItem("userId"));

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const FirstPage()));
                          },
                          child: Text("Participate"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

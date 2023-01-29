import 'package:flutter/material.dart';
import 'package:flutter_app/services/routeServices.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:provider/provider.dart';

import '../models/userclient.dart';
import '../widgets/drawer.dart';
import 'package:flutter_app/models/language_constants.dart';


class RouteInfo extends StatefulWidget {
  const RouteInfo({super.key});

  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RouteInfo> {
  @override
  Widget build(BuildContext context) {
    RouteServices routeProvider = Provider.of<RouteServices>(context);
    UserServices userProvider = Provider.of<UserServices>(context);

    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text(routeProvider.routeData.name!),
        backgroundColor: const Color(0xFF4cbfa6),
      ),
      body: SizedBox(
        width: 900,
        height: 701,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 100,
              child: Text(routeProvider.routeData.name!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 300,
              height: 100,
              child: Text(routeProvider.routeData.creator!.name!,
                  style: const TextStyle(fontSize: 16)),
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 150,
                  height: 100,
                  /* //child: Text(routeProvider.routeData.startPoint!,
                      style: const TextStyle(fontSize: 16)), */
                ),
                SizedBox(
                  width: 150,
                  height: 100,
                  /* child: Text(routeProvider.routeData.endPoint!,
                      style: const TextStyle(fontSize: 16)), */
                ),
              ],
            ),
            Row(children: <Widget>[
              TextButton(
                onPressed: () async {
                  print(userProvider.userData.email);
                  routeProvider.newParticipant(
                      routeProvider.routeData, '637f6ef05fb5e624d8e214a5');
                  routeProvider.newRouteInUser(
                      routeProvider.routeData, userProvider.userData);
                  /*  _routeprovider.newBooking(_routeprovider.routeData,
                      _userprovider.userData, "selectedStopPoint"); */
                  Navigator.pop(context);
                },
                child: Text(
                  translation(context).join_route, //trad feta
                  style: TextStyle(color: Color(0xFF4cbfa6), fontSize: 25),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  translation(context).cancel, //trad feta
                  style: TextStyle(color: Color(0xFF4cbfa6), fontSize: 25),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

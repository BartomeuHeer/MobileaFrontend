import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/route.dart';
import 'package:flutter_app/models/user.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';

class RouteServices extends ChangeNotifier {
  Route2 _routeData = Route2(
      name: "",
      id: "",
      creator: User(name: "", id: "", password: "", email: "", admin: false),
      participants: [],
      startPoint: "",
      endPoint: "",
      stopPoint: [],
      dateOfBeggining: DateTime(2017));

  Route2 get routeData => _routeData;
  final LocalStorage storage = LocalStorage('key');
  void setRouteData(Route2 routeData) {
    _routeData = routeData;
  }

  Future<List<Route2>?> getRoutes() async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:5432/api/routes');
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      return routeFromJson(json);
    }
    return null;
  }

  Future<String> newParticipant(Route2 nRoute, User part) async {
    final Map<String, dynamic> registerData = {
      'id': nRoute.id,
      'participant': part
    };
    try {
      Response response = await post(
        Uri.parse('http://localhost:5432/api/routes/newParticipant'),
        body: json.encode(registerData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        //Convert from json List of Map to List of Student
        return "200";
      } else {
        return "400";
      }
    } catch (err) {
      return "300";
    }
  }

  Future<String> newRouteInUser(Route2 nRoute, User part) async {
    final Map<String, dynamic> registerData = {'id': part.id, 'route': nRoute};
    try {
      Response response = await post(
        Uri.parse('http://localhost:5432/api/routes/newRouteInUser'),
        body: json.encode(registerData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        //Convert from json List of Map to List of Student
        return "200";
      } else {
        return "400";
      }
    } catch (err) {
      return "300";
    }
  }
}

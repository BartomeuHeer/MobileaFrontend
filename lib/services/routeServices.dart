import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/points.dart';
import 'package:flutter_app/models/route.dart';
import 'package:flutter_app/models/userclient.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';

class RouteServices extends ChangeNotifier {
  Route2 _routeData = Route2(
      name: "",
      id: "",
      creator: ClientPopulate(email: "", name: "", id: ""),
      participants: [],
      startPoint: PointLoc(placeName: "", coordinates: []),
      endPoint: PointLoc(placeName: "", coordinates: []),
      stopPoint: [],
      dateOfBeggining: DateTime(2017),
      price: 0,
      duration: 0);

  Route2 get routeData => _routeData;
  final LocalStorage storage = LocalStorage('key');
  void setRouteData(Route2 routeData) {
    print(routeData);
    _routeData = routeData;
  }

  List<Route2> _listRoute = [];
  List<Route2> get listRoute => _listRoute;

  void setListRouteData(List<Route2> listRoute) {
    _listRoute = listRoute;
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

  Future<Map<String, dynamic>> getSearchedRoutes(
      String start, String stop, String initDate) async {
    //Map<String,dynamic> result;
    var msg = jsonEncode({"start": start, "stop": stop, "dateInit": initDate});

    //print(msg);
    var client = http.Client();
    var uri = Uri.parse('http://localhost:5432/api/routes/search');
    var response = await client.post(uri,
        headers: {'content-type': 'application/json'}, body: msg);
    List<Route2> rec = [];
    if (response.statusCode == 200) {
      print(response.body);
      //var decodedList = (json.decode(response.body) as List<dynamic>);
      _listRoute = routeFromJson(response.body);
      print("sexo duro");
      return {'status': "200", 'data': _listRoute};
    }
    return {'status': "400"};
  }

  Future<Map<String, dynamic>> newParticipant(
      String routeId, String userId) async {
    final Map<String, dynamic> registerData = {
      'routeId': routeId,
      'userId': userId
    };
    try {
      Response response = await post(
        Uri.parse('http://localhost:5432/api/routes/newParticipant'),
        body: json.encode(registerData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        //Convert from json List of Map to List of Student
        return {'status': "200"};
      } else {
        return {'status': "400"};
      }
    } catch (err) {
      return {'status': "300"};
    }
  }

  Future<Map<String, dynamic>> newRouteInUser(
      String routeId, String userId) async {
    final Map<String, dynamic> registerData = {
      'routeId': routeId,
      'userId': userId
    };
    try {
      Response response = await post(
        Uri.parse('https://localhost:5432/api/routes/newRouteInUser'),
        body: json.encode(registerData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        //Convert from json List of Map to List of Student
        return {'status': "200"};
      } else {
        return {'status': "400"};
      }
    } catch (err) {
      return {'status': "300"};
    }
  }

  Future<Map<String, dynamic>> createRoute(Route2 nRoute, String userId) async {
    final Map<String, dynamic> registerData = {
      'creator': userId,
      'startPoint': nRoute.startPoint,
      'endPoint': nRoute.endPoint,
      'stopPoint': nRoute.stopPoint,
      'dateOfBeggining': nRoute.dateOfBeggining.toString(),
      'price': nRoute.price,
      'maxParticipants': nRoute.maxParticipants,
      'duration': nRoute.duration
    };
    print(registerData);
    print("${nRoute.startPoint!.coordinates},${nRoute.startPoint!.placeName}");
    print("${nRoute.endPoint!.coordinates},${nRoute.endPoint!.placeName}");
    print(registerData["endPoint"]);
    print(registerData["stopPoint"]);
    Map<String, dynamic> result;
    try {
      Response response = await post(
        Uri.parse('http://localhost:5432/api/routes/create'),
        body: json.encode(registerData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        //Convert from json List of Map to List of Student

        Map<String, dynamic> responseData = jsonDecode(response.body);
        Route2 routeRes = Route2();
        routeRes = Route2.fromJson(responseData);
        result = {'status': "200", 'data': routeRes};
      } else {
        result = {
          'status': "400",
        };
      }
    } catch (err) {
      result = {
        'status': "300",
      };
    }
    return result;
  }
}

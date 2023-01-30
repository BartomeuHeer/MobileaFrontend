import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/route.dart';
import 'package:logger/logger.dart';

import '../models/userclient.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class UserServices extends ChangeNotifier {
  UserClient _userData =
      UserClient(name: "", id: "", password: "", email: "", admin: false);

  UserClient get userData => _userData;

  final LocalStorage storage = LocalStorage('key');
  var logger = Logger();
  void setUserData(String userId, String email) {
    _userData = userData;
    storage.setItem('userId', userId);
    storage.setItem('userEmail', email);
    storage.setItem('name', userData.name);
    storage.setItem('email', userData.email);
  }

  void setRouteToUser(RoutePopulate route2) {
    if (_userData.routes != null) {
      _userData.routes!.add(route2);
    } else {
      List<RoutePopulate> newR = [];
      newR.add(route2);
      _userData.routes = newR;
    }
  }

  Future<List<UserClient>?> getUsers() async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:5432/api/users');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return userFromJson(json);
    }
    return null;
  }

  Future<Map<String, dynamic>> logIn(String username, String password) async {
    final msg = jsonEncode({"email": username, "password": password});
    Map<String, dynamic> result;
    var res = await http.post(
        Uri.parse("http://localhost:5432/api/users/login"),
        headers: {'content-type': 'application/json'},
        body: msg);

    print(res.body);
    print(res.statusCode);
    if (res.statusCode == 200) {
      var token = JWTtoken.fromJson(await jsonDecode(res.body));
      storage.setItem('token', token.toString());
      storage.setItem('isLogged', true);
      Map<String, dynamic> responseData = jsonDecode(res.body);
      print(responseData["user"]);
      setUserData(responseData["userId"], username);

      return result = {'status': 200};
    } else {
      return result = {
        'status': 400,
      };
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final msg = jsonEncode({"userId": userId});
    Map<String, dynamic> result;
    var setUsrData = await http.post(
        Uri.parse("http://localhost:5432/api/users/getUserData"),
        headers: {'content-type': 'application/json'},
        body: msg);
    if (setUsrData.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(setUsrData.body);
      logger.i(responseData);
      _userData = UserClient.fromJson(responseData);
      result = {'status': "200", 'data': UserClient.fromJson(responseData)};
    } else {
      result = {'status': '401'};
    }

    return result;
  }

  Future<void> deleteUsers(String name) async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:5432/api/users/delete/$name');
    await client.delete(uri);
  }

  Future<String?> createUser(UserClient user) async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:5432/api/users/register');
    var userJS = json.encode(user.toJson());
    var res = await client.post(uri,
        headers: {'content-type': 'application/json'}, body: userJS);
    if (res.statusCode == 200) {
      return "200";
    } else {
      return "400";
    }
  }

  Future<void> loginUser(UserClient user) async {
    var client = http.Client();
    var uri = Uri.parse('http://localhost:5432/api/users/login');
    var userJS = json.encode(user.toJson());
    await client.post(uri,
        headers: {'content-type': 'application/json'}, body: userJS);
  }

  Future<bool> updateUser(UserClient user) async {
    var client = http.Client();
    var name = user.name;
    var uri = Uri.parse('http://localhost:5432/api/users//update/$name');
    var userJS = json.encode(user.toJson());
    var response = await client.put(uri,
        headers: {'content-type': 'application/json'}, body: userJS);
    if (response.statusCode == 200) {
      var json = response.body;
      return true;
    } else {
      return false;
    }
  }
}

class JWTtoken {
  final String tokValue;

  JWTtoken({
    required this.tokValue,
  });

  factory JWTtoken.fromJson(Map<String, dynamic> json) {
    return JWTtoken(
      tokValue: json['token'] as String,
    );
  }

  String toString() {
    return tokValue;
  }
}

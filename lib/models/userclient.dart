// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_app/models/booking.dart';
import 'package:flutter_app/models/rating.dart';
import 'package:flutter_app/models/route.dart';
import 'package:flutter_app/models/vehicle.dart';
import 'package:flutter_app/models/points.dart';

List<UserClient> userFromJson(String str) =>
    List<UserClient>.from(json.decode(str).map((x) => UserClient.fromJson(x)));

UserClient userJson(String str) =>
    (json.decode(str).map((x) => UserClient.fromJson(x)));

String userToJson(List<UserClient> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserClient {
  UserClient(
      {
      //this.id = "", // non nullable but optional with a default value
      this.name,
      this.id,
      this.password,
      this.email,
      this.birthday,
      this.routes,
      this.ratings,
      this.bookings,
      required this.admin});

  String? id;
  String? name;
  String? password;
  String? email;
  DateTime? birthday;
  List<RoutePopulate>? routes;
  List<String>? ratings;
  List<String>? bookings;
  //Vehicle? vehicle;
  bool admin;

  factory UserClient.fromJson(dynamic responseData) {
    return UserClient(
        id: responseData["_id"] as String,
        name: responseData['name'] as String,
        password: responseData['password'] as String,
        email: responseData['email'] as String,
        birthday: DateTime.parse(
            (responseData['birthday'] as String).replaceAll("T", " ")),
        routes: RoutePopulate.fromJson(responseData["route"])
            as List<RoutePopulate>?,
        ratings: responseData["ratings"],
        bookings: responseData["booking"],
        //vehicle: responseData["vehicle"],
        admin: responseData['admin'] as bool);
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "password": password,
        "email": email,
        "birthday": birthday,
        "route": routes,
        "ratings": ratings,
        "booking": bookings,
        //"vehicle": vehicle,
        "admin": admin
      };
}

class RoutePopulate {
  RoutePopulate({
    //this.id = "", // non nullable but optional with a default value
    this.id,
    this.startPoint,
    this.stopPoint,
    this.endPoint,
    this.dateOfBeggining,
    this.price,
    this.duration,
    this.maxParticipants,
  });

  String? id;
  PointLoc? startPoint;
  PointLoc? endPoint;
  List<PointLoc>? stopPoint;
  DateTime? dateOfBeggining;
  int? maxParticipants;
  double? price;
  int? duration;

  factory RoutePopulate.fromJson(dynamic responseData) {
    print("1111111111111111111");
    print(responseData["stopPoint"]);
    List<PointLoc>? tmp1 = responseData["stopPoint"] != null
        ? List<PointLoc>.from(
            responseData["stopPoint"].map((x) => PointLoc.fromJson(x)))
        : null;
    print("00000000000000000000000000000000000000000000");
    return RoutePopulate(
        id: responseData["_id"] as String,
        startPoint: PointLoc.fromJson(responseData["startPoint"]),
        endPoint: PointLoc.fromJson(responseData["endPoint"]),
        stopPoint: tmp1,
        dateOfBeggining:
            DateTime.parse(responseData["dateOfBeggining"] as String),
        maxParticipants: int.parse(responseData["maxParticipants"]),
        price: double.parse(responseData["price"]),
        duration: int.parse(responseData["duration"]));
  }
}

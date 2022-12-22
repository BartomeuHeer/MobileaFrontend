// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_app/models/booking.dart';
import 'package:flutter_app/models/rating.dart';
import 'package:flutter_app/models/route.dart';
import 'package:flutter_app/models/vehicle.dart';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

User userJson(String str) => (json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User(
      {
      //this.id = "", // non nullable but optional with a default value
      required this.name,
      required this.id,
      required this.password,
      required this.email,
      this.birthday,
      this.routes,
      this.ratings,
      this.bookings,
      this.vehicle,
      required this.admin});

  String id;
  String name;
  String password;
  String email;
  String? birthday;
  List<Route2>? routes;
  List<Rating>? ratings;
  List<Booking>? bookings;
  Vehicle? vehicle;
  bool admin;

  factory User.fromJson(Map<String, dynamic> responseData) {
    List<Route2>? tmp1 = responseData["routes"] != null
        ? List<Route2>.from(
            responseData["ratings"].map((x) => Route2.fromJson(x)))
        : null;
    List<Rating>? tmp2 = responseData["ratings"] != null
        ? List<Rating>.from(
            responseData["ratings"].map((x) => Rating.fromJson(x)))
        : null;
    List<Booking>? tmp3 = responseData["bookings"] != null
        ? List<Booking>.from(
            responseData["bookings"].map((x) => Booking.fromJson(x)))
        : null;

    return User(
        id: responseData["_id"],
        name: responseData["name"],
        password: responseData["password"],
        email: responseData["email"],
        birthday: responseData["birthday"],
        routes: tmp1,
        ratings: tmp2,
        bookings: tmp3,
        vehicle: responseData["vehicle"],
        admin: responseData["admin"]);
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "password": password,
        "email": email,
        "birthday": birthday,
        "routes": routes,
        "ratings": ratings,
        "bookings": bookings,
        "vehicle": vehicle,
        "admin": admin
      };
}

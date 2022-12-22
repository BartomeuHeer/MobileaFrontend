import 'dart:convert';


import 'package:flutter_app/models/user.dart';

List<Vehicle> ratingFromJson(String str) =>
    List<Vehicle>.from(json.decode(str).map((x) => Vehicle.fromJson(x)));

String vehicleToJson(List<Vehicle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vehicle {
  Vehicle(
      {
      
      required this.model,
      required this.brand,
      required this.year,
      required this.owner,
      required this.seats,
      required this.licencePlate,
      //required this.insurance
      });

  String model;
  String brand;
  int year;
  User owner;
  int seats;
  String licencePlate;
  //ObjectElement insurance;

  factory Vehicle.fromJson(Map<String, dynamic> responseData) {
    return new Vehicle(
        model: responseData["model"],
        brand: responseData["brand"],
        year: responseData["year"],
        owner: responseData["owner"],
        seats: responseData["seats"],
        licencePlate: responseData["licencePlate"],
        //insurance: responseData["insurance"]
        );
  }

  Map<String, dynamic> toJson() => {
        "model": model,
        "brand": brand,
        "year": year,
        "owner": owner,
        "seats": seats,
        "licencePlate": licencePlate,
        //"insurance": insurance
      };
}

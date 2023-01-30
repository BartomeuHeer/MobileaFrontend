import 'dart:convert';

import 'package:flutter_app/models/points.dart';
import 'package:flutter_app/models/userclient.dart';

List<Route2> routeFromJson(String str) =>
    List<Route2>.from(json.decode(str).map((x) => Route2.fromJson(x)));

String routeToJson(List<Route2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Route2 {
  Route2(
      {
      //this.id = "", // non nullable but optional with a default value
      this.name,
      this.id,
      this.creator,
      this.participants,
      this.startPoint,
      this.endPoint,
      this.stopPoint,
      this.dateOfBeggining,
      this.maxParticipants,
      this.duration,
      this.price});

  String? id;
  String? name;
  ClientPopulate? creator;
  List<ClientPopulate>? participants;
  PointLoc? startPoint;
  PointLoc? endPoint;
  List<PointLoc>? stopPoint;
  DateTime? dateOfBeggining;
  int? maxParticipants;
  double? price;
  int? duration;

  factory Route2.fromJson(dynamic responseData) {
    List<ClientPopulate>? tmp1 = responseData["participants"] != null
        ? List<ClientPopulate>.from(
            responseData["participants"].map((x) => ClientPopulate.fromJson(x)))
        : null;
    List<PointLoc>? tmp2 = responseData["stopPoint"] != null
        ? List<PointLoc>.from(
            responseData["stopPoint"].map((x) => PointLoc.fromJson(x)))
        : null;
    print(tmp2![0].placeName);

    return Route2(
        id: responseData["_id"] as String,
        name: responseData["name"] as String,
        creator: ClientPopulate.fromJson(responseData["creator"]),
        participants: tmp1,
        startPoint: PointLoc.fromJson(responseData["startPoint"]),
        endPoint: PointLoc.fromJson(responseData["endPoint"]),
        stopPoint: tmp2,
        dateOfBeggining:
            DateTime.parse(responseData["dateOfBeggining"] as String),
        maxParticipants: responseData["maxParticipants"] as int,
        price: responseData["price"] as double,
        duration: responseData["duration"] as int);
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "creator": creator,
        "participants": participants,
        "startPoint": startPoint,
        "endPoint": endPoint,
        "stopPoint": stopPoint,
        "dateOfBeggining": dateOfBeggining,
        "maxParticipants": maxParticipants,
        "price": price,
        "duration": duration
      };
}

class ClientPopulate {
  ClientPopulate({this.id, this.email, this.name});
  String? id;
  String? name;
  String? email;

  factory ClientPopulate.fromJson(dynamic responseData) {
    return ClientPopulate(
        id: responseData["_id"] as String,
        name: responseData['name'] as String,
        email: responseData['email'] as String);
  }
}

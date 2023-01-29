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
      this.price});

  String? id;
  String? name;
  UserClient? creator;
  List<UserClient>? participants;
  PointLoc? startPoint;
  PointLoc? endPoint;
  List<PointLoc>? stopPoint;
  DateTime? dateOfBeggining;
  int? maxParticipants;
  double? price;

  factory Route2.fromJson(Map<String, dynamic> responseData) {
    List<UserClient>? tmp1 = responseData["participants"] != null
        ? List<UserClient>.from(
            responseData["participants"].map((x) => UserClient.fromJson(x)))
        : null;
    List<PointLoc>? tmp2 = responseData["stopPoint"] != null
        ? List<PointLoc>.from(
          responseData["stopPoint"].map((x) => PointLoc.fromJson(x)))
        : null;

    return Route2(
        id: responseData["_id"],
        name: responseData["name"],
        creator: UserClient.fromJson(responseData["creator"]),
        participants: tmp1,
        startPoint: PointLoc.fromJson(responseData["startPoint"]),
        endPoint: PointLoc.fromJson(responseData["endPoint"]),
        stopPoint: tmp2,
        dateOfBeggining: DateTime.parse(responseData["dateOfBeggining"]),
        price:double.parse(responseData["price"]),
        maxParticipants: responseData["maxParticipants"]);
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
        "price": price
      };
}

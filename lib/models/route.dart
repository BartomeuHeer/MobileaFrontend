
import 'dart:convert';

import 'package:flutter_app/models/user.dart';

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
      this.dateOfBeggining
      });

  String? id;
  String? name;
  User? creator;
  List<User>? participants;
  String? startPoint;
  String? endPoint;
  List<String>? stopPoint;
  DateTime? dateOfBeggining;

  factory Route2.fromJson(Map<String, dynamic> responseData) {

  List<User>? tmp1 = responseData["participants"] != null
          ? List<User>.from(
              responseData["participants"].map((x) => User.fromJson(x)))
          : null;
  List<String>? tmp2 = responseData["stopPoint"] != null
          ? List<String>.from(
              responseData["stopPoint"])
          : null;

return Route2(
  id: responseData["_id"],
  name: responseData["name"],
  creator: User.fromJson(responseData["creator"]), 
  participants: tmp1,
  startPoint: responseData["startPoint"],
  endPoint: responseData["endPoint"],
  stopPoint: tmp2,
  dateOfBeggining: DateTime.parse(responseData["dateOfBeggining"])
  );
}
        

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "creator": creator,
        "participants": participants,
        "startPoint": startPoint,
        "endPoint": endPoint,
        "stopPoint": stopPoint,
        "dateOfBeggining": dateOfBeggining
      };
}

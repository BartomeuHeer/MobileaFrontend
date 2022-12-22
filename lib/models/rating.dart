
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/user.dart';

List<Rating> ratingFromJson(String str) =>
    List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

String ratingToJson(List<Rating> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rating {
  Rating(
      {
      //this.id = "", // non nullable but optional with a default value
      required this.author,
      required this.comment,
      required this.dest,
      required this.rate,
      required this.dateOfEntry
});

  User author;
  String comment;
  User dest;
  double rate;
  DateTime dateOfEntry;

  factory Rating.fromJson(Map<String, dynamic> responseData){ 

  return new Rating(

        author: responseData["author"],
        comment: responseData["comment"],
        dest: responseData["dest"],
        rate: responseData["rate"],
        dateOfEntry: responseData["dateOfEntry"]
  );}

  Map<String, dynamic> toJson() => {
        "author": author,
        "comment": comment,
        "dest": dest,
        "rate": rate,
        "dateOfEntry": dateOfEntry
      };
}

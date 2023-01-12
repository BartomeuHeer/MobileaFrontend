import 'dart:convert';
import 'package:flutter_app/models/user.dart';

class Complaint {
  Complaint({this.date, this.name, this.comment, this.category});

  DateTime? date;
  String? name;
  String? comment;
  String? category;

  factory Complaint.fromJson(Map<String, dynamic> responseData) {
    return Complaint(
      date: DateTime.parse(responseData["date"]),
      name: responseData["name"],
      comment: responseData["comment"],
      category: responseData["category"]
    );
  }

  Map<String, dynamic> toJson() => {
        "date": date,
        "name": name,
        "comment": comment,
        "category": category
      };
}

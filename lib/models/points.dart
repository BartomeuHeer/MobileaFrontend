import 'dart:convert';

List<PointLoc> pointFromJson(String str) =>
    List<PointLoc>.from(json.decode(str).map((x) => PointLoc.fromJson(x)));

String pointToJson(List<PointLoc> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PointLoc {
  String? placeName;
  String? type;
  List<double>? coordinates;
  double? price;
  int? duration;

  PointLoc({this.placeName, this.type, this.coordinates, this.price, this.duration});

  factory PointLoc.fromJson(Map<String, dynamic> responseData) {
    return PointLoc(
        placeName: responseData["placeName"],
        type: responseData["type"],
        coordinates: responseData["coordinates"],
        price: responseData["price"],
        duration: responseData["duration"]);
  }

  Map<String, dynamic> toJson() => {
        "placeName": placeName,
        "type": type,
        "coordinates": coordinates,
        "price": price,
        "duration":duration
      };
}

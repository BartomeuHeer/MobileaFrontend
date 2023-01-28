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

  PointLoc({this.placeName, this.type, this.coordinates, this.price});

  factory PointLoc.fromJson(Map<String, dynamic> responseData) {
    return PointLoc(
        placeName: responseData["placeName"],
        type: responseData["location.type"],
        coordinates: responseData["location.coordinates"],
        price: responseData["price"]);
  }

  Map<String, dynamic> toJson() => {
        "placeName": placeName,
        "location.type": type,
        "location.coordinates": coordinates,
        "price": price
      };
}

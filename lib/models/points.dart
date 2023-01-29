import 'dart:convert';

List<PointLoc> pointFromJson(String str) =>
    List<PointLoc>.from(json.decode(str).map((x) => PointLoc.fromJson(x)));

String pointToJson(List<PointLoc> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PointLoc {
  String? placeName;

  List<dynamic>? coordinates;
  double? price;

  PointLoc({this.placeName, this.coordinates, this.price});

  factory PointLoc.fromJson(Map<String, dynamic> responseData) {
    print(responseData);
    return PointLoc(
        placeName: responseData["placeName"],
        coordinates: responseData["coordinates"],
        price: responseData["price"]);
  }

  Map<String, dynamic> toJson() =>
      {"placeName": placeName, "coordinates": coordinates, "price": price};
}

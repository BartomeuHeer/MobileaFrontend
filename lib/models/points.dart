import 'dart:convert';

List<PointLoc> pointFromJson(String str) =>
    List<PointLoc>.from(json.decode(str).map((x) => PointLoc.fromJson(x)));

String pointToJson(List<PointLoc> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PointLoc {
  String? placeName;

  List<dynamic>? coordinates;
  double? price;
  int? duration;

  PointLoc({this.placeName, this.coordinates, this.price, this.duration});

  factory PointLoc.fromJson(dynamic responseData) {
    print(responseData);
    print("aqui llego");
    return PointLoc(
        placeName: responseData["placeName"] as String,
        coordinates: responseData["coordinates"] as List<dynamic>,
        price: responseData["price"] as double?,
        duration: responseData["duration"] as int?);
  }

  Map<String, dynamic> toJson() => {
        "placeName": placeName,
        "coordinates": coordinates,
        "price": price,
        "duration": duration
      };
}

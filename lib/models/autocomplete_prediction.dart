class AutocompletePrediction {
  /* final String? id;
  final String? placeType; */
  final String? placeName;
  final List<dynamic>? coordinates;
  final String? type;

  AutocompletePrediction({this.placeName, this.coordinates, this.type});

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    //print(json);
    return AutocompletePrediction(
        /* id: json['id'] as String,
        placeType: json['place_type'] as String?, */
        type: json['geometry.type'],
        placeName: json['place_name'] as String?,
        coordinates: json['geometry.coordinates'] as List<dynamic>?);
  }
}

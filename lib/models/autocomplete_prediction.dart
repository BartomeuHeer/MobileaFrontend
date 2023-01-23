class AutocompletePrediction {
  /* final String? id;
  final String? placeType; */
  final String? textName;
  final List<dynamic>? coordinates;

  AutocompletePrediction({this.textName, this.coordinates});

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    //print(json);
    return AutocompletePrediction(
        /* id: json['id'] as String,
        placeType: json['place_type'] as String?, */
        textName: json['place_name'] as String?,
        coordinates: json['center'] as List<dynamic>?);
  }
}

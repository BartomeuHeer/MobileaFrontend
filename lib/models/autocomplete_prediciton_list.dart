import 'dart:convert';
import 'autocomplete_prediction.dart';

class PredictionList {
  List<AutocompletePrediction>? predictions = [];
  PredictionList({this.predictions});

  factory PredictionList.fromJson(Map<String, dynamic> json) {
    print(json);
    return PredictionList(
      predictions: json['features']
          ?.map<AutocompletePrediction>(
              (json) => AutocompletePrediction.fromJson(json))
          .toList(),
    );
  }

  static PredictionList parsePredictionList(String response) {
    print(response);
    final parse = json.decode(response);
    var res = parse["features"] as List;
    print(res);
    return PredictionList(
        predictions: res
            .map<AutocompletePrediction>(
                (json) => AutocompletePrediction.fromJson(json))
            .toList());
  }
}

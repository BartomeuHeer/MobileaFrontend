import 'dart:convert';
import 'package:http/http.dart';
import '../models/location.dart';
import '../models/suggestion.dart';

class SearchService {
  Future<List<Suggestion>> autocomplete(String apiKey, String query,
      [Map<String, dynamic>? otherParams]) async {
    var queryParams =
        mergeParams({'key': apiKey, 'language': 'en-US'}, otherParams);
    var url = Uri.https(
        'api.tomtom.com', '/search/2/autocomplete/$query.json', queryParams);

    var res = await get(url);

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      var suggestions = <Suggestion>[];

      for (var result in body['results']) {
        for (var segment in result['segments']) {
          if (segment['type'] == 'plaintext') continue;

          suggestions.add(Suggestion.fromJson(segment));
        }
      }

      return suggestions;
    } else {
      throw 'Autocomplete search failed.';
    }
  }

  Future<List<Location>> fuzzySearch(String apiKey, String query,
      [Map<String, dynamic>? otherParams]) async {
    var queryParams =
        mergeParams({'key': apiKey, 'language': 'en-US'}, otherParams);
    var url = Uri.https(
        'api.tomtom.com', '/search/2/search/$query.json', queryParams);

    var res = await get(url);

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      var results = <Location>[];

      for (var result in body['results']) {
        results.add(Location.fromJson(result));
      }

      return results;
    } else {
      throw 'Fuzzy search failed.';
    }
  }
}

Map<String, dynamic> mergeParams(
    Map<String, dynamic> target, Map<String, dynamic>? source) {
  var targetCopy = {...target};
  targetCopy.addAll(source!);
  targetCopy.updateAll((key, value) => value?.toString());
  return targetCopy;
}
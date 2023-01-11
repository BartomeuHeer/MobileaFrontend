import 'package:maplibre_gl/mapbox_gl.dart';

class Location {
  final String id;
  final String type;
  final List addressLines;
  final LatLng latLng;

  Location({
    required this.type,
    required this.addressLines,
    required this.id,
    required this.latLng,
  });

  String get primaryText {
    return addressLines[0];
  }

  String get secondaryText {
    return addressLines[1];
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      type: json['type'],
      addressLines: getAddressLines(json),
      latLng: LatLng(json['position']['lat'], json['position']['lon']),
    );
  }

  static List getAddressLines(json) {
    var type = json['type'];
    var address = json['address'];
    var poi = json['poi'];
    var entityType = json['entityType'];

    if (type == 'Point Address' ||
        type == 'Address Range' ||
        type == 'Cross Street') {
      return [
        address['freeformAddress'],
        '${address['municipality']}, ${address['country']}'
      ];
    } else if (type == 'POI') {
      return [poi['name'], address['freeformAddress']];
    } else if (type == 'Street') {
      return [
        address['streetName'],
        '${address['postalCode']} ${address['municipality']}'
      ];
    } else if (type == 'Geography') {
      switch (entityType) {
        case 'Municipality':
          return [address['municipality'], address['country']];
        case 'MunicipalitySubdivision':
          return [address['municipalitySubdivision'], address['municipality']];
        case 'Country':
          return [address['country'], address['country']];
        case 'CountrySubdivision':
          return [address['countrySubdivision'], address['country']];
        default:
          return [address['freeformAddress'], address['country']];
      }
    } else {
      return [address['freeformAddress'], address['country']];
    }
  }

  Map toMap() {
    return {
      'id': id,
      'type': type,
      'addressLines': addressLines,
      'latLng': latLng
    };
  }
}
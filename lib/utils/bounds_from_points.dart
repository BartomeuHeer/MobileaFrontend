import 'package:maplibre_gl/mapbox_gl.dart';

LatLngBounds boundsFromPoints(List<LatLng> points) {
  double? minX;
  double? maxX;
  double? minY;
  double? maxY;

  for (final point in points) {
    var x = point.longitude;
    var y = point.latitude;

    if (minX == null || minX > x) {
      minX = x;
    }

    if (minY == null || minY > y) {
      minY = y;
    }

    if (maxX == null || maxX < x) {
      maxX = x;
    }

    if (maxY == null || maxY < y) {
      maxY = y;
    }
  }

  var sw = LatLng(minY as double, minX as double);
  var ne = LatLng(maxY as double, maxX as double);

  return LatLngBounds(southwest: sw, northeast: ne);
}
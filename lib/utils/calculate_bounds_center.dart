import 'package:maplibre_gl/mapbox_gl.dart';

LatLng calculateBoundsCenter(LatLngBounds bounds) {
  var ne = bounds.northeast;
  var sw = bounds.southwest;
  return LatLng(
      (ne.latitude + sw.latitude) / 2, (ne.longitude + sw.longitude) / 2);
}
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

Future<CameraPosition> fitBounds({
  required double width,
  required double height,
  required LatLngBounds bounds,
  required MaplibreMapController mapController,
  dynamic padding = 0,
  double maxZoom = 24,
}) async {
  var ne = bounds.northeast;
  var sw = bounds.southwest;

  if (padding is double) {
    var p = padding;
    padding = EdgeInsets.only(
      top: p,
      bottom: p,
      left: p,
      right: p,
    );
  }

  var screenLocations = await mapController.toScreenLocationBatch([ne, sw]);
  var nePt = screenLocations[0];
  var swPt = screenLocations[1];

  var size = Size(
    max((swPt.x.toDouble() - nePt.x.toDouble()).abs(), 0),
    max((swPt.y.toDouble() - nePt.y.toDouble()).abs(), 0),
  );

  var targetSize = Size(
    width - padding.left - padding.right,
    height - padding.top - padding.bottom,
  );

  assert(targetSize.width > 0 && targetSize.height > 0);

  var scaleX = targetSize.width / size.width;
  var scaleY = targetSize.height / size.height;

  var offsetX = (padding.right - padding.left) / 2 / scaleX;
  var offsetY = (padding.bottom - padding.top) / 2 / scaleY;

  var center =
      Point((nePt.x + swPt.x) / 2 + offsetX, (swPt.y + nePt.y) / 2 + offsetY);

  var centerLatLng = await mapController.toLatLng(center);
  var zoom =
      mapController.cameraPosition!.zoom + log2(min(scaleX, scaleY).abs());

  return CameraPosition(target: centerLatLng, zoom: min(zoom, maxZoom));
}

double logBase(num x, num base) => log(x) / log(base);

double log2(num x) => logBase(x, 2);
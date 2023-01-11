import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import '../models/location.dart';
import '../utils/bounds_from_points.dart';
import '../utils/calculate_bounds_center.dart';
import '../utils/fit_bounds.dart';

class LocationMap extends StatefulWidget {
  final String apiKey;
  final List<Location>? locations;
  final Location? selected;
  final Function(LatLng)? onMapCenterChange;

  const LocationMap({
    Key? key,
    required this.apiKey,
    this.locations,
    this.selected,
    this.onMapCenterChange,
  }) : super(key: key);

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  MaplibreMapController? _mapController;

  @override
  void didUpdateWidget(covariant LocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.locations != oldWidget.locations) {
      _mapController!.clearSymbols();

      var locations = widget.locations;
      if (locations != null) {
        _addLocationsToMap(locations);
        _fitMapToLocationBounds(locations);
      }
    }

    if (widget.selected != oldWidget.selected) {
      _selectLocation(widget.selected, oldWidget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaplibreMap(
      styleString:
          'https://api.tomtom.com/style/1/style/22.2.1-9?map=2/basic_street-light&poi=2/poi_dynamic-light&key=${widget.apiKey}',
      initialCameraPosition: const CameraPosition(
        target: LatLng(0.0, 0.0),
      ),
      trackCameraPosition:
          true, // Must be enabled in order to get the current map zoom in fitBounds.
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      onCameraIdle: _onCameraIdle,
    );
  }

  void _onMapCreated(MaplibreMapController controller) {
    controller.setSymbolIconAllowOverlap(true);
    _mapController = controller;
  }

  void _onCameraIdle() async {
    if (_mapController == null) return;

    var bounds = await _mapController!.getVisibleRegion();
    var mapCenter = calculateBoundsCenter(bounds);

    if (widget.onMapCenterChange != null) {
      widget.onMapCenterChange!(mapCenter);
    }
  }

  void _addLocationsToMap(List<Location> locations) {
    _mapController!.clearSymbols();

    var symbolOptions = locations
        .map((Location location) => SymbolOptions(
              geometry: location.latLng,
              iconImage: 'default_pin',
              iconSize: 0.8,
              iconOffset: const Offset(0, -44),
              zIndex: 0,
            ))
        .toList();
    var data = locations.map((location) => location.toMap()).toList();
    _mapController!.addSymbols(symbolOptions, data);
  }

  void _fitMapToLocationBounds(List<Location> locations) async {
    var mqd = MediaQueryData.fromWindow(ui.window);
    var points = locations
        .map(
            (result) => LatLng(result.latLng.latitude, result.latLng.longitude))
        .toList();
    var newBounds = boundsFromPoints(points);

    // Adjust the results bounds to fit within the space between the app search bar
    // and the results drawer. Width and height refer to the map width and height
    // in device-independent, logical pixels. Padding is also expressed as logical
    // pixels.
    CameraPosition newCameraPosition = await fitBounds(
      width: mqd.size.width,
      height: mqd.size.height,
      bounds: newBounds,
      maxZoom: 16,
      padding: EdgeInsets.only(
        top: mqd.padding.top + 120,
        right: 32,
        bottom: 440,
        left: 32,
      ),
      mapController: _mapController!,
    );

    await _mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Symbol _symbolById(String id) {
    return _mapController!.symbols
        .firstWhere((symbol) => symbol.data!['id'] == id);
  }

  void _selectLocation(Location? newLocation, Location? oldLocation) async {
    if (oldLocation != null) {
      var oldSelectedSymbol = _symbolById(oldLocation.id);
      _mapController!.updateSymbol(
          oldSelectedSymbol, const SymbolOptions(iconSize: 0.8, zIndex: 0));
    }

    if (newLocation != null) {
      var selectedSymbol = _symbolById(newLocation.id);
      _mapController!.updateSymbol(
          selectedSymbol, const SymbolOptions(iconSize: 1.1, zIndex: 10));

      await _mapController
          ?.animateCamera(CameraUpdate.newLatLng(newLocation.latLng));
    }
  }
}
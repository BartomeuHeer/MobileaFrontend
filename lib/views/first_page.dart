import 'package:flutter/material.dart';
import 'package:flutter_app/models/autocomplete_prediction.dart';
import 'package:flutter_app/services/routeServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/views/route_info.dart';
import 'package:flutter_app/views/route_list_result.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../widgets/search_map_predictions.dart';
import 'package:textfield_search/textfield_search.dart';
import '../data/constants.dart';
import 'package:http/http.dart' as http;
import '../models/autocomplete_prediciton_list.dart';
/* import 'package:flutter_app/views/my_profile.dart';
import 'package:flutter_app/views/result_routes.dart';
import 'package:flutter_app/views/route_list_page.dart'; */
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import '../models/route.dart';
import '../models/autocomplete_prediction.dart';
import '../widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  final startPointController = TextEditingController();
  final stopPointController = TextEditingController();
  final dateInputController = TextEditingController();
  final selectedStart = TextEditingController();

  late PredictionList _predictionList = PredictionList();
  bool fullPrediction = false;

  final String apiKey = mapBoxKey;
  late Position _currentPosition;
  @override
  void dispose() {
    startPointController.dispose();
    stopPointController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedStart.addListener(_printLatestValue());
  }

  _printLatestValue() {
    print("Textfield value: ${selectedStart.text}");
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    await Geolocator.getCurrentPosition().then((Position pos) {
      setState(() {
        _currentPosition = pos;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void getPredict(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String language = prefs.getString("languageCode") ?? 'en';
    String uri =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$value.json?access_token=$apiKey&cachebuster=1566806258853&autocomplete=true&language=$language&limit=5";
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        _predictionList = PredictionList.parsePredictionList(response.body);
        if (_predictionList.predictions!.isNotEmpty) {
          fullPrediction = true;
        }
        print(_predictionList.predictions![0].textName);
        print(_predictionList.predictions![0].coordinates);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = false;
    RouteServices routeProvider = Provider.of<RouteServices>(context);
    List<AutocompletePrediction>? predictions = [];
    _predictionList = PredictionList(predictions: predictions);
    return Scaffold(
        drawer: DrawerScreen(),
        appBar: AppBar(
          title: const Text("Menu"),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("5660740.jpg"), fit: BoxFit.fill),
                ),
                child: Container(
                  /* margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20), */
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextFieldSearcher(
                            label: "Start point",
                            apiKey: apiKey,
                            controller: selectedStart),
                        /* child: TextField(
                          controller: startPointController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: 'From',
                          ),
                          onChanged: (value) {
                            getPredict(value);
                          },
                          /* onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MapBoxAutoCompleteWidget(
                                  apiKey: apiKey,
                                  hint: "Select starting point",
                                  onSelect: (place) {
                                    // TODO : Process the result gotten
                                    startPointController.text =
                                        place.placeName!;
                                  },
                                  limit: 10,
                                ),
                              ),
                            );
                          }, */
                        ), */
                      ),
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller: stopPointController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            labelText: "To",
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: DateTimePicker(
                            controller: dateInputController,
                            type: DateTimePickerType.date,
                            initialValue: null,
                            dateMask: 'd MMM yyyy',
                            firstDate: DateTime(1980),
                            lastDate: DateTime(2100),
                            icon: const Icon(Icons.event),
                            dateLabelText: 'Select date',
                            onChanged: (val) => print(val),
                            validator: (value) {
                              print(value);
                              return null;
                            },
                            onSaved: (newValue) => print(newValue),
                          )),
                      Flexible(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () async {
                                await routeProvider.getSearchedRoutes(
                                    startPointController.text,
                                    stopPointController.text,
                                    dateInputController.text);
                                isEmpty = false;
                                setState(() {});
                                print(routeProvider.listRoute);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const RouteResult()));
                              },
                              child: const Text("Search")))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  color: Colors.white,
                  child: Visibility(
                    visible: _predictionList.predictions!.isNotEmpty,
                    child: Expanded(
                      child: ListView.separated(
                        itemCount: _predictionList.predictions!.length,
                        separatorBuilder: (cx, _) => const Divider(),
                        itemBuilder: (cx, index) {
                          AutocompletePrediction _prediction =
                              _predictionList.predictions![index];

                          return ListTile(
                            title: Text(_prediction.textName!),
                            //subtitle: Text(_prediction.coordinates![0]),
                          );
                        },
                      ),
                    ),
                  ),
                  /* child: FlutterMap(
                    options: MapOptions(
                      minZoom: 5,
                      maxZoom: 15,
                      zoom: 13,
                    ),
                    /* center: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude)), */
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/ngneer1/cld1klsog001701s1lusu2jhs/tiles/256/{z}/{x}/{y}@2x?access_token=$apiKey',
                      )
                    ],
                  ), */
                ))
          ],
        ));
  }
}

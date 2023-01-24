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
  final selectedStartText = TextEditingController();
  final selectedPrediciton = AutocompletePrediction();

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
    _determinePosition();
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return;
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return;
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
                          controller: selectedStartText,
                          getSelectedValue: (value) {
                            print(value);
                          },
                          currentPos: _currentPosition,
                        ),

                        /* child: TextFieldSearch(
                          label: "label",
                          controller: selectedStartText,
                          initialList: const ["hoa", "wuuuu", "djsd"],
                          getSelectedValue: (value){
                            print(value);
                          },
                        ),  */
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
                  height: double.infinity,
                  //margin: const EdgeInsets.only(left: 50, right: 50),
                  color: Colors.white,
                  child: FlutterMap(
                    options: MapOptions(
                        minZoom: 5,
                        maxZoom: 15,
                        zoom: 13,
                        center: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude)),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/ngneer1/cld1klsog001701s1lusu2jhs/tiles/256/{z}/{x}/{y}@2x?access_token=$apiKey',
                      ),
                      
                    ],
                    
                  ),
                ))
          ],
        ));
  }
}

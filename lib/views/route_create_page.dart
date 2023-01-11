import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/views/first_page.dart';
import 'package:intl/intl.dart';

import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:web_date_picker/web_date_picker.dart';
import '../models/location.dart';
import '../models/search.dart';
import '../widgets/location_map.dart';
import '../widgets/search_results_drawer.dart';
import '../widgets/location_search_delegate.dart';
import '../widgets/searchbar.dart';
//import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
const apiKey = 'ztWk2zGkhANxHz840iqq9EZ37PW61G97'; // https://developer.tomtom.com
class RouteCreatePage extends StatefulWidget {
  const RouteCreatePage({Key? key}) : super(key: key);

  @override
  _RouteCreatePageState createState() => _RouteCreatePageState();
}

class _RouteCreatePageState extends State<RouteCreatePage> {
  final BottomDrawerController _bottomDrawerController =
      BottomDrawerController();
   LatLng _mapCenter = const LatLng(0.0, 0.0);
  Location? _selected;
  Search? _search;
  int currentStep = 0;
  int seats=1;
  List<String> stopPoints=[];
  final StartPointController = TextEditingController();
  final EndPointController = TextEditingController();
  final DatePickerController = TextEditingController();
  final timeInputController = TextEditingController();
  final seatsInputController = TextEditingController();
  @override
  void dispose() {
    StartPointController.dispose();
    EndPointController.dispose();
    DatePickerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Create a new Route",
          ),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              onStepCancel: () {
                bool isFirstStep =(currentStep==0);
                if (isFirstStep){
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FirstPage()));
                }
                else{
                  setState(() {
                      currentStep -= 1;
                    });
                }},
              onStepContinue: () {
                bool isLastStep = (currentStep == getSteps().length - 1);
                if (isLastStep) {
                  //Do something with this information
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepTapped: (step) => setState(() {
                currentStep = step;
              }),
              steps: getSteps(),
            )),
      ),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("General information"),
        content: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context)
              .size
              .width*
              0.2,
              height:MediaQuery.of(context)
              .size
              .height*
              0.2,
              child: Flexible(
                child: TextField(
                  controller: StartPointController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: 'From',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: Flexible(
                child: TextField(
                  controller: EndPointController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    labelText: "To",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: Flexible(
                child: Container(
                  child: WebDatePicker(
                    initialDate: DateTime.now(),
                    dateformat: 'yyyy-MM-dd',
                    onChange: (value) {
                      var outputFormat = DateFormat('yyyy-MM-dd');
                      DatePickerController.text =
                          outputFormat.format(value!).toString();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: Flexible(
                child: DropdownButton<int>(
                  hint: Text("Seats"),
                  value: seats,
                  icon: Icon(Icons.airline_seat_recline_normal),
                  items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
                    return new DropdownMenuItem<int>(
                      value: value,
                      child: new Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      seats = newVal!;
                    });
                  }),
              ),
            ),
              SizedBox(
                width: 300,
                height: 50,
                child: Flexible(
                  child: TextField(
                  controller: timeInputController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText: "Hour",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                ),
              ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Stop points"),
        content: Container(
          width: MediaQuery.of(context)
              .size
              .width*
              1,
              height:MediaQuery.of(context)
              .size
              .height*
              1,
          child: Column(
             children: <Widget>[
            Positioned(
              top: 0,
              right: 8,
              left: 8,
              child: Container(
                width: MediaQuery.of(context)
              .size
              .width*
              0.8,
              height:MediaQuery.of(context)
              .size
              .height*
              0.2,
                child: SafeArea(
                  child: SearchBar(
                    query: _search?.query,
                    onTap: (context) async {
                      await showSearch(
                        context: context,
                        delegate: LocationSearchDelegate(
                          apiKey: apiKey,
                          mapCenter: _mapCenter,
                          onSearchResults: _onSearchResults,
                          onClear: _onClear,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (_search != null)
              SearchResultsDrawer(
                controller: _bottomDrawerController,
                search: _search!,
                selectedId: _selected?.id,
                onItemTap: _onLocationSelected,
                onClear: _onClear,
              ),
          ],
            ),
        ) 
      ),
    ];
  }
   void _onMapCenterChange(LatLng mapCenter) {
    setState(() {
      _mapCenter = mapCenter;
    });
  }

  void _onSearchResults(Search search) {
    setState(() {
      _search = search;
    });

    // Delay opening the drawer until it's been rendered.
    Future.delayed(
      const Duration(milliseconds: 300),
      () => _bottomDrawerController.open(),
    );
  }

  void _onLocationSelected(Location location) {
    setState(() {
      _selected = location;
    });
  }

  void _onClear() {
    setState(() {
      _selected = null;
      _search = null;
    });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_app/data/constants.dart';
import 'package:flutter_app/models/autocomplete_prediciton_list.dart';
import 'package:flutter_app/models/points.dart';
import 'package:flutter_app/models/route.dart';
import 'package:flutter_app/models/userclient.dart';
import 'package:flutter_app/services/routeServices.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:flutter_app/views/first_page.dart';
import 'package:flutter_app/widgets/search_map_predictions.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../models/autocomplete_prediction.dart';

//import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
class RouteCreatePage extends StatefulWidget {
  const RouteCreatePage({Key? key}) : super(key: key);

  @override
  _RouteCreatePageState createState() => _RouteCreatePageState();
}

class _RouteCreatePageState extends State<RouteCreatePage> {
  int currentStep = 0;
  int seats=1;
  List<PointLoc> stopPoints = [];
  final StartPointController = TextEditingController();
  final EndPointController = TextEditingController();
  final dateInputController = TextEditingController();
  final timeInputController = TextEditingController();
  final seatsInputController = TextEditingController();
  final stopPointController = TextEditingController();
  final priceEndPointController = TextEditingController();
  final priceStopPointController = TextEditingController();
  final durationController = TextEditingController();
  final durationStopController = TextEditingController();
  PointLoc selectedStart = PointLoc();
  PointLoc selectedEnd = PointLoc();
  PointLoc selectedStop = PointLoc();
  Route2 ruta = Route2();
  List<Marker> markerList = [];

  late UserClient userData;
  final LocalStorage storage = LocalStorage('key');
  UserServices serrvice = UserServices();

  late PredictionList _predictionList = PredictionList();
  bool fullPrediction = false;

  final String apiKey = mapBoxKey;
  @override
  void dispose() {
    StartPointController.dispose();
    EndPointController.dispose();
    dateInputController.dispose();
    timeInputController.dispose();
    seatsInputController.dispose();
    priceEndPointController.dispose();
    priceStopPointController.dispose();
    durationStopController.dispose();
    durationController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> downloadData(UserServices serv) async {
    print(serrvice.storage.getItem('userId'));
    var id = storage.getItem('userId');
    var response = await serrvice.getUserData(id);
    print(response);

    return response;
    // return your response
  }

  void setPoints(AutocompletePrediction prediction, PointLoc point) {
    print(prediction.placeName);
    print(prediction.coordinates);

    point.placeName = prediction.placeName;
    point.coordinates = prediction.coordinates!.cast<double>();
    point.type = prediction.type;
    print(point.placeName);
    print(prediction.coordinates);
  }

  void setStopPoint(PointLoc point, double price, int duration){
    print(point.placeName);
    point.price = price;
    point.duration=duration;
    stopPoints.add(point);
    print(stopPoints);
  }

  void setRouteParams(
    Route2 route,
    PointLoc selectedStart,
    PointLoc selectedEnd,
    double price,
    int seats,
    String dateOfbeg,
    List<PointLoc> listStopPoints,
    int duration
  ) {
    route.endPoint = selectedEnd;
    route.startPoint = selectedStart;
    route.price = price;
    route.maxParticipants = seats;
    route.stopPoint = listStopPoints;
    route.dateOfBeggining = DateTime.parse(dateOfbeg);
    route.duration=duration;
    print(route.dateOfBeggining);
  }

  @override
  Widget build(BuildContext context) {
    UserServices userServices = Provider.of<UserServices>(context);
    RouteServices routeServices = Provider.of<RouteServices>(context);
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
                bool isFirstStep = (currentStep == 0);
                if (isFirstStep) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FirstPage()));
                } else {
                  setState(() {
                    currentStep -= 1;
                  });
                }
              },
              onStepContinue: () async {
                bool isLastStep = (currentStep == getSteps().length - 1);
                if (isLastStep) {
                  var id = storage.getItem('userId');
                  setRouteParams(
                      ruta,
                      selectedStart,
                      selectedEnd,
                      double.parse(priceEndPointController.text),
                      seats,
                      dateInputController.text,
                      stopPoints,
                      int.parse(durationController.text));
                  final Map<String, dynamic> res =
                      await routeServices.createRoute(ruta, id);
                  if (res['status'] == "401") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Route was not added due to some error :(')));
                    return;
                  }
                  if (res['status'] == "200") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Route was added successfully :)')));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirstPage()));
                    return;
                  }
                } else {
                  if (StartPointController.text.isNotEmpty) {
                    setState(() {
                      currentStep += 1;
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('XD')));
                    return;
                  }
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
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.1,
              child: TextFieldSearcher(
                label: "Start point",
                apiKey: apiKey,
                controller: StartPointController,
                getSelectedValue: (value) {
                  print(value);
                  setPoints(value, selectedStart);
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.1,
              child: TextFieldSearcher(
                label: "End point",
                apiKey: apiKey,
                controller: EndPointController,
                getSelectedValue: (value) {
                  print(value);
                  setPoints(value, selectedEnd);
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Container(
                  child: DateTimePicker(
                controller: dateInputController,
                type: DateTimePickerType.dateTime,
                initialValue: null,
                initialDate: DateTime.now(),
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
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select available seats"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: DropdownButton<int>(
                        hint: Text("Available seats"),
                        value: seats,
                        icon: Icon(Icons.airline_seat_recline_normal),
                        items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            .map((int value) {
                          return new DropdownMenuItem<int>(
                            value: value,
                            child: new Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            seats = newVal!;
                            print(seats);
                          });
                        }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: TextFormField(
                      controller: priceEndPointController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter a price in €",
                        icon: Icon(Icons.price_change),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: durationController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter a duration in minutes",
                          icon: Icon(Icons.timer),
                        ),
                      ),
                    ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Add the stop points"),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFieldSearcher(
                        label: "Stop point",
                        apiKey: apiKey,
                        controller: stopPointController,
                        getSelectedValue: (value) {
                          print(value);
                          setPoints(value, selectedStop);
                        },
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: priceStopPointController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter a price in €",
                          icon: Icon(Icons.price_change),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        controller: durationStopController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter a duration in minutes",
                          icon: Icon(Icons.timer),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        child: Text("Add stop point"),
                        onPressed: () async {
                          setState(() {
                            setStopPoint(selectedStop,
                                double.parse(priceStopPointController.text),int.parse(durationStopController.text));
                            stopPointController.clear();
                            priceStopPointController.clear();
                            durationStopController.clear();
                            selectedStop=PointLoc();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Expanded(
                flex: 3,
                child: ListView(children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => StopsCard(
                        deleteItem: (() {
                          setState(() {
                          });
                        }),
                        index: index,
                        address: stopPoints[index].placeName!,
                        price: stopPoints[index].price.toString(),
                        stopPoints: stopPoints, 
                        duration: stopPoints[index].duration.toString(),),
                    shrinkWrap: true,
                    itemCount: stopPoints.length,
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

class StopsCard extends StatefulWidget {
  final String address;
  final String price;
  final int index;
  final List<PointLoc> stopPoints;
  final String duration;
  final Function() deleteItem;
  const StopsCard(
      {Key? key,
      required this.address,
      required this.price,
      required this.index,
      required this.stopPoints, 
      required this.deleteItem, 
      required this.duration})
      : super(key: key);

  @override
  State<StopsCard> createState() => _StopsCardState();
}

class _StopsCardState extends State<StopsCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Card(
          child: ListTile(
        leading: const Icon(Icons.location_on),
        title: Text(widget.address),
        subtitle: Row(
          children: [
            Text(widget.price + " €"),
            Text(widget.duration+" minutes")
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
              widget.stopPoints.removeAt(widget.index);
              widget.deleteItem();
          },
        ),
      )),
    );
  }
}

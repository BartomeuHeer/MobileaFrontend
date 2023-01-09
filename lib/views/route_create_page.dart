import 'package:flutter/material.dart';
import 'package:flutter_app/views/first_page.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:web_date_picker/web_date_picker.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
class RouteCreatePage extends StatefulWidget {
  const RouteCreatePage({Key? key}) : super(key: key);

  @override
  _RouteCreatePageState createState() => _RouteCreatePageState();
}

class _RouteCreatePageState extends State<RouteCreatePage> {
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
              width: 300,
              height: 50,
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
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 600,
                  child: MapBoxPlaceSearchWidget(
                    fontSize: 20,
                    searchHint: "Choose a stop point",
                    popOnSelect: true,
                    apiKey: "sk.eyJ1IjoibmduZWVyMSIsImEiOiJjbGNqZ3FodHEwazNlM29wNjFmaW1rcmFrIn0.APrvt6eV8nNSXDiZoC5-Hg",
                    onSelected: (place) {
                      
                    },
                    context: context,
                  ),
                )
              ],
            )
            
          ],
        ),
      ),
      /* Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Misc"),
        content: Column(
          children: const [
            /* CustomInput(
              hint: "Bio",
              inputBorder: OutlineInputBorder(),
            ), */
          ],
        ),
      ), */
    ];
  }
}
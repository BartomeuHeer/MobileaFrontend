import 'dart:math';
import 'package:flutter_app/models/route.dart';
import 'package:flutter_app/models/userclient.dart';
import 'package:flutter_app/services/routeServices.dart';
import 'package:flutter_app/widgets/drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:localstorage/localstorage.dart';

import 'package:flutter_app/models/language_constants.dart';



class CreateRoute extends StatefulWidget {
  const CreateRoute({super.key});

  @override
  State<CreateRoute> createState() => _CreateRoute();
}

class _CreateRoute extends State<CreateRoute> {
  bool newRoute = false;
  final bool _validate = false;
  final ScrollController adminController = ScrollController();
  final dateController = TextEditingController();
  final startPointController = TextEditingController();
  final endPointController = TextEditingController();
  final stopsController = TextEditingController();
  final priceStopPointController = TextEditingController();
  final destinationPriceController = TextEditingController();
  late UserClient userData;
  final LocalStorage storage = LocalStorage('key');
  UserServices serrvice = UserServices();
  List<String> stopsList = [];
  List<String> pricesList = [];

  void dispose() {
    // Clean up the controller when the widget is disposed.
    dateController.dispose();
    adminController.dispose();
    startPointController.dispose();
    endPointController.dispose();
    stopsController.dispose();
    priceStopPointController.dispose();
    destinationPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> downloadData(UserServices serv) async {
    print(serrvice.storage.getItem('userId'));
    var id = storage.getItem('userId');
    var response = await serrvice.getUserData(id);
    print(response);
    return response;
    // return your response
  }

  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    UserServices userServices = Provider.of<UserServices>(context);
    RouteServices routeServices = Provider.of<RouteServices>(context);
    ScreenUtil.init(context);

    return FutureBuilder(
      future: downloadData(userServices),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text(translation(context).loading_message)); //Falta comprobar
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Scaffold(
                backgroundColor: const Color.fromARGB(195, 159, 191, 198),
                appBar: AppBar(
                  backgroundColor: const Color(0xFF4cbfa6),
                  title: Text( translation(context).routes),
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Card(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(
                                          Icons.route_rounded,
                                          size: 50,
                                        ),
                                        title: Text( translation(context).my_routes ),
                                        subtitle: Text( translation(context).routes )
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.37,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        /* child: ListView(children: [
                                          if (userServices.userData.routes !=
                                              null)
                                            /* ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  LastRoutesCard(
                                                inicio: userServices.userData
                                                    .routes![index].startPoint!,
                                                date: userServices
                                                    .userData
                                                    .routes![index]
                                                    .dateOfBeggining!,
                                                fin: userServices.userData
                                                    .routes![index].endPoint!,
                                              ),
                                              shrinkWrap: true,
                                              itemCount: userServices
                                                  .userData.routes!.length,
                                            ), */
                                        ]), */
                                      ),
                                    ]),
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                            height: MediaQuery.of(context).size.width * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 1.6,
                            child: ListView(
                              controller: adminController,
                              children: [
                                if (!newRoute)
                                  Card(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: <Widget>[
                                          ListTile(
                                            leading: IconButton(
                                              onPressed: () => setState(
                                                  () => newRoute = true),
                                              icon: const Icon(
                                                Icons.add,
                                                size: 28,
                                              ),
                                            ),
                                            title:
                                                Text( translation(context).create_new_route ),
                                            subtitle: 
                                                Text( translation(context).insert_new_route_info),
                                          ),
                                        ]),
                                  ),
                                if (newRoute)
                                  Card(
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                        ListTile(
                                          leading: IconButton(
                                            onPressed: () => setState(
                                                () => newRoute = false),
                                            icon: const Icon(
                                              Icons.add,
                                              size: 28,
                                            ),
                                          ),
                                          title: Text( translation(context).create_new_route ),
                                          subtitle: Text(
                                              translation(context).insert_new_route_info ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.016),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          title: Text( translation(context).from), //Trad
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 5,
                                                                  left: 15,
                                                                  right: 15),
                                                          child: TextField(
                                                            controller:
                                                                startPointController,
                                                            decoration: InputDecoration(
                                                                hintText:
                                                                    translation(context).city, //Trad
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            4))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          title: Text(
                                                              translation(context).destination), //Trad feta
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 5,
                                                                  left: 15,
                                                                  right: 15),
                                                          child: TextField(
                                                            controller:
                                                                endPointController,
                                                            decoration: InputDecoration(
                                                                hintText:
                                                                    translation(context).city, 
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            4))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          title: Text(translation(context).price), //Trad
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 5,
                                                                  left: 15,
                                                                  right: 15),
                                                          child: TextField(
                                                            controller:
                                                                destinationPriceController,
                                                            decoration: InputDecoration(
                                                                hintText: "€",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            4))),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.17,
                                                          child: TextField(
                                                            controller:
                                                                dateController, //editing controller of this TextField
                                                            decoration:
                                                                InputDecoration(
                                                              icon: const Icon(Icons
                                                                  .calendar_today), //icon of text field
                                                              labelText:
                                                                  translation(context).enter_date, //Falta comprobar
                                                              errorText: _validate
                                                                  ? translation(context).empty_value //Falta comprobar
                                                                  : null,
                                                            ),
                                                            readOnly:
                                                                true, // when true user cannot edit text
                                                            onTap: () async {
                                                              DateTime?
                                                                  pickedDate =
                                                                  await showDatePicker(
                                                                      context:
                                                                          context,
                                                                      initialDate:
                                                                          DateTime
                                                                              .now(), //get today's date
                                                                      firstDate:
                                                                          DateTime(
                                                                              2022), //DateTime.now() - not to allow to choose before today.
                                                                      lastDate:
                                                                          DateTime(
                                                                              2100));
                                                              if (pickedDate !=
                                                                  null) {
                                                                String
                                                                    formattedDate =
                                                                    DateFormat(
                                                                            'dd-MM-yyyy')
                                                                        .format(
                                                                            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                                                                setState(() {
                                                                  dateController
                                                                          .text =
                                                                      formattedDate; //set foratted date to TextField value.
                                                                });
                                                              } else {
                                                                logger.e(
                                                                    translation(context).date_not_selected); //Falta trabnsl
                                                              }
                                                            },
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Card(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            ListTile(
                                                              title:
                                                                  Text(translation(context).stops), //Trad
                                                              trailing: Icon(
                                                                  Icons.add),
                                                              onTap: (() {
                                                                setState(() =>
                                                                    stopsList.add(
                                                                        stopsController
                                                                            .text));
                                                                setState(() =>
                                                                    pricesList.add(
                                                                        priceStopPointController
                                                                            .text));
                                                              }),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom: 5,
                                                                      left: 15,
                                                                      right:
                                                                          15),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  TextField(
                                                                    controller:
                                                                        stopsController,
                                                                    decoration: InputDecoration(
                                                                        hintText:
                                                                            translation(context).city, //Trad
                                                                        hintStyle: TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize: ScreenUtil().setSp(4))),
                                                                  ),
                                                                  TextField(
                                                                    controller:
                                                                        priceStopPointController,
                                                                    decoration: InputDecoration(
                                                                        hintText:
                                                                            "€",
                                                                        hintStyle: TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize: ScreenUtil().setSp(4))),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      child:
                                                          ListView(children: [
                                                        ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              StopsCard(
                                                            city: stopsList[
                                                                index],
                                                            price: pricesList[
                                                                index],
                                                          ),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              stopsList.length,
                                                        ),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                ),
                                                Center(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      UserClient part =
                                                          userServices.userData;
                                                      List<UserClient>
                                                          listUser = [];
                                                      listUser.add(part);
                                                      List<String> dateFor =
                                                          dateController.text
                                                              .split('-');

                                                      /*  Route2 nroute = Route2(
                                                          participants:
                                                              listUser,
                                                          startPoint:
                                                              startPointController
                                                                  .text,
                                                          stopPoint: stopsList,
                                                          endPoint:
                                                              endPointController
                                                                  .text,
                                                          dateOfBeggining:
                                                              DateTime.parse(
                                                                  "${dateFor[2]}-${dateFor[1]}-${dateFor[0]}"));
                                                      final Future<
                                                              Map<String,
                                                                  dynamic>>
                                                          successfulMessage =
                                                          routeServices
                                                              .createRoute(
                                                                  nroute, part); */
                                                      /* successfulMessage
                                                          .then((response) {
                                                        if (response[
                                                                'status'] ==
                                                            "200") {
                                                          setState(() => userServices
                                                              .setRouteToUser(
                                                                  response[
                                                                      'data']));
                                                        } else {
                                                          logger.d(
                                                              "Error creating Route: ${response['status']}");
                                                        }
                                                      }); */
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            fixedSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.22,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.1,
                                                            ),
                                                            backgroundColor:
                                                                const Color.fromARGB(
                                                                    162,
                                                                    232,
                                                                    139,
                                                                    77),
                                                            textStyle: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            6),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            elevation: 5,
                                                            shadowColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    162,
                                                                    232,
                                                                    139,
                                                                    77)),
                                                    child: Text(
                                                        translation(context).create_new_route), //Trad
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                            ),
                                          ],
                                        ),
                                      ])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }
        }
      },
    );
  }
}

class LastRoutesCard extends StatelessWidget {
  final String inicio;
  final DateTime date;
  final String fin;

  const LastRoutesCard({
    Key? key,
    required this.inicio,
    required this.date,
    required this.fin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd-MM-yyyy');
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Card(
          child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Color.fromARGB(
              Random().nextInt(255),
              Random().nextInt(255),
              Random().nextInt(255),
              Random().nextInt(255)),
        ),

        //falta aquests texts mirar com fer
        title: Text("$inicio ➜ $fin"), 
        subtitle: Text("Fecha: ${df.format(date)}"), 
        trailing: const Icon(Icons.arrow_forward),
        onTap: (() {
          /*Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),*/
        }),
      )),
    );
  }
}

class StopsCard extends StatelessWidget {
  final String city;
  final String price;

  const StopsCard({
    Key? key,
    required this.city,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Card(
          child: ListTile(
        leading: const Icon(Icons.location_on),
        title: Text(city),
        subtitle: Text(price + " €"),
      )),
    );
  }
}

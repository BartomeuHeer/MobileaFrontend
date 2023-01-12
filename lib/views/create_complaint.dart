import 'dart:math';
import 'package:flutter_app/models/complaint.dart';
import 'package:flutter_app/models/route.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/services/routeServices.dart';
import 'package:flutter_app/widgets/drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:localstorage/localstorage.dart';

class CreateComplaint extends StatefulWidget {
  const CreateComplaint({super.key});

  @override
  State<CreateComplaint> createState() => _CreateComplaint();
}

class _CreateComplaint extends State<CreateComplaint> {
  bool newComplaint = false;
  final bool _validate = false;
  final ScrollController adminController = ScrollController();
  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final commentController = TextEditingController();
  final LocalStorage storage = LocalStorage('key');
  UserServices serrvice = UserServices();
  List<String> categoryList = ["Low","Medium","Grave"];
  String categoryController = "Select one option.";

  void dispose() {
    // Clean up the controller when the widget is disposed.
    dateController.dispose();
    adminController.dispose();
    nameController.dispose();
    commentController.dispose();
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
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Scaffold(
                backgroundColor: const Color.fromARGB(195, 159, 191, 198),
                appBar: AppBar(
                  backgroundColor: const Color(0xFF4cbfa6),
                  title: const Text("Complaints"),
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
                                      const ListTile(
                                        leading: Icon(
                                          Icons.notification_important,
                                          size: 50,
                                        ),
                                        title: Text('MY COMPLAINTS'),
                                        subtitle: Text('Complaints:'),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.37,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: ListView(children: [
                                            ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  ComplaintCard(
                                                name: userServices.listComplaint[index].name!,
                                                date: userServices.listComplaint[index].date!,
                                                category: userServices.listComplaint[index].category!,
                                              ),
                                              shrinkWrap: true,
                                              itemCount: userServices.listComplaint.length,
                                            ),
                                        ]),
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
                                if (!newComplaint)
                                  Card(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: <Widget>[
                                          ListTile(
                                            leading: IconButton(
                                              onPressed: () => setState(
                                                  () => newComplaint = true),
                                              icon: const Icon(
                                                Icons.add,
                                                size: 28,
                                              ),
                                            ),
                                            title:
                                                const Text('CREATE NEW COMPLAINT'),
                                            subtitle: const Text(
                                                'Insert complaint information'),
                                          ),
                                        ]),
                                  ),
                                if (newComplaint)
                                  Card(
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                        ListTile(
                                          leading: IconButton(
                                            onPressed: () => setState(
                                                () => newComplaint = false),
                                            icon: const Icon(
                                              Icons.add,
                                              size: 28,
                                            ),
                                          ),
                                          title: const Text('CREATE NEW COMPLAINT'),
                                          subtitle: const Text(
                                              'Insert complaint information'),
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
                                                        const ListTile(
                                                          title: Text('Infractor'),
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
                                                                nameController,
                                                            decoration: InputDecoration(
                                                                hintText:
                                                                    "Infractor's name",
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
                                                                  "Enter Date",
                                                              errorText: _validate
                                                                  ? 'Value Can\'t Be Empty'
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
                                                                    "Date is not selected");
                                                              }
                                                            },
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: DropdownButton(
                                                    items: categoryList.map((String a){
                                                      return DropdownMenuItem(value: a, child: Text(a));
                                                    }).toList(),
                                                    onChanged: (categoryController2)=>{
                                                      setState(() {
                                                        categoryController=categoryController2!;
                                                      })
                                                    },
                                                    hint: Text(categoryController),
                                                    )
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: Card(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        const ListTile(
                                                          title: Text(
                                                              'Comment'),
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
                                                                commentController,
                                                            decoration: InputDecoration(
                                                                hintText:
                                                                    "Insert your comment",
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
                                                      List<String> dateFor =
                                                          dateController.text
                                                              .split('-');
                                                      Complaint complaint = Complaint(
                                                          name:
                                                              nameController.text,
                                                          comment:
                                                              commentController
                                                                  .text,
                                                          category: categoryController,
                                                          date:
                                                              DateTime.parse(
                                                                  "${dateFor[2]}-${dateFor[1]}-${dateFor[0]}"));
                                                      final Future<
                                                              Map<String,
                                                                  dynamic>>
                                                          successfulMessage =
                                                          userServices
                                                              .createComplaint(
                                                                  complaint);
                                                      successfulMessage
                                                          .then((response) {
                                                        if (response[
                                                                'status'] ==
                                                            "200") {
                                                          setState(() => userServices
                                                              .setComplaint(
                                                                  response[
                                                                      'data']));
                                                        } else {
                                                          logger.d(
                                                              "Error creating the Complaint: ${response['status']}");
                                                        }
                                                      });
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
                                                    child: const Text(
                                                        'CREATE COMPLAINT'),
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

class ComplaintCard extends StatelessWidget {
  final DateTime date;
  final String name;
  final String category;

  const ComplaintCard({
    Key? key,
    required this.date,
    required this.name,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd-MM-yyyy');
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Card(
          child: ListTile(
        leading: CircleAvatar(radius: 28, backgroundColor: setColor(category)),
        title: Text("$name"),
        subtitle: Text("Date: ${df.format(date)} | Category: $category"),
      )),
    );
  }

  Color setColor(String category) {
    if (category == "Low") {
      return Color.fromARGB(255, 65, 250, 3);
    } else if (category == "Medium") {
      return Color.fromARGB(255, 255, 136, 1);
    } else {
      return Color.fromARGB(255, 250, 3, 3);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/models/language_constants.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:flutter_app/views/login_page.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter_app/models/language_constants.dart';

import '../models/userclient.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final dateInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool buttonEnabled = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        translation(context).inc_credentials, // Falta trad
        style: TextStyle(color: Colors.red),
      ),
      content: Text(translation(context).user_already_exists), //Falta trad
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserServices userService = UserServices();

    return Container(
        /* decoration: BoxDecoration(
          /* image: DecorationImage(
              image: AssetImage(
                  'assets/gray-abstract-wireframe-technology-background_53876-101941.webp'),
              fit: BoxFit.cover), */
        ), */
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 35, top: 130),
                  child: Text(
                    translation(context).signup,
                    style: TextStyle(color: Colors.black, fontSize: 45),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 35, right: 35),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return translation(context).invalid_username; //Falta trad
                                      }
                                      return null;
                                    },
                                    controller: usernameController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: translation(context).username,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      String? cositas = validateEmail(value!);
                                      print(cositas);
                                      return cositas;

                                      //return validateEmail(value!);
                                    },
                                    controller: emailController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: translation(context).email,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return translation(context).introduce_password; // Falta comprobar
                                      }
                                      return null;
                                    },
                                    controller: passwordController,
                                    style: TextStyle(),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: translation(context).password,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      String? cositas2 = validatePassword(
                                          passwordController.text, value!);
                                      print(cositas2);
                                      return cositas2;
                                      //return validatePassword(passwordController.text, value!);
                                    },
                                    controller: repeatPasswordController,
                                    style: TextStyle(),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText:
                                            translation(context).repeatpassword,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  //Datepicker
                                  Container(
                                      child: DateTimePicker(
                                    controller: dateInputController,
                                    type: DateTimePickerType.date,
                                    initialValue: null,
                                    dateMask: 'd MMM yyyy',
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    icon: const Icon(Icons.event),
                                    dateLabelText: translation(context).enter_date,  // Ja traduit
                                    onChanged: (val) => print(val),
                                    /* validator: (value) {
                                  return validateAge(value!);
                                
                                }, */
                                    onSaved: (newValue) => print(newValue),
                                  )),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        translation(context).signup,
                                        style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: TextButton(
                                          onPressed: () async {
                                            print(dateInputController.text);
                                            print(passwordController.text);
                                            print(emailController.text);
                                            print(
                                                repeatPasswordController.text);
                                            print(usernameController.text);

                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                buttonEnabled = true;
                                              });
                                              print(usernameController.text +
                                                  passwordController.text);
                                              var newUser = UserClient(
                                                  id: "",
                                                  name: usernameController.text,
                                                  password:
                                                      passwordController.text,
                                                  email: emailController.text,
                                                  admin: false,
                                                  birthday:
                                                      dateInputController.text);
                                              var res = await userService
                                                  .createUser(newUser);
                                              if (res == "400") {
                                                showAlertDialog(context);
                                                return;
                                              }
                                              if (res == "200") {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginPage()));
                                              }
                                            }
                                          },
                                          child: Text(
                                            translation(context).signup,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Aqui va el Flexible(
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  String? validateEmail(String email) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
        .hasMatch(email);

    if (emailValid) {
      return null;
    }

    return translation(context).invalid_email; // Falta comprob
  }

  String? validatePassword(String pass1, String pass2) {
    if ((pass1 == pass2) || (pass1 == "") || (pass2 == "")) {
      return null;
    } else {
      return translation(context).passwords_different;  // Falta comprob
    }
  }

  String validateAge(String value) {
    var dateNow = DateTime.now();
    var underAge = dateNow.subtract(const Duration(days: 6574));
    var userAge = DateTime.parse(value);

    if (userAge.compareTo(underAge) < 0) {
      return "";
    }
    return translation(context).legal_age; // Falta comprob
  }
}

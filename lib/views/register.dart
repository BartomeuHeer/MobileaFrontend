import 'package:flutter/material.dart';
import 'package:flutter_app/models/language_constants.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:flutter_app/views/login_page.dart';


import '../models/user.dart';

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
      title: const Text(
        "Incorrect credentials",
        style: TextStyle(color: Colors.red),
      ),
      content: const Text("User already exists."),
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
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/gray-abstract-wireframe-technology-background_53876-101941.webp'),
              fit: BoxFit.cover),
        ),
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
                          child: Column(
                            children: [
                              TextField(
                                controller: usernameController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: translation(context).username,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: emailController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: translation(context).email,
                                    errorText:
                                        validateEmail(emailController.text),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: passwordController,
                                style: TextStyle(),
                                obscureText: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: translation(context).password,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              TextField(
                                controller: repeatPasswordController,
                                style: TextStyle(),
                                obscureText: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: translation(context).repeatpassword,
                                    errorText: validatePassword(
                                        passwordController.text,
                                        repeatPasswordController.text),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
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
                                        if ((usernameController.text.isNotEmpty) &&
                                            (passwordController
                                                .text.isNotEmpty) &&
                                            (repeatPasswordController
                                                .text.isNotEmpty) &&
                                            (emailController.text.isNotEmpty)) {
                                          setState(() {
                                            buttonEnabled = true;
                                          });
                                          print(usernameController.text +
                                              passwordController.text);
                                          var newUser = User(
                                              id: "",
                                              name: usernameController.text,
                                              password: passwordController.text,
                                              email: emailController.text,
                                              admin: false,
                                              birthday: DateTime.parse("20220101").toString());
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
                                      child:Text(
                                        translation(context).signup,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  String validateEmail(String value) {
    bool found = false;
    if (value != "") {
      for (int character in value.codeUnits) {
        if (character == "@") {
          found = true;
        }
      }
      if (found == true) {
        return "";
      } else {
        return "It must be an email.";
      }
    } else {
      return "";
    }
  }

  String validatePassword(String pass1, String pass2) {
    if ((pass1 == pass2) || (pass1 == "") || (pass2 == "")) {
      return "";
    } else {
      return "The passwords don't coincide.";
    }
  }
}

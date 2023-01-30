import 'package:flutter/material.dart';
import 'package:flutter_app/models/language_constants.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:flutter_app/utils/authentication.dart';
import 'package:flutter_app/views/first_page.dart';
//import 'package:flutter_app/views/route_list_page.dart';
import 'package:flutter_app/views/register.dart';
import 'package:flutter_app/widgets/google_sign_in_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/models/userclient.dart';
//import 'package:flutter_app/views/first_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool buttonEnabled = false;
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
      title: Text(translation(context).inc_credentials,
          style: TextStyle(color: Colors.red)),
      content: Text(translation(context).user_not_found),
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
    UserServices userServicesProvider = Provider.of<UserServices>(context);

    /* decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                'assets/gray-abstract-wireframe-technology-background_53876-101941.webp'),
            fit: BoxFit.cover),
      ), */
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 35, top: 130),
            child: Text(
              translation(context).welcomeBack,
              style: TextStyle(color: Colors.black, fontSize: 45),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 360),
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
                              hintText:
                                  translation(context).email, //tradducio feta,
                              icon: Icon(Icons.mail),
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
                              hintText: translation(context)
                                  .password, //traduccio feta
                              icon: Icon(Icons.password),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translation(context).signin,
                              style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w700),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () async {
                                  if ((usernameController.text.isNotEmpty) &&
                                      (passwordController.text.isNotEmpty)) {
                                    setState(() {
                                      buttonEnabled = true;
                                    });
                                    print(usernameController.text +
                                        passwordController.text);
                                    final Map<String, dynamic> res =
                                        await userService.logIn(
                                            usernameController.text,
                                            passwordController.text);
                                    print(res['status']);
                                    if (res['status'] == "401") {
                                      showAlertDialog(context);
                                      return;
                                    }
                                    if (res['status'] == 200) {
                                      print("navega fill de putaa");
                                      /* SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          "name", usernameController.text);
                                      userServicesProvider
                                          .setUserData(res['data']); */
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FirstPage(),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  translation(context).signin,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage()));
                              },
                              child: Text(
                                translation(context).signup,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff4c505b),
                                    fontSize: 18),
                              ),
                              style: ButtonStyle(),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                translation(context).forgotpass,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xff4c505b),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: Authentication.initializeFirebase(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error initializing Firebase');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return GoogleSignInButton();
                      }
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF4cbfa6),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

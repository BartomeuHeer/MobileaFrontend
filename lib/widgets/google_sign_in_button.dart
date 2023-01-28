import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/language_constants.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:flutter_app/utils/authentication.dart';
import 'package:flutter_app/views/first_page.dart';
import 'package:provider/provider.dart';
import '../models/userclient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                print("r111111111111111111111");

                User? usergog =
                    await Authentication.signInWithGoogle(context: context);
                print("r22222222222222222222222");
                var newUser = UserClient(
                    id: "",
                    name: usergog?.displayName,
                    password: "aaaaaaaaaaaaaaaaaaaaaaaa",
                    email: usergog?.email,
                    admin: false);
                print("3333333333333333333333333");
                print("390909090909098765456547");
                var res =
                    await userService.logIn(newUser.email!, newUser.password!);
                print("000000000000000000");
                if (res['status'] == 400) {
                  print("444444444444444444444");
                  var res = await userService.createUser(newUser);
                  if (res == "400") {
                    showAlertDialog(context);
                    return;
                  }
                  if (res == "200") {
                    print("reegisttterr");
                    var res = await userService.logIn(
                        newUser.email!, newUser.password!);

                    if (res['status'] == "200") {
                      print("5555555555555555555555");
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("name", newUser.id!);
                      userServicesProvider.setUserData(res['data']);
                      print("looggggiiiinn");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FirstPage(),
                        ),
                      );
                    }
                  }
                  return;
                }
                if (res['status'] == "200") {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("name", newUser.id!);
                  userServicesProvider.setUserData(res['data']);
                  print("looggggiiiinn");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FirstPage(),
                    ),
                  );
                }

                setState(() {
                  _isSigningIn = false;
                });

                if (usergog != null) {
                  // var newUser = User(
                  //     id: "",
                  //     name: usergog.displayName,
                  //     password: '$usergog.email$usergog.phoneNumber',
                  //     email: usergog.email,
                  //     admin: false);
                  // final Map<String, dynamic> res =
                  //     await userService.logIn(newUser.id!, newUser.password!);
                  // if (res['status'] == "404") {
                  //   var res = await userService.createUser(newUser);
                  //   if (res == "404") {
                  //     showAlertDialog(context);
                  //     return;
                  //   }
                  //   if (res == "200") {
                  //     print("reegisttterr");
                  //     var res = await userService.logIn(
                  //         newUser.id!, newUser.password!);
                  //     if (res['status'] == "200") {
                  //       SharedPreferences prefs =
                  //           await SharedPreferences.getInstance();
                  //       prefs.setString("name", newUser.id!);
                  //       userServicesProvider.setUserData(res['data']);
                  //       print("looggggiiiinn");
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (context) => const FirstPage(),
                  //         ),
                  //       );
                  //     }
                  //   }
                  //   return;
                  // }
                  // if (res['status'] == "200") {
                  //   SharedPreferences prefs =
                  //       await SharedPreferences.getInstance();
                  //   prefs.setString("name", newUser.id!);
                  //   userServicesProvider.setUserData(res['data']);
                  //   print("looggggiiiinn");
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) => const FirstPage(),
                  //     ),
                  //   );
                  // }

                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

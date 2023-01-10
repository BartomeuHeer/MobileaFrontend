import 'package:flutter/material.dart';
import 'package:flutter_app/models/msg.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/services/routeServices.dart';
/* import 'package:flutter_app/views/my_profile.dart';
import 'package:flutter_app/views/result_routes.dart';
import 'package:flutter_app/views/route_list_page.dart'; */
import '../models/route.dart';
import '../widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  IO.Socket? socket;
  List<MsgModel> listMsg = [];

  TextEditingController _msgController = TextEditingController();
  @override
  void initState() {
    super.initState();

    print("abans connect");
    connect();
    print("DESP connect");
  }

  void connect() {
    print("CONNECT!!!!");
    /*socket = IO.io("http://localhost:3000", <String, dynamic>{
      "transports": ["websockets"],
      "autoConnect": false,
    });*/
    IO.Socket socket = IO.io('http://localhost:3000');
    print("22222CONNECT!!!!");

    socket.connect();
    socket.onConnect((_) {
      print("onConnect!!!!!");
      socket.emit('sendMsg',
          {"type": "ownMsg", "msg": "Hello", "senderName": "HATIM!"});

      socket.on("sendMsgServer", (msg) {
        print("REBEM un missatge ");
        listMsg.add(MsgModel(
            msg: msg["msg"], type: msg["type"], sender: msg["senderNmae"]));
      });
    });
  }

  void sendMsg(String msg, Function name) {
    MsgModel ownMsg =
        MsgModel(msg: msg, type: "ownMsg", sender: loadPreferences());
    listMsg.add(ownMsg);
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "senderName": loadPreferences(),
    });
  }

  // static SharedPreferences _preferences;
  // static Future init() async =>
  //     _preferences = await SharedPreferences.getInstance();
  // static String getUsername() => _preferences.getString("name");
  loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4cbfa6),
        title: const Text("Route chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: "Type here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                      // suffixIcon: IconButton(
                      //   onPressed: () {
                      //     String msg = _msgController.text;
                      //     if (msg.isNotEmpty) {
                      //       sendMsg(msg, loadPreferences());
                      //       _msgController.clear();
                      //     }
                      //   },
                      //   icon: const Icon(
                      //     Icons.send,
                      //     color: Color(0xFF4cbfa6),
                      //     size: 26,
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

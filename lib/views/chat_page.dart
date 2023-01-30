import 'package:flutter/material.dart';
import 'package:flutter_app/models/msg.dart';
import 'package:flutter_app/models/userclient.dart';
import 'package:flutter_app/services/routeServices.dart';
import 'package:flutter_app/services/userServices.dart';
import 'package:flutter_app/widgets/other_msg.dart';
import 'package:flutter_app/widgets/own_msg.dart';
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
  UserServices serrvice = UserServices();
  RouteServices routeserv = RouteServices();
  TextEditingController _msgController = TextEditingController();
  @override
  void initState() {
    super.initState();

    print("abans connect");
    connect();
    print("DESP connect");
  }

  void connect() {
    //String routeId = serrvice.storage.getItem('routeId');
    print("CONNECT!!!!");
    // socket = IO.io("http://localhost:3000", <String, dynamic>{
    //   "transports": ["websockets"],
    //   "autoConnect": false,
    // });
    IO.Socket socket = IO.io('http://localhost:3000');
    print("22222CONNECT!!!!");

    socket.connect();
    socket.onConnect((_) {
      //socket.emit('room', routeId);
      print("onConnect!!!!!");
      socket.on("sendMsgServer", (msg) {
        print("REBEM un missatge ");
        setState(() {
          listMsg.add(
            MsgModel(
                msg: msg["msg"],
                type: msg["type"],
                senderName: msg["senderName"]),
          );
        });
      });
    });
  }

  void sendMsg(String msg, String senderName) {
    String senderName = serrvice.storage.getItem('name');
    MsgModel ownMsg =
        MsgModel(msg: msg, type: "ownMsg", senderName: senderName);
    listMsg.add(ownMsg);
    setState(() {
      listMsg;
    });
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "senderName": senderName,
    });
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
            child: ListView.builder(
                itemCount: listMsg.length,
                itemBuilder: (context, index) {
                  if (listMsg[index].type == "ownMsg") {
                    return OwnMsgWidget(
                        msg: listMsg[index].msg,
                        sender: listMsg[index].senderName);
                  } else {
                    return OtherMsgWidget(
                        msg: listMsg[index].msg,
                        sender: listMsg[index].senderName);
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: "Type here ...",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          print(_msgController.text);
                          print("999999999999999999");
                          print(serrvice.storage.getItem('id'));
                          print("0000000000001");
                          String msg = _msgController.text;
                          print("11111111111");
                          String senderName = serrvice.storage.getItem('name');
                          print("22222222222222222222");
                          print(senderName);
                          if (msg.isNotEmpty) {
                            sendMsg(msg, senderName);
                            print("3333333333333333333");
                            _msgController.clear();
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xFF4cbfa6),
                          size: 26,
                        ),
                      ),
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

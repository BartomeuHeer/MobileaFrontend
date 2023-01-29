import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter_app/widgets/chat_messages.dart';

import '../widgets/drawer.dart';
import 'package:flutter_app/models/language_constants.dart';


class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _msgController = TextEditingController();

  late DialogFlowtter dialogFlowtter;

  List<Map<String, dynamic>> messages = [];

  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }

  void sendMessage(String msg) async {
    if (msg.isEmpty) {
      return;
    }

    setState(() {
      addMessage(Message(text: DialogText(text: [msg])), true);
    });

    DialogAuthCredentials credentials =
        await DialogAuthCredentials.fromFile("dialog_flow_auth.json");
    print(credentials);
    dialogFlowtter = DialogFlowtter(credentials: credentials);

    QueryInput query =
        QueryInput(text: TextInput(text: msg, languageCode: "en"));
    print(query);
    DetectIntentResponse res = await dialogFlowtter.detectIntent(
      queryInput: query,
    );

    print(res.text);

    if (res.message == null) {
      return;
    }

    setState(() {
      addMessage(res.message!);
    });
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* drawer: DrawerScreen(), */
      appBar: AppBar(
        title: Text(translation(context).chat_bot), //Falta trans
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(messages: messages),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: translation(context).type_here, // Falta trans
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          sendMessage(_msgController.text);
                          _msgController.clear();
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

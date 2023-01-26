import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class ChatMessages extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  const ChatMessages({
    super.key,
    this.messages = const []
    });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: messages.length,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),

      separatorBuilder: (_, i) => const SizedBox(height: 10),

      itemBuilder: (context,i){
        var obj = messages[messages.length - 1 - i];
        return _MessagesContainer(
          
          /// Obtenemos el mensaje del objecto actual
          msg: obj['message'],
          
          /// Diferenciamos si es un mensaje o una respuesta
          isUserMsg: obj['isUserMessage']);
      },
      reverse: true,
    );
  }
}

class _MessagesContainer extends StatelessWidget {
  final Message msg;
  final bool isUserMsg;
  const _MessagesContainer({
    super.key,
    required this.msg,
    this.isUserMsg = false,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isUserMsg ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Container(
            decoration: BoxDecoration(
              color: isUserMsg ? Colors.lightGreen : Colors.lightBlue,
              borderRadius: BorderRadius.circular(20)
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              msg.text?.text?[0] ?? '',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
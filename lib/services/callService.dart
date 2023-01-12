import 'dart:convert';
import 'package:flutter_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class VideocallService{
  static Future <String> getAgoraToken (String channelName) async {
  var baseUrl = apiURL + "/api/call/";
    var res = await http.get(Uri.parse(baseUrl + channelName),
      headers: {'content-type': 'application/json', 'authorization': LocalStorage('key').getItem('token')});
    Object data = jsonDecode(res.body);
    return AgoraToken.fromJson(await jsonDecode(res.body)).tokenValue;
    }
}

class AgoraToken {
  final String tokenValue;

  const AgoraToken({
    required this.tokenValue,
  });

  factory AgoraToken.fromJson(Map<String, dynamic> json) {
    return AgoraToken(
      tokenValue: json['rtcToken'] as String,
    );
  }
 
 @override
  String toString() {
    return tokenValue;
  }
}
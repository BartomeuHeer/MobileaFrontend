import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_app/views/first_page.dart';
import 'package:http/http.dart' as http;
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/agoraSettings.dart';
import '../services/callService.dart';
import 'package:flutter_app/models/language_constants.dart';



class CallPage extends StatefulWidget {
  final String? channel;
  final ClientRole? role;
  const CallPage({Key? key, this.channel, this.role}) : super(key: key);
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  int? _remoteUid;
  late RtcEngine _engine;
  bool isJoined = false, switchCamera = true, openMicrophone = true;
  bool _isRenderSurfaceView = false;
  late String token;
  
  late TextEditingController _controller;
  
  Future<void> getToken() async {
    print(widget.channel);
    String response = await VideocallService.getAgoraToken(widget.channel!);
    if (response != 'Failed to fetch the token')  {
      setState(() {
        token = response;
        print(token);
      });
    } else {
      print(response);
    }
  }

  Future<void> initAgora() async {
    await getToken();
    _engine = await RtcEngine.create(APP_ID);
    print(token);
    await _engine.enableWebSdkInteroperability(true);
    await _engine.enableAudio();
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);

    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("User $uid joined");
          setState(() {
            isJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("User $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("User $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(token, widget.channel!, null, 0);
  }

//FUNCTIONS

//initialization of the agora
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.channel);
    print(widget.channel);
    initAgora();
  }
//disposal of the widget and destroy the engine 
  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }
  
//used to leave the channel
  _leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      isJoined = false;
      openMicrophone = true;
    });
  }
//used to switch the cammeras
  _switchCamera() async {
    if (!switchCamera) _engine.enableLocalVideo(false);
    else _engine.enableLocalVideo(true);

    setState(() {
        switchCamera = !switchCamera;
      });
  }
//used to switch the mic on and off
  _switchMicrophone() async {
    if (!openMicrophone) _engine.enableLocalAudio(false);
    else _engine.enableLocalAudio(true);
    setState(() {
      openMicrophone = !openMicrophone;
    });
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).videocall), // Feta trad
      ),
      body: Stack(
        children: [
          Center(
             child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 150,
              child: Center(
                child: isJoined
                    ? RtcLocalView.SurfaceView()
                    : CircularProgressIndicator(),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Align(
              alignment: Alignment(0.5, 0.8),
              child: SizedBox(
                height: 50,
                width: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white),
                    onPressed: _switchMicrophone,
                    child: const Icon(Icons.mic_none_outlined,
                      color: Colors.black,
                     size: 20)),
              ),
            ),
            SizedBox(width: 50), // give it width
            Align(
              alignment: Alignment(0.5, 0.8),
              child: SizedBox(
                height: 50,
                width: 50,
                child: FloatingActionButton(
                  tooltip: translation(context).hang_call, //Feta trad
                    heroTag: null,
                    backgroundColor: Colors.red,
                    onPressed: () {
                      _leaveChannel();
                      final route = MaterialPageRoute(
                          builder: (context) => FirstPage());
                      Navigator.push(context, route);
                    },
                    mini: true,
                    child: const Icon(Icons.phone_disabled_outlined, size: 20)),
              ),
            ),
            SizedBox(width: 50),
            Align(
              alignment: Alignment(0.5, 0.8),
              child: SizedBox(
                height: 50,
                width: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: _switchCamera,
                    child: const Icon(Icons.video_camera_front_outlined,
                        color: Colors.black,
                        size: 20)),
              ),
            ),
          ])
        ],
      ),
    );
  }

 Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: widget.channel!,
      );
    } else {
      return Text(
        translation(context).waiting_user, //Feta trad
        textAlign: TextAlign.center,
      );
    }
  }
}
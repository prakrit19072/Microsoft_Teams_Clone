import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// this creates a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// checks if textfield channel has an error
  bool _validateError = false;

  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // this disposes the input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // this is the main widget, which will be contructing whole of our starting screen screen

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/img-bck.jpg"), fit: BoxFit.cover),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              ' MS Teams Clone, Developed with 💚 by Prakrit Pathak! ', // this is the heading of the application, which will be shown in appbar
              style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 0
                    ..color = Colors.yellow),
            ),
          ),
          backgroundColor: Colors
              .transparent, // since we have given a custom background photo, so bground color will be kept transparent
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 400,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // a collection of things which will define a row
                      Expanded(
                          child: TextField(
                        controller: _channelController,
                        decoration: InputDecoration(
                          errorText:
                              _validateError // validates if the channel name is correct or not
                                  ? 'You missed the Channel name :('
                                  : null,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 5, color: Colors.red),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(3, 7),
                            ),
                          ),
                          hintText: 'Enter the Channel name :)',
                        ),
                      ))
                    ],
                  ),

                  // we can choose between 2 roles, broadcaster or audience.

                  Column(
                    // this is the boradcaster role
                    children: [
                      ListTile(
                        title: Text(
                          ClientRole.Broadcaster.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              foreground: Paint()
                                ..style = PaintingStyle.fill
                                ..strokeWidth = 0
                                ..color = Colors.redAccent),
                        ),
                        leading: Radio(
                          value: ClientRole.Broadcaster,
                          groupValue: _role,
                          onChanged: (ClientRole? value) {
                            setState(() {
                              _role = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        // this is the audience role
                        title: Text(
                          ClientRole.Audience.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              foreground: Paint()
                                ..style = PaintingStyle.fill
                                ..strokeWidth = 0
                                ..color = Colors.redAccent),
                        ),
                        leading: Radio(
                          value: ClientRole.Audience,
                          groupValue: _role,
                          onChanged: (ClientRole? value) {
                            setState(() {
                              _role = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      // this defines the Join button, which will be used to join the meeting

                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onJoin,
                            child: Text('Join'),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.redAccent),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  // this function basically does input validation, weather a channel actually exists or not.

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

// we need to give permissions to camera and mic to work. This function does just that.
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

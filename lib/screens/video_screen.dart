import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';

class VideoScreen extends StatefulWidget {

  final String id;

  VideoScreen({this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  //var _stops = [10,20,30];

  //YoutubePlayer _youtubePlayer;

  //_stopVideo(Timer t){
  //  print("--------");
  //  print(t.tick);
  //  _controller.pause();
  //}

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  _stopPlay(){
    _controller.cue(widget.id,startAt:10,endAt:15);
  }
  @override
  Widget build(BuildContext context) {
    //const oneSec = const Duration(seconds:10);
    //var timer = new Timer.periodic(oneSec, _stopVideo);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              _isPlayerReady = true;
              print('Player is ready.');
            },
          ),
          RaisedButton(child: Text("Rock & Roll"),
            onPressed: _stopPlay,
            color: Colors.red,
            textColor: Colors.yellow,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            splashColor: Colors.grey,
          )
        ],
      )
    );
  }
}
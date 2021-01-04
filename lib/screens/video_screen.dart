import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/models/question_model.dart';
import 'package:youtube1/models/shared_preferences.dart';

class VideoScreen extends StatefulWidget {

  final Video video;

  VideoScreen(this.video);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  Video _video = Video();
  YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  var timeline = List<int>();
  var nextTimeSpanToStop = 0;
  var timelinePosition = 0;
  //var _stops = [10,20,30];

  //YoutubePlayer _youtubePlayer;

  _stopVideo(){
    print("-------------========================-----------------");
    timelinePosition++;
    print(timeline);
    print(timelinePosition);
    if(timeline.length > timelinePosition){
      print("Trying to pause...");
      _controller.pause();
      nextTimeSpanToStop = timeline[timelinePosition] - timeline[timelinePosition - 1];
      print(nextTimeSpanToStop);
    }
    else if(timeline.length == timelinePosition){
      _controller.pause();
    }
    print("-------------========================-----------------");
  }

  @override
  void initState() {
    super.initState();
    _video = widget.video;
    widget.video.questions.forEach((key, value) {timeline.add(key); print(value);});
    timeline.sort();
    if(timeline.length > 0){
      nextTimeSpanToStop = timeline[0];
    }

    print("------------------->");
    print(timeline);
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.youtubeId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        hideControls: true,
        hideThumbnail: true,
      ),
    );
  }

  _clickedOnAnswer(int questionId, int answerId){
    var useremail = sharedPrefs.useremail;
    APIService.instance
        .postQuestionResponse(useremail,questionId, answerId);
    _controller.play();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var buttonWidget = List<Widget>();
    Question question = _video.questions[timeline[timelinePosition]];
    print("==============>");
    print(question);
    for (var answer in question.answers) {
      buttonWidget.add(
        RaisedButton(child: Text(answer['statement']),
        onPressed: () => _clickedOnAnswer(question.id, answer['id']),
        color: Colors.red,
        textColor: Colors.yellow,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        splashColor: Colors.grey,
      ));
    }

    var oneSec = Duration(seconds:nextTimeSpanToStop);
    var timer = new Timer(oneSec, _stopVideo);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _video.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
            ],
            onReady: () {
              _isPlayerReady = true;
              print('Player is ready.');
            },
          ),
          Container(
            child: Text(
              question.statement,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttonWidget,
          ),
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/models/question_model.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';

class VideoScreen extends StatefulWidget {

  final Video video;

  VideoScreen(this.video);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}
enum VideoState {
  NONE,
  STARTED,
  SHOWING_ANSWERS,
  WAITING_ON_ANSWER,
  QUESTION_ANSWERED
}

class _VideoScreenState extends State<VideoScreen> {
  Video _video = Video();
  YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  Question _currentQuestion;
  int _currentQuestionIndex = 0;
  int _numQuestions = 0;
  bool _showVideoQuestion = false;
  VideoState _state = VideoState.NONE;
  var _answersWidget = List<Widget>();
  var _answersWidgetOpacity = Map<int,bool>();

  @override
  void initState() {
    super.initState();
    _video = widget.video;
    _currentQuestion = widget.video.questions[_currentQuestionIndex];
    _numQuestions = widget.video.questions.length;

    for (var answer in _currentQuestion.answers) {
      _answersWidgetOpacity[answer['id']] = true;
    }

    // Call _videoControl every second to control the video flow
    var numSecs = Duration(seconds:1);
    var timer = new Timer.periodic(numSecs, (Timer t) => _videoControl(t));

    _controller = YoutubePlayerController(
      initialVideoId: widget.video.youtubeId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        hideControls: true,
        hideThumbnail: true,
        startAt: _currentQuestion.timeToStart,
      ),
    );
  }

  _clickedOnAnswer(int questionId, int answerId){
    var useremail = sharedPrefs.useremail;

    // Hide the answers not picked by the user
    _answersWidgetOpacity.forEach((key, value) {
      if(answerId != key){
        _answersWidgetOpacity[key] = false;
      }
    });

    APIService.instance
        .postQuestionResponse(useremail,questionId, answerId);
    _state = VideoState.QUESTION_ANSWERED;
    setState(() {

    });
    _controller.play();
  }

  _videoControl(Timer t){
    if(_state == VideoState.NONE){
      return;
    }

    print(_controller.value.position.inSeconds);
    var currentSecond = _controller.value.position.inSeconds;

    if(_state == VideoState.STARTED && currentSecond == _currentQuestion.timeToShow){
      print("------------------------------>Time to show: ${_currentQuestion.timeToShow}");
      _showVideoQuestion = true;
      _state = VideoState.SHOWING_ANSWERS;
      setState(() {});
    }

    // TODO: Only get here if it's playing the video
    if(_state == VideoState.SHOWING_ANSWERS && currentSecond == _currentQuestion.timeToStop){
      print(_controller.value.playerState);
      print("------------------------------>Time to stop: ${_currentQuestion.timeToStop}");
      _state = VideoState.WAITING_ON_ANSWER;
      _controller.pause();
    }

    if(currentSecond == _currentQuestion.timeToEnd){
      // TODO: increase the number of points based on the user action
      print("------------------------------>Time to end: ${_currentQuestion.timeToEnd}");
      _currentQuestionIndex++;
      if(_numQuestions > _currentQuestionIndex){
        _currentQuestion = widget.video.questions[_currentQuestionIndex];
        Duration nextQuestionStart = Duration(seconds:_currentQuestion.timeToStart);
        _state = VideoState.STARTED;
        _showVideoQuestion = false;
        for (var answer in _currentQuestion.answers) {
          _answersWidgetOpacity[answer['id']] = true;
        }
        setState(() {});
        _controller.seekTo(nextQuestionStart);
      }
      else{
        // TODO: In this case the video has no more questions. The app should return or show another video
        print("Video finished");
        _state = VideoState.NONE;
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    var questionAnswers = List<Widget>();
    _answersWidget = List<Widget>();

    // Create the answers question if there are any left
    if(_showVideoQuestion && _numQuestions > _currentQuestionIndex) {
      for (var answer in _currentQuestion.answers) {
        _answersWidget.add(
          AnimatedOpacity(
              opacity: _answersWidgetOpacity[answer['id']]  ? 1.0 : 0.0, //
              duration: Duration(milliseconds: 500),
              child: PrimaryButton(
                title: answer['statement'],
                onPressed: () => _clickedOnAnswer(_currentQuestion.id, answer['id']),
              )
          )
        );
      }

      questionAnswers.add(
          Container(
            padding: EdgeInsets.only(top: 30,bottom: 30),
            child: Text(
              _currentQuestion.statement,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
      );
      questionAnswers.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _answersWidget,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.,
        children: [
        Container(
          height: 50,
          padding: const EdgeInsets.all(15.0),
          child: Text(
            _video.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
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
            _state = VideoState.STARTED;
            print('Player is ready.');
          },
        ),
          ...questionAnswers,
        ],
      )
    );
  }
}
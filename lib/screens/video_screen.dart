import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/models/question_model.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/widget/appDrawer.dart';

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
  QUESTION_ANSWERED,
  QUESTION_SUMMARY
}

class _VideoScreenState extends State<VideoScreen> {
  Video _video = Video();
  YoutubePlayerController _controller;
  bool _isPlayerReady ;
  YoutubePlayer _youtubePlayerWidget;
  int _selectedAnswerId;  // It holds the answer selected by the user for the current question
  Question _currentQuestion;
  int _currentQuestionIndex;
  int _numQuestions;
  bool _showQuestionAnswers;
  bool _showVideoQuestion;
  VideoState _state;
  var _answersWidget;
  var _answersWidgetOpacity;
  var _questionAnswers;
  Timer _timer;
  final GlobalKey<CustomAppBarState> customBarStateKey = GlobalKey<CustomAppBarState>();

  _initPage(Video video){
    _video = video;
    print("--------------> Video ID: ${video.youtubeId}");
    _isPlayerReady = false;
    _selectedAnswerId = -1;  // It holds the answer selected by the user for the current question
    _currentQuestionIndex = 0;
    _numQuestions = 0;
    _showQuestionAnswers = false;
    _showVideoQuestion = false;
    _state = VideoState.NONE;
    _answersWidget = List<Widget>();
    _answersWidgetOpacity = Map<int,bool>();
    _questionAnswers = List<Widget>();


    _currentQuestion = _video.questions[_currentQuestionIndex];
    _numQuestions = _video.questions.length;

    for (var answer in _currentQuestion.answers) {
      _answersWidgetOpacity[answer['id']] = true;
    }

    // Call _videoControl every second to control the video flow
    var numSecs = Duration(seconds:1);
    _timer = new Timer.periodic(numSecs, (Timer t) => _videoControl(t));

    print("_currentQuestion.timeToStart ${_currentQuestion.timeToStart}");
  }

  _loadVideo(){
    //createTest(video.youtubeId);
    _controller = YoutubePlayerController(
      initialVideoId: _video.youtubeId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        hideControls: true,
        hideThumbnail: true,
        startAt: _currentQuestion.timeToStart,
      ),
    );

    _createYoutubePlayer();
  }


  @override
  void initState() {
    super.initState();
    _initPage(widget.video);
    _loadVideo();
  }

  _prepareForNextQuestion(){
    _currentQuestionIndex++;
    _selectedAnswerId = -1;
    print("---------------:: _numQuestions: $_numQuestions _currentQuestionIndex: $_currentQuestionIndex");
    if(_numQuestions > _currentQuestionIndex){
      _currentQuestion = _video.questions[_currentQuestionIndex];
      Duration nextQuestionStart = Duration(seconds:_currentQuestion.timeToStart);
      _state = VideoState.STARTED;
      _showQuestionAnswers = false;
      _showVideoQuestion = false;
      for (var answer in _currentQuestion.answers) {
        _answersWidgetOpacity[answer['id']] = true;
      }
      setState(() {});
      _controller.seekTo(nextQuestionStart);
    }
    else{
      // TODO: In this case the video has no more questions. The app should return or show another video
      APIService.instance.fetchRandomVideo().then((video){
        print("---------------------------> Trying to change to a new videooooooooooooooooooooooooooooo");
        _timer.cancel();
        _initPage(video);
        setState(() {});
        _controller.load(video.youtubeId, startAt: _currentQuestion.timeToStart);
        _state = VideoState.STARTED;
      });
    }
  }

  _clickedOnAnswer(int questionId, int answerId){
    _selectedAnswerId = answerId;
    var useremail = sharedPrefs.useremail;
    // Hide the answers not picked by the user
    _answersWidgetOpacity.forEach((key, value) {
      if(answerId != key){
        _answersWidgetOpacity[key] = false;
      }
    });

    _controller.play();
    _state = VideoState.QUESTION_ANSWERED;

    var userScore = APIService.instance
        .postQuestionResponse(useremail,questionId, answerId).then((userScore){
              print('-------- Updating points');
              sharedPrefs.userscore = userScore;
              setState(() {});
              //customBarStateKey.currentState.setUserPoints(userScore);
    });

  }

  _videoControl(Timer t){
    print("--------------------=> ${DateTime.now().second}");

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

    if(_state == VideoState.SHOWING_ANSWERS && currentSecond == _currentQuestion.timeToStop){
      print(_controller.value.playerState);
      print("------------------------------>Time to stop: ${_currentQuestion.timeToStop}");
      _showQuestionAnswers = true;
      _state = VideoState.WAITING_ON_ANSWER;
      _controller.pause();
      setState(() {});
    }

    if(_state == VideoState.QUESTION_ANSWERED && currentSecond == _currentQuestion.timeToEnd){
      print("------------------------------>Time to end: ${_currentQuestion.timeToEnd}");
      _controller.pause();
      for (var answer in _currentQuestion.answers) {
        _answersWidgetOpacity[answer['id']] = false;
      }
      _state = VideoState.QUESTION_SUMMARY;
      setState(() {});
    }
  }

  _createAnswerQuestionsWidget(){
    _questionAnswers = List<Widget>();
    _answersWidget = List<Widget>();
    if(_showVideoQuestion) {
      // Create the answers question if there are any left
      if (_showQuestionAnswers && _numQuestions > _currentQuestionIndex) {
        for (var answer in _currentQuestion.answers) {
          _answersWidget.add(
              Center(
                child:
                  AnimatedOpacity(
                  opacity: _answersWidgetOpacity[answer['id']] ? 1.0 : 0.0, //
                  duration: Duration(milliseconds: 500),
                  child: Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: RaisedButton(
                        child: Text(
                            answer['statement'],
                        ),
                        onPressed: () =>
                            _clickedOnAnswer(_currentQuestion.id, answer['id']),
                      )
                  )
              )
              )
          );
        }
      }

      _questionAnswers.add(
          Container(
            padding: EdgeInsets.only(bottom: 50, top:30,left: 10,right: 10)  ,//.all(10),//.only(top: 30, bottom: 30),
              child: Text(
                _currentQuestion.statement,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
          )
      );

      var answersSectionWidget = List<Widget>();
      bool answerIsCorrect = _currentQuestion.officialAnswerId == _selectedAnswerId;
      answersSectionWidget.add(
        Center(
          child: AnimatedOpacity(
              opacity: _state == VideoState.QUESTION_SUMMARY ? 1.0 : 0.0,
              duration: Duration(milliseconds: 1000),
              onEnd: () { _prepareForNextQuestion();},
              child: Container(
                decoration: BoxDecoration(
                  color: answerIsCorrect ? Colors.green : Colors.red,
                ),
                child: Text(
                  answerIsCorrect ? 'Correct!' : 'Nope',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        )
      );

      answersSectionWidget.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _answersWidget,
          )
      );

      _questionAnswers.add(
          Stack(
            children: answersSectionWidget
          )
      );
    }
  }

  _createYoutubePlayer(){
    _youtubePlayerWidget = YoutubePlayer(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    _createAnswerQuestionsWidget();
    print("--------------------------------------------------> Rendering the page");
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar(key: customBarStateKey,title: 'Videos'),
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
        _youtubePlayerWidget,
          ..._questionAnswers,
          //..._test,
        ],
      )
    );
  }
}
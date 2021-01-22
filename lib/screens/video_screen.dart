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
//import 'package:flutter_countdown_timer/countdown.dart';
//import 'package:flutter_countdown_timer/countdown_controller.dart';
//import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
//import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';

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
  YoutubePlayerBuilder _youtubePlayerWidget;
  int _selectedAnswerId;  // It holds the answer selected by the user for the current question
  Question _currentQuestion;
  int _currentQuestionIndex;
  int _numQuestions;
  VideoState _state;
  var _answersWidget;
  var _answersWidgetOpacity;
  var _questionAnswers;
  Timer _timer;
  final GlobalKey<CustomAppBarState> customBarStateKey = GlobalKey<CustomAppBarState>();
  ThemeData _theme;
  Orientation _currentOrientation;

  _initPage(Video video){
    _video = video;
    print("--------------> Video ID: ${video.youtubeId}");
    _isPlayerReady = false;
    _selectedAnswerId = -1;  // It holds the answer selected by the user for the current question
    _currentQuestionIndex = 0;
    _numQuestions = 0;
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
      for (var answer in _currentQuestion.answers) {
        _answersWidgetOpacity[answer['id']] = true;
      }
      setState(() {});
      _controller.seekTo(nextQuestionStart);
    }
    else{
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
    if(_state == VideoState.NONE){
      return;
    }

    print(_controller.value.position.inSeconds);
    var currentSecond = _controller.value.position.inSeconds;

    if(_state == VideoState.STARTED && currentSecond == _currentQuestion.timeToShow){
      print("------------------------------>Time to show: ${_currentQuestion.timeToShow}");
      _state = VideoState.SHOWING_ANSWERS;
      setState(() {});
    }

    if(_state == VideoState.SHOWING_ANSWERS && currentSecond == _currentQuestion.timeToStop){
      print(_controller.value.playerState);
      print("------------------------------>Time to stop: ${_currentQuestion.timeToStop}");
      _state = VideoState.WAITING_ON_ANSWER;
      _controller.pause();
      setState(() {});
    }

    if(_state == VideoState.QUESTION_ANSWERED && currentSecond == _currentQuestion.timeToEnd){
      print("------------------------------>Time to end: ${_currentQuestion.timeToEnd}");
      _controller.pause();
      _state = VideoState.QUESTION_SUMMARY;
      setState(() {});
    }
  }

  _createAnswerQuestionsWidget(){
    _questionAnswers = List<Widget>();
    _answersWidget = List<Widget>();
    if(_state != VideoState.NONE && _state != VideoState.STARTED) {
      // Create the answers question if there are any left
      print("===================>>> STATE: ${_state.toString()}");
      if ( (_state == VideoState.WAITING_ON_ANSWER) && _numQuestions > _currentQuestionIndex) {
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
      else if(_state == VideoState.QUESTION_ANSWERED){
        for (var answer in _currentQuestion.answers) {
          if(answer['id'] == _selectedAnswerId){
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
                            )
                        )
                    )
                )
            );
          }
        }
      }

      var answersSectionWidget = List<Widget>();
      answersSectionWidget.add(
          Column(
            children: _answersWidget,
          )
      );

      if(_state != VideoState.QUESTION_SUMMARY) {
        _questionAnswers.add(
            Container(
                padding: EdgeInsets.only(
                    bottom: 20, top: 30, left: 10, right: 10),
                //.all(10),//.only(top: 30, bottom: 30),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _theme.colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: _theme.colorScheme.secondary
                  ),
                  child: Center(
                    heightFactor: 2,
                    child: Text(
                      _currentQuestion.statement,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                )
            )
        );
      }

      var summarySectionWidget = List<Widget>();
      if(_state == VideoState.QUESTION_SUMMARY) {
        bool answerIsCorrect = _currentQuestion.officialAnswerId == _selectedAnswerId;
        int endTime = DateTime
            .now()
            .millisecondsSinceEpoch + 1000 * 5;
        summarySectionWidget.add(
            Center(
                child: Visibility(
                  visible: _state == VideoState.QUESTION_SUMMARY ? true : false,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    //color: answerIsCorrect ? Colors.green : _theme.colorScheme.error,
                    decoration: BoxDecoration(
                      //color: answerIsCorrect ? Colors.green : _theme.colorScheme.error,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: answerIsCorrect ? Colors.green : _theme.colorScheme.error,
                      ),
                    ),
                    child: Column(
                        children: [
                          Text(
                            answerIsCorrect ? 'Correct!' : 'Nope',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: answerIsCorrect ? Colors.green : _theme.colorScheme.error
                            ),
                          ),
                          Row(
                              children: [
                                Expanded(
                                  child:
                                  IconButton(
                                    icon: Icon(Icons.thumb_up_alt_outlined,
                                      size: 100,
                                      color: _theme.colorScheme
                                          .primaryVariant,),
                                    onPressed: () {
                                      print("Thumbs up!!!!!!!!!!!!!!!!");
                                    },
                                  ),
                                ),
                                Expanded(
                                  child:
                                  IconButton(
                                    icon: Icon(Icons.thumb_down_alt_outlined,
                                        size: 100,
                                        color: _theme.colorScheme
                                            .primaryVariant),
                                    onPressed: () {
                                      print("Thumbs down!!!!!!!!!!!!!!!!");
                                    },
                                  ),
                                ),
                              ]
                          ),
                          Column(
                              children: [
                                Text(
                                  'Vote! or...',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _theme.colorScheme.secondary
                                  ),
                                ),
                                //Countdown(
                                //  countdownController: _countdownController
                                //),
                                CountdownTimer(
                                  endTime: endTime,
                                  onEnd: _prepareForNextQuestion,
                                  widgetBuilder: (_,
                                      CurrentRemainingTime time) {
                                    print(
                                        "++++++++++++++++++++++>>>>>>>>>>>>>> 'In the widget builder: ${time
                                            .toString()}");
                                    if (time == null) {
                                      return Text('0');
                                    }
                                    return Text(
                                      '${time.sec}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: _theme.colorScheme
                                              .primaryVariant
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  'For next video',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _theme.colorScheme.secondary
                                  ),
                                ),
                              ]
                          ),
                        ]
                    ),
                  ),
                )
            )
        );
      }

      _questionAnswers.add(
          Column(
            children: _state == VideoState.QUESTION_SUMMARY ? summarySectionWidget : answersSectionWidget
          )
      );
    }
  }


  _createYoutubePlayer(){
    _youtubePlayerWidget = YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: false,
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
        onEnterFullScreen: (){print("========================================>>> Entering FULL SCREEN");},
        onExitFullScreen: (){print("========================================>>> Exiting FULL SCREEN");},
        builder: (context, player) {
          return Column(
            children: [
              // some widgets
              player,
              //some other widgets
            ],
          );
        },
    );
  }

  Widget _getPortraitView(){
    return ListView(
      //mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Container(
          height: 70,
          padding: const EdgeInsets.all(10.0),
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
        Container(
                child: _youtubePlayerWidget
        ),
        Column(
          children: _questionAnswers,
        )
      ],
    );
  }

  Widget _getPlanLandscapeView(){
    return Stack(
        children: [
          Container(
            child: _youtubePlayerWidget
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _questionAnswers,
            ),
        ]
    );

  }

  /*
  _recoverVideo(Orientation newOrientation){
    if(_currentOrientation == null){
      print("===========================> Assigning first value to current orientation");
      _currentOrientation = newOrientation;
    }

    if(_currentOrientation != newOrientation){
      print("===========================> Changing to new orientation");
      Duration curPos = Duration(seconds: _controller.value.position.inSeconds);
      _currentOrientation = newOrientation;
      _controller.pause();
      Future.delayed(Duration(milliseconds: 4000)).then((e) {
        print("================================>NOW I am trying to go to the right video position");
        _controller.seekTo(curPos);
        _controller.play();
      });
    }

  }

   */


  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    _createAnswerQuestionsWidget();

    return OrientationBuilder(
        builder: (context, orientation) {
          print("======================> Orientation: ${orientation.toString()}");
          _currentOrientation = orientation;
          //_recoverVideo(orientation);
          return Scaffold(
            drawer: orientation == Orientation.portrait ? AppDrawer() : null,
            appBar: orientation == Orientation.portrait ? CustomAppBar(key: customBarStateKey,title: 'Videos') : null,
            body: Center(
                      child: orientation == Orientation.portrait
                          ? _getPortraitView()
                          : _getPlanLandscapeView()

                  ),
          );
        }
    );
    /*
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar(key: customBarStateKey,title: 'Videos'),
      body: OrientationBuilder(
          builder: (context, orientation) {
            return Center(

                child: orientation == Orientation.portrait
                    ? _getPortraitView()
                    : _getPlanLandscapeView()

            );
          }
      ),
    );

     */
  }
}
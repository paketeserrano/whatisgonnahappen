import 'package:flutter/material.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/widget/addQuestionWidget.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';

class AddVideosScreen extends StatefulWidget{
  final String youtubeVideoId;

  AddVideosScreen(this.youtubeVideoId);

  @override
  _AddVideosScreenState createState() => _AddVideosScreenState();
}

class _AddVideosScreenState extends State<AddVideosScreen>{
  List<Widget> _questions;
  TextEditingController _videoNameController;
  ThemeData _theme;
  String _youtubeVideoId;
  YoutubePlayerBuilder _youtubePlayerWidget;
  YoutubePlayerController _controller;
  bool _showAddQuestion = false;
  List _questionList = List();
  GlobalKey<QuestionWidgetState> _questionStateKey;
  dynamic questionAnswersValuesForEditing;
  int questionAnswerIndexForEditing;

  @override
  void initState() {
    super.initState();
    _questions = List<Widget>();
    _videoNameController = TextEditingController();
    _youtubeVideoId = widget.youtubeVideoId;
    _questionStateKey = GlobalKey<QuestionWidgetState>();
    questionAnswerIndexForEditing = -1;

    _controller = YoutubePlayerController(
      initialVideoId: _youtubeVideoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        hideControls: false,
        hideThumbnail: false,
      ),
    );

    _youtubePlayerWidget = YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
        ],
        onReady: () {
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

  @override
  void dispose() {
    _videoNameController.dispose();
    super.dispose();
  }

  void _showAddQuestionWidget(){
    setState(() { _showAddQuestion = _showAddQuestion ? false : true;});
  }

  void cancelAddQuestion(){
    setState(() { _showAddQuestion = _showAddQuestion ? false : true;});
  }

  void addQuestion(){
    Map<String,dynamic> questionMap = Map<String,dynamic>();
    questionMap['statement'] = _questionStateKey.currentState.question.text;
    questionMap['time_to_show'] = int.parse(_questionStateKey.currentState.time_to_show.text);
    questionMap['time_to_stop'] = int.parse(_questionStateKey.currentState.time_to_stop.text);
    questionMap['time_to_start'] = int.parse(_questionStateKey.currentState.time_to_start.text);
    questionMap['time_to_end'] = int.parse(_questionStateKey.currentState.time_to_end.text);
    questionMap['official_answer'] = _questionStateKey.currentState.officialAnswer.text;
    List<String> answersList = List<String>();
    answersList.add(_questionStateKey.currentState.answer1.text);
    answersList.add(_questionStateKey.currentState.answer2.text);
    if(_questionStateKey.currentState.answer3.text != ''){
      answersList.add(_questionStateKey.currentState.answer3.text);
    }
    questionMap['answers'] = answersList;
    if(questionAnswerIndexForEditing == -1)
      _questionList.add(questionMap);
    else{
      _questionList.removeAt(questionAnswerIndexForEditing);
      _questionList.insert(questionAnswerIndexForEditing, questionMap);
    }

    setState(() { _showAddQuestion = _showAddQuestion ? false : true;});
  }

  List<Widget> buildQuestionsList(){
    List<Widget> widgetList = List<Widget>();
    _questionList.asMap().forEach((index,question) {
      widgetList.add(
        Visibility(
            visible: !_showAddQuestion,
            child:
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child:
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 8, // 80%
                        child: Text(question['statement'], overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        flex: 1, // 10%
                        child:
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            questionAnswersValuesForEditing = _questionList[index];
                            questionAnswerIndexForEditing = index;
                            _showAddQuestionWidget();
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1, // 10%
                        child:
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {_questionList.removeAt(index);});
                          },
                        ),
                      )
                    ],
                  )
                )
          )
        );
    });

    return widgetList;
  }

  List<Widget> _getQuestions(){
    return _questions;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Add a new Video',),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12,),
              Container(
                  child: _youtubePlayerWidget
              ),
              SizedBox(height: 12,),
              TextFormField(
                controller: _videoNameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _theme.colorScheme.primary, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _theme.colorScheme.secondary, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Enter the video name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name for the video';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12,),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Visibility(
                            visible: !_showAddQuestion,
                            child:
                            ElevatedButton(
                              onPressed: () {
                                questionAnswersValuesForEditing = null;
                                questionAnswerIndexForEditing = -1;
                                _showAddQuestionWidget();
                              },
                              child: Text('Add Question'),
                            ),
                          ),
                          Visibility(
                            visible: !_showAddQuestion,
                            child:
                            ElevatedButton(
                              onPressed: () {
                                if(_questionList.length == 0){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Please, add at least 1 question to the video'),
                                  ));
                                }
                                else if (_formKey.currentState.validate()) {
                                  Map<String, dynamic> video = Map<String, dynamic>();
                                  video['name'] = _videoNameController.text;
                                  video['youtube_id'] = _youtubeVideoId;
                                  video['questions'] = _questionList;
                                  APIService.instance.addVideo(video).then((response) {
                                    if (response.statusCode == 200) {
                                      Map<String, dynamic> responseBody = json.decode(response.body);
                                      if (responseBody['code'] == 'SUCCESS') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('The video has been added'),
                                        ));
                                      }
                                      else if (responseBody['code'] == 'VIDEO_ALREADY_EXISTS') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('The video already exists'),
                                        ));
                                      }
                                    }
                                  });
                                }
                              },
                              child: Text('Submit Video'),
                            ),
                          ),
                        ]
                    ),
                  )
              ),
              _showAddQuestion ? QuestionWidget(key: _questionStateKey, cancelFunc: this.cancelAddQuestion, addQuestionFunc: this.addQuestion,inputValuesParam: questionAnswersValuesForEditing) : Container(),
              ...buildQuestionsList(),
            ],
            ),
          ),
        ),
    ),
    );
  }
}


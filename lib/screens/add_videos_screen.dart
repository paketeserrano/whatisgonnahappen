import 'package:flutter/material.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/widget/addQuestionWidget.dart';
import 'package:youtube1/services/api_service.dart';

class AddVideosScreen extends StatefulWidget{
  @override
  _AddVideosScreenState createState() => _AddVideosScreenState();
}

class _AddVideosScreenState extends State<AddVideosScreen>{
  List<GlobalKey<QuestionWidgetState>> _questionsState;
  List<Widget> _questions;
  TextEditingController _playlistIdController;
  TextEditingController _videoNameController;
  TextEditingController _videoYoutubeIdController;

  @override
  void initState() {
    super.initState();
    _questionsState = List<GlobalKey<QuestionWidgetState>>();
    _questions = List<Widget>();
    _playlistIdController = TextEditingController();
    _videoNameController = TextEditingController();
    _videoYoutubeIdController = TextEditingController();
  }

  @override
  void dispose() {
    _playlistIdController.dispose();
    _videoNameController.dispose();
    _videoYoutubeIdController.dispose();
    super.dispose();
  }

  void _addQuestion(){
    final GlobalKey<QuestionWidgetState> questionStateKey = GlobalKey<QuestionWidgetState>();
    QuestionWidget question = QuestionWidget(key: questionStateKey,);
    _questionsState.add(questionStateKey);
    _questions.add(question);
  }

  List<Widget> _getQuestions(){
    return _questions;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Add a new match',),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _playlistIdController,
                decoration: const InputDecoration(
                  labelText: 'Enter a Playlist Id or name for a new playlist',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a Playlist Id for existing one  or name for a new playlist';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _videoNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter the video name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name for the video';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _videoYoutubeIdController,
                decoration: const InputDecoration(
                  labelText: 'Enter the video id',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a video id';
                  }
                  return null;
                },
              ),
              ..._getQuestions(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate()) {
                            Map<String,dynamic> video = Map<String,dynamic>();
                            video['playlist_id'] = _playlistIdController.text;
                            video['name'] = _videoNameController.text;
                            video['youtube_id'] = _videoYoutubeIdController.text;

                            List questionList = List();
                            _questionsState.forEach((key) {
                              Map<String,dynamic> questionMap = Map<String,dynamic>();
                              questionMap['statement'] = key.currentState.question.text;
                              questionMap['time_to_show'] = int.parse(key.currentState.time_to_show.text);
                              questionMap['time_to_stop'] = int.parse(key.currentState.time_to_stop.text);
                              questionMap['time_to_start'] = int.parse(key.currentState.time_to_start.text);
                              questionMap['time_to_end'] = int.parse(key.currentState.time_to_end.text);
                              questionMap['official_answer'] = key.currentState.officialAnswer.text;
                              List<String> answersList = List<String>();
                              answersList.add(key.currentState.answer1.text);
                              answersList.add(key.currentState.answer2.text);
                              if(key.currentState.answer3.text != ''){
                                print("---- Adding answer 3");
                                answersList.add(key.currentState.answer3.text);
                              }
                              questionMap['answers'] = answersList;
                              questionList.add(questionMap);
                            });

                            video['questions'] = questionList;
                            print(video);

                            APIService.instance.addVideo(video);

                            // If the form is valid, display a Snackbar.
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(_playlistIdController.text + '-' + _videoNameController.text + '-' + _videoYoutubeIdController.text),
                            ));
                          }
                        },
                        child: Text('Submit'),
                    ),
                      ElevatedButton(
                        onPressed: () {
                          _addQuestion();
                          setState(() { });
                        },
                        child: Text('Add Question'),
                      ),
                  ]
                  ),
                )
              ),
            ],
        ),
      ),
    ),
    );
  }
}


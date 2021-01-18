import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget{

  QuestionWidget({Key key}) : super(key: key);

  @override
  QuestionWidgetState createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget>{
  TextEditingController question;
  TextEditingController time_to_show;
  TextEditingController time_to_stop;
  TextEditingController time_to_start;
  TextEditingController time_to_end;
  TextEditingController answer1;
  TextEditingController answer2;
  TextEditingController answer3;
  TextEditingController officialAnswer;

  @override
  void initState(){
    super.initState();
    question = TextEditingController();
    time_to_show = TextEditingController();
    time_to_stop = TextEditingController();
    time_to_start = TextEditingController();
    time_to_end = TextEditingController();
    answer1 = TextEditingController();
    answer2 = TextEditingController();
    answer3 = TextEditingController();
    officialAnswer = TextEditingController();
  }

  @override
  void dispose(){
    question.dispose();
    time_to_show.dispose();
    time_to_stop.dispose();
    time_to_start.dispose();
    time_to_end.dispose();
    answer1.dispose();
    answer2.dispose();
    answer3.dispose();
    officialAnswer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: question,
                decoration: const InputDecoration(
                  labelText: 'Question Text',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the question text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: time_to_show,
                decoration: const InputDecoration(
                  labelText: 'Time to ask question (in seconds)',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the time to ask the question in seconds';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: time_to_stop,
                decoration: const InputDecoration(
                  labelText: 'Time to stop to wait for the user to answer (in seconds)',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the time to stop to wait for the user to answer the question (in seconds)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: time_to_start,
                decoration: const InputDecoration(
                  labelText: 'Time to start the video section with this question (in seconds)',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the time to start the video section with this question (in seconds)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: time_to_end,
                decoration: const InputDecoration(
                  labelText: 'Time to end the video section with this question (in seconds)',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the time to end the video section with this question (in seconds)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: answer1,
                decoration: const InputDecoration(
                  labelText: 'Answer 1',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter answer 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: answer2,
                decoration: const InputDecoration(
                  labelText: 'Answer 2',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter answer 2';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: answer3,
                decoration: const InputDecoration(
                  labelText: 'Answer 3 (optional)',
                ),
              ),
              TextFormField(
                controller: officialAnswer,
                decoration: const InputDecoration(
                  labelText: 'Official Answer number (1,2 or 3) (optional)',
                ),
              ),
            ],
        )
    );
  }

}
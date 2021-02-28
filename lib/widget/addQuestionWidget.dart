import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget{
  Function cancelAddQuestionsFunc;
  Function addFunc;
  dynamic inputValues;

  QuestionWidget({Key key, Function cancelFunc, Function addQuestionFunc, dynamic inputValuesParam}) : super(key: key){
    cancelAddQuestionsFunc = cancelFunc;
    addFunc = addQuestionFunc;
    inputValues = inputValuesParam;
  }

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
  ThemeData _theme;
  dynamic inputValues;
  final _formKey = GlobalKey<FormState>();

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
    if(widget.inputValues != null){
      setValues(widget.inputValues);
    }
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

  void setValues(dynamic values){
    question.text = values['statement'];
    answer1.text = values['answers'][0];
    answer2.text = values['answers'][1];
    if(values['answers'].length > 2){
      answer3.text = values['answers'][2];
    }
    time_to_show.text = values['time_to_show'].toString();
    time_to_stop.text = values['time_to_stop'].toString();
    time_to_start.text = values['time_to_start'].toString();
    time_to_end.text = values['time_to_end'].toString();
    officialAnswer.text = values['official_answer'].toString();
  }

  @override
  Widget build(BuildContext context){
    _theme = Theme.of(context);
    return Form(
        key: _formKey,
        child:
          Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: _theme.colorScheme.primary),
              borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 12,),
                TextFormField(
                  controller: question,
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
                    labelText: 'Question Text',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the question text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: answer1,
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
                    labelText: 'Answer 1',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter answer 1';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: answer2,
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
                    labelText: 'Answer 2',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter answer 2';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: answer3,
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
                    labelText: 'Answer 3 (optional)',
                  ),
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: time_to_show,
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
                    labelText: 'Time to ask question (in seconds)',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the time to ask the question in seconds';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: time_to_stop,
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
                    labelText: 'Time to stop to wait for the user to answer (in seconds)',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the time to stop to wait for the user to answer the question (in seconds)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: time_to_start,
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
                    labelText: 'Time to start the video section with this question (in seconds)',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the time to start the video section with this question (in seconds)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: time_to_end,
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
                    labelText: 'Time to end the video section with this question (in seconds)',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the time to end the video section with this question (in seconds)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  controller: officialAnswer,
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
                    labelText: 'Official Answer number (1,2 or 3) (optional)',
                  ),
                ),
                SizedBox(height: 12,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color:  Colors.red)
                      ),
                      onPressed: () {
                        widget.cancelAddQuestionsFunc();
                      },
                      child: Text('Cancel'),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color:  _theme.colorScheme.primary),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.addFunc();
                        }
                      },
                      child: Text('Submit Question'),
                    ),
                    ]
                ),
                SizedBox(height: 20,),
              ],
          )
        )
    );
  }

}
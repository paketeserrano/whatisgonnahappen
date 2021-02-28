import 'package:flutter/material.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/widget/appDrawer.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'dart:convert';
import 'dart:async';
import 'package:youtube1/models/most_points_challenge.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ChallengesScreen extends StatefulWidget {
  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  final GlobalKey<CustomAppBarState> customBarStateKey = GlobalKey<CustomAppBarState>();
  ThemeData _theme;
  TextEditingController _mostPointsChallengeUserName;
  final _formKey = GlobalKey<FormState>();
  Future< List<MostPointChallenge> > _userActiveMostPointChallenges;
  Future< List<MostPointChallenge> > _userCompletedMostPointChallenges;
  CountdownTimerController _countdownController;
  String _selectedUser;

  @override
  void initState() {
    super.initState();
    _mostPointsChallengeUserName = TextEditingController();
    _userActiveMostPointChallenges = APIService.instance.getUserActiveMostPointChallenges();
    _userCompletedMostPointChallenges = APIService.instance.getUserCompletedMostPointChallenges();
  }

  @override
  void dispose(){
    _mostPointsChallengeUserName.dispose();
    if(_countdownController != null)
      _countdownController.dispose();
    super.dispose();
  }

  Widget buildCompletedChallenge(MostPointChallenge challenge, int index){
    String result = '';
    if(sharedPrefs.username == challenge.challenger.username){
      if(challenge.challengerPoints >= challenge.challengedPoints){
        result = 'Victory';
      }
      else{
        result = 'Defeat';
      }
    }
    else if(sharedPrefs.username == challenge.challenged.username){
      if(challenge.challengedPoints >= challenge.challengerPoints){
        result = 'Victory';
      }
      else{
        result = 'Defeat';
      }
    }
    return Container(
        height: 40,
        color: (index + 1).remainder(2) == 0 ? _theme.colorScheme.secondary : _theme.colorScheme.secondaryVariant,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(sharedPrefs.username),
            Text(sharedPrefs.username == challenge.challenger.username ? challenge.challengerPoints.toString() : challenge.challengedPoints.toString()),
            Text(result),
            Text(sharedPrefs.username == challenge.challenger.username ? challenge.challengedPoints.toString() : challenge.challengerPoints.toString()),
            sharedPrefs.username == challenge.challenger.username ? Text(challenge.challenged.username) : Text(challenge.challenger.username),
          ]
        )
    );
  }

  Widget buildChallenge(MostPointChallenge challenge, int index){
    if(challenge.state == 'INITIAL') {
      return Container(
          height: 40,
          color: (index + 1).remainder(2) == 0 ? _theme.colorScheme.secondary : _theme.colorScheme.secondaryVariant,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(sharedPrefs.username),
              Text("vs"),
              Text(sharedPrefs.username == challenge.challenger.username ? challenge.challenged.username : challenge.challenger.username),
              sharedPrefs.username == challenge.challenger.username ?
              Text("Waiting") :
              ElevatedButton(
                child: Text("Accept"),
                onPressed: () {
                  APIService.instance.acceptMostPointsChallenge(challenge).then((
                      response) {
                    if (response.statusCode == 200) {
                      Map<String, dynamic> responseBody = json.decode(
                          response.body);
                      if (responseBody['code'] == 'CHALLENGE_NOT_FOUND' ||
                          responseBody['code'] == 'WRONG_USER') {
                        final snackBar = SnackBar(
                          content: Text(
                              'Problem accepting the challenge request. Please, contact developers'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else if (responseBody['code'] == 'SUCCESS') {
                        setState(() {
                          _userActiveMostPointChallenges = APIService.instance.getUserActiveMostPointChallenges();
                        });
                        final snackBar = SnackBar(
                          content: Text('Challenge has started!!!'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  });
                },
              ),
            ]
          )
        );
    }
    else if(challenge.state == 'STARTED'){
      // TODO: Take into consideration timezones when going into production
      DateTime nowTime = DateTime.now();
      int countdownEndTime = challenge.endTime.millisecondsSinceEpoch;
      var timerEndtime = challenge.endTime.difference(nowTime);
      new Timer(timerEndtime, () {
        setChallengeOnFinishedState(challenge);
      });

      _countdownController = CountdownTimerController(endTime: countdownEndTime);

      return Container(
          height: 40,
          color: (index + 1).remainder(2) == 0 ? _theme.colorScheme.secondary : _theme.colorScheme.secondaryVariant,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(sharedPrefs.username),
              Text(sharedPrefs.username == challenge.challenger.username ? challenge.challengerPoints.toString() : challenge.challengedPoints.toString()),
              CountdownTimer(
                controller: _countdownController,
                widgetBuilder: (_,
                  CurrentRemainingTime time) {
                    String countdown = '';
                    if(time == null){
                      countdown = '0s';
                    }
                    else if(time.hours != null){
                      countdown = '${time.hours}h ${time.min}m';
                    }
                    else if(time.min != null){
                      countdown = '${time.min}m ${time.sec}s';
                    }
                    else if(time.sec != null) {
                      countdown = '${time.sec}s';
                    }
                    return Text(countdown);
                  },
              ),
              //Countdown(countdownController: countdownController),
              Text(sharedPrefs.username == challenge.challenger.username ? challenge.challengedPoints.toString() : challenge.challengerPoints.toString()),
              Text(sharedPrefs.username == challenge.challenger.username ? challenge.challenged.username : challenge.challenger.username),

            ]
          )
        );
    }
    else if(challenge.state == 'FINISHED' ||
        (sharedPrefs.username == challenge.challenger.username && challenge.state == 'COMPLETED_BY_CHALLENGED') ||
        (sharedPrefs.username == challenge.challenged.username && challenge.state == 'COMPLETED_BY_CHALLENGER')){
      String result = '';
      if(sharedPrefs.username == challenge.challenger.username){
        if(challenge.challengerPoints >= challenge.challengedPoints){
          result = 'Victory';
        }
        else{
          result = 'Defeat';
        }
      }
      else if(sharedPrefs.username == challenge.challenged.username){
        if(challenge.challengedPoints >= challenge.challengerPoints){
          result = 'Victory';
        }
        else{
          result = 'Defeat';
        }
      }
      return Container(
          height: 40,
          color: (index + 1).remainder(2) == 0 ? _theme.colorScheme.secondary : _theme.colorScheme.secondaryVariant,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(sharedPrefs.username),
              Text(sharedPrefs.username == challenge.challenger.username ? challenge.challengerPoints.toString() : challenge.challengedPoints.toString()),
              Text(result),
              Text(sharedPrefs.username == challenge.challenger.username ? challenge.challengedPoints.toString() : challenge.challengerPoints.toString()),
              Text(sharedPrefs.username == challenge.challenger.username ? challenge.challenged.username : challenge.challenger.username),
              ElevatedButton(
                child: Text("Claim Points"),
                onPressed: () {
                  setChallengeOnCompletedState(challenge);
                },
              ),
            ]
          )
        );
    }
  }

  setChallengeOnFinishedState(MostPointChallenge challenge) async {
    challenge.state = 'FINISHED';
    await APIService.instance.setMostPointsChallengeState(challenge);
    setState(() {
      _userActiveMostPointChallenges = APIService.instance.getUserActiveMostPointChallenges();
    });
  }

  setChallengeOnCompletedState(MostPointChallenge challenge) {
    if(sharedPrefs.username == challenge.challenger.username){
      challenge.state = 'COMPLETED_BY_CHALLENGER';
    }
    else{
      challenge.state = 'COMPLETED_BY_CHALLENGED';
    }

    APIService.instance.setMostPointsChallengeState(challenge).then((response) {
      setState(() {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          sharedPrefs.userscore = responseBody['user_score'];
        }
        _userActiveMostPointChallenges = APIService.instance.getUserActiveMostPointChallenges();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
        drawer: AppDrawer(),
    appBar: CustomAppBar(key: customBarStateKey, title: 'Challenges'),
    body: SingleChildScrollView(
        child: Column(
          children: <Widget>[Form(
            key: _formKey,
            child:Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              padding: EdgeInsets.all(10.0),
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: _theme.colorScheme.secondary,
                ),
              ),
              child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Most points in 1h',
                        style: TextStyle(
                          color: _theme.colorScheme.primary,
                          fontSize: 22.0,
                        ),
                      ),
                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: _mostPointsChallengeUserName,
                            decoration: InputDecoration(
                                labelText: 'Enter user name to challenge'
                            )
                        ),
                        suggestionsCallback: (pattern) {
                          List<String> list = List<String>();
                          return APIService.instance.usernameSuggestions(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (suggestion) {
                          _mostPointsChallengeUserName.text = suggestion;
                        },
                        noItemsFoundBuilder: (context)=> ListTile(title: Text('No matches found')),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the user name you want to challenge';
                          }
                          return null;
                        },
                          hideOnEmpty: true,
                          hideOnLoading: true,
                        onSaved: (value) {
                          _selectedUser = value;
                        }
                      ),
                      ElevatedButton(
                        child: Text('Challenge'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                          APIService.instance.createMostPointsChallenge(_mostPointsChallengeUserName.text, 1).then((response) {
                          if (response.statusCode == 200) {
                            Map<String, dynamic> responseBody = json.decode(response.body);
                            if(responseBody['code'] == 'USER_NOT_FOUND'){
                              final snackBar = SnackBar(
                                content: Text('User not found!'),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(responseBody['code'] == 'CHALLENGE_EXISTS'){
                              final snackBar = SnackBar(
                              content: Text('You already have an active challenge with ${_mostPointsChallengeUserName.text}'),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else if(responseBody['code'] == 'SUCCESS'){
                              setState(() {
                                _userActiveMostPointChallenges = APIService.instance.getUserActiveMostPointChallenges();
                              });
                              final snackBar = SnackBar(
                                content: Text('Challenge requested!'),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }
                          else{
                          final snackBar = SnackBar(
                              content: Text('Problem communicating with the server. Check your internet connection!'),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        });
                        }
                      }
                    ),

                      ]
                  ),
                )
              ),
                  Center(
                    heightFactor: 2,
                    child: Text(
                      'Active Challenges',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  FutureBuilder<List<MostPointChallenge>>(
                  future: _userActiveMostPointChallenges,
                  builder: (context,snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      padding: const EdgeInsets.all(8.0),
                      constraints: BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          MostPointChallenge challenge = snapshot.data[index];
                          return buildChallenge(challenge, index);
                        },
                      )
                  );
                } else if (snapshot.hasError) {
                  return Text("${'Error in the response'}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
            Center(
              heightFactor: 2,
              child: Text(
                'Past Challenges',
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
            FutureBuilder(
              future: _userCompletedMostPointChallenges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        MostPointChallenge challenge = snapshot.data[index];
                        return buildCompletedChallenge(challenge, index);
                      },
                    )
                  );
                } else if (snapshot.hasError) {
                  return Text("${'Error in the response'}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ]
          )
      )
    );
  }
}
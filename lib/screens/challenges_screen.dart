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

  @override
  void initState() {
    super.initState();
    _mostPointsChallengeUserName = TextEditingController();
    _userActiveMostPointChallenges = APIService.instance.getUserActiveMostPointChallenges();
  }

  @override
  void dispose(){
    _mostPointsChallengeUserName.dispose();
    super.dispose();
  }

  Widget buildChallenge(MostPointChallenge challenge){
    print("----> In buildChallenge");
    if(challenge.state == 'INITIAL') {
      print("-----------> In INITIAL");
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(challenge.challenger.username),
            Text("vs"),
            Text(challenge.challenged.username),
            sharedPrefs.username == challenge.challenger.username ?
            Text("Waiting") :
            ElevatedButton(
              child: Text("Accept"),
              onPressed: () {
                print("Request sent");
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
      );
    }
    else if(challenge.state == 'STARTED'){
      // TODO: Take into consideration timezones when going into production
      DateTime nowTime = DateTime.now();
      int countdownEndTime = challenge.endTime.millisecondsSinceEpoch;
      print('countdownEndTime: $countdownEndTime');
      var timerEndtime = challenge.endTime.difference(nowTime);
      print('timerEndtime:  ${timerEndtime.toString()}');
      new Timer(timerEndtime, () {
        setChallengeOnFinishedState(challenge);
      });

      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(sharedPrefs.username),
            Text(challenge.challengerPoints.toString()),
            CountdownTimer(
              endTime: countdownEndTime,
              onEnd: (){print('Countdown finished!!');},
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
            Text(challenge.challengerPoints.toString()),
            sharedPrefs.username == challenge.challenger.username ? Text(challenge.challenged.username) : Text(challenge.challenger.username),

          ]
      );
    }
  }

  setChallengeOnFinishedState(MostPointChallenge challenge) async {
    print("Calling save challenge from phone");
    challenge.state = 'FINISHED';
    await APIService.instance.saveMostPointChallenges(challenge);
    _userActiveMostPointChallenges = APIService.instance.getUserActiveMostPointChallenges();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
        drawer: AppDrawer(),
    appBar: CustomAppBar(key: customBarStateKey, title: 'Challenges'),
    body: Column(
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
                  TextFormField(
                        controller: _mostPointsChallengeUserName,
                        decoration: const InputDecoration(
                          labelText: 'Enter user name to challenge',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the user name you want to challenge';
                          }
                          return null;
                        },
                      ),
                  ElevatedButton(
                    child: Text('Challenge'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        print("The field is valid");
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
        FutureBuilder<List<MostPointChallenge>>(
          future: _userActiveMostPointChallenges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  //print('playlist length: ${_playlists.length}');
                  MostPointChallenge challenge = snapshot.data[index];
                  print("++++++++++++++++++++++++++++++++++");
                  print(challenge.toJson());
                  print("++++++++++++++++++++++++++++++++++");
                  return buildChallenge(challenge);
                },
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
    );
  }
}
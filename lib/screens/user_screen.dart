import 'package:flutter/material.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/screens/hashtag_list_screen.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/widget/appDrawer.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/screens/video_screen.dart';
import 'package:youtube1/screens/challenges_screen.dart';
import 'package:youtube1/screens/login_screen.dart';
import 'package:youtube1/screens/user_screen.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final GlobalKey<CustomAppBarState> customBarStateKey = GlobalKey<CustomAppBarState>();
  Map<String,int> _userStats = Map<String,int>();
  ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  _initPage() async {
    APIService.instance.getUserStats().then((stats){
      _userStats = stats;
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar(key: customBarStateKey, title: 'Profile'),
      body: SingleChildScrollView(
            child:
              Column(
                children: [
                  Container(
                    height: 100,
                    child:
                      ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: 200,
                          child:
                            Card(
                                color: _theme.colorScheme.primary,
                                child: InkWell(
                                  onTap: () {
                                    print("Show user name and stats");
                                  },
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.timeline, size:50.0, color: Colors.white),
                                        Text(
                                          'Info & Stats',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ]
                                  ),
                                )
                            )
                          ),
                        Container(
                          width: 200,
                          child:
                          Card(
                              color: Colors.grey,
                              child: InkWell(
                                onTap: () {
                                  showGeneralDialog(
                                    context: context,
                                    pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
                                      return Center(
                                        child:
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: Colors.white,
                                            ),
                                            width: 250.0,
                                            height: 200.0,
                                            child: Padding(
                                              padding:EdgeInsets.all(20),
                                              child:
                                                Text(
                                                  'We are still in beta version. This section will be available soon and it will contain fun prizes you will win playing this game',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    decoration: TextDecoration.none,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                          )
                                      );
                                    },
                                    barrierDismissible: true,
                                    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                    barrierColor: Colors.black.withOpacity(0.3),
                                    transitionDuration: const Duration(milliseconds: 200),
                                  );
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.grade, size:50.0, color: Colors.white),
                                      Text(
                                        'Achievements',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ]
                                ),
                              )
                          )
                        ),
                        ]
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      height: 150,
                      child:
                          Card(
                            color: _theme.colorScheme.secondary,
                              child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                      children:[
                                        Padding(
                                          padding: EdgeInsets.only(left:10),
                                          child:
                                          Text(
                                            "Username: ",
                                            style: TextStyle(
                                                fontSize: 20.0
                                            ),
                                          ),
                                        ),
                                        Text(
                                          sharedPrefs.username,
                                          style: TextStyle(
                                              fontSize: 20.0
                                          ),
                                        )
                                      ]
                                  ),
                                  Row(
                                      children:[
                                        Padding(
                                          padding: EdgeInsets.only(left:10),
                                          child:
                                            Text(
                                              "Email: ",
                                              style: TextStyle(
                                                  fontSize: 20.0
                                              ),
                                            ),
                                        ),
                                        Text(
                                          sharedPrefs.useremail,
                                          style: TextStyle(
                                              fontSize: 20.0
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              )
                          )
                    ),
                    Text(
                      'Your Numbers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30.0
                      ),
                    ),
                    Container(
                      height: 500,
                      child:
                      ListView(
                          children: <Widget>[
                            Container(
                                child:
                                Card(
                                    color:_theme.colorScheme.primaryVariant,
                                    child: InkWell(
                                      onTap: () {
                                        print("Show user name and stats");
                                      },
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top:10),
                                              child:
                                                Text(
                                                  'Number Questions Answered',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                            ),
                                            Text(
                                              _userStats['num_questions_answered'].toString(),
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ]
                                      ),
                                    )
                                )
                            ),
                            Container(
                                width: 200,
                                child:
                                Card(
                                    color: _theme.colorScheme.primaryVariant,
                                    child: InkWell(
                                      onTap: () {
                                        print("Achievements");
                                      },
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top:10),
                                              child:
                                              Text(
                                                'Number Of Right Questions',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _userStats['num_right_responses'].toString(),
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ]
                                      ),
                                    )
                                )
                            ),
                            Container(
                                width: 200,
                                child:
                                Card(
                                    color: _theme.colorScheme.primaryVariant,
                                    child: InkWell(
                                      onTap: () {
                                        print("Achievements");
                                      },
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(top:10),
                                              child:
                                              Text(
                                                'Challenges Wins',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _userStats['num_challenges_won'].toString(),
                                              style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ]
                                      ),
                                    )
                                )
                            ),
                          ]
                      ),
                    ),
                  ]
                )
      )
      );
    }
  }
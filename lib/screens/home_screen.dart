import 'package:flutter/material.dart';
import 'package:youtube1/screens/hashtag_list_screen.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/widget/appDrawer.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/screens/video_screen.dart';
import 'package:youtube1/screens/challenges_screen.dart';
import 'package:youtube1/screens/login_screen.dart';
import 'package:youtube1/screens/user_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<CustomAppBarState> customBarStateKey = GlobalKey<CustomAppBarState>();
  ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _initHome();
  }

  _initHome() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: CustomAppBar(key: customBarStateKey, title: 'Home'),
        body:
        GridView.count(
            padding: EdgeInsets.all(10),
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 8.0,
            children: [
              Card(
                  color: _theme.colorScheme.primary,//Colors.blueGrey,
                  child: InkWell(
                    onTap: () {
                      APIService.instance.fetchRandomVideo().then((video){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => VideoScreen(video)),
                        );
                      });
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Icon(Icons.play_arrow_outlined, size:50.0, color: Colors.white),
                          Image(image: AssetImage('resources/images/game-controller-small.png'), height: 75,),
                          Text('Play Random Vids',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  )
              ),
              Card(
                  color: _theme.colorScheme.primary,//Colors.blueGrey,
                  child: InkWell(
                    onTap: () {
                      APIService.instance.fetchRandomVideo().then((video){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HashtagListScreen()),
                        );
                      });
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Icon(Icons.featured_play_list_outlined, size:50.0, color: Colors.white),
                          Image(image: AssetImage('resources/images/hashtag.png'), height: 75,),
                          Text(
                            'Play a Hashtag List',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  )
              ),
              Card(
                  color: _theme.colorScheme.primary,//Colors.blueGrey,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChallengesScreen()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Icon(Icons.grade_sharp, size:50.0, color: Colors.white),
                          Image(image: AssetImage('resources/images/two-game-controllers-small-2.png'), height: 75,),
                          Text(
                            'Challenges',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  )
              ),
              Card(
                  color: _theme.colorScheme.primary,//Colors.blueGrey,
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
                                    'This section will be available soon and you will be able to play with friends and family in a room',
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
                        //Icon(Icons.group_outlined, size:50.0, color: Colors.white),
                        Image(image: AssetImage('resources/images/group-small.png'), height: 75,),
                        Text(
                          'Group Game',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ]
                    ),
                  )
              ),
              Card(
                  color: _theme.colorScheme.primary,//Colors.grey,
                  child: InkWell(
                    onTap: () {
                      print("Home Clicked");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image(image: AssetImage('resources/images/home.png'), height: 75,),
                          //Icon(Icons.home_outlined, size:50.0, color: Colors.white),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  )
              ),
              Card(
                  color: _theme.colorScheme.primary,//Colors.grey,
                  child: InkWell(
                    onTap: () {
                      print("Home Clicked");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserScreen()),
                      );
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage('resources/images/tv.png',)
                          ),
                          //Icon(Icons.person, size:50.0, color: Colors.white),
                          Text(
                            'Profile',
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

            ]
        )
    );
  }

}
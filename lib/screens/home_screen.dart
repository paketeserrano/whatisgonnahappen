import 'package:flutter/material.dart';
import 'package:youtube1/screens/hashtag_list_screen.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/widget/appDrawer.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/screens/video_screen.dart';
import 'package:youtube1/screens/challenges_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<CustomAppBarState> customBarStateKey = GlobalKey<CustomAppBarState>();

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
                  color: Colors.blueGrey,
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
                          Icon(Icons.play_arrow_outlined, size:50.0, color: Colors.white),
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
                  color: Colors.blueGrey,
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
                          Icon(Icons.featured_play_list_outlined, size:50.0, color: Colors.white),
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
                  color: Colors.blueGrey,
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
                          Icon(Icons.grade_sharp, size:50.0, color: Colors.white),
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
                  color: Colors.blueGrey,
                  child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.group_outlined, size:50.0, color: Colors.white),
                        Text(
                          'Play Group Game',
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
                  color: Colors.grey,
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
                          Icon(Icons.home_outlined, size:50.0, color: Colors.white),
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
              )


            ]
        )
    );
  }

}
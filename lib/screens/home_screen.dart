import 'package:flutter/material.dart';
import 'package:youtube1/screens/hashtag_list_screen.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/widget/appDrawer.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/screens/video_screen.dart';
import 'package:youtube1/screens/challenges_screen.dart';

// IDEAS:
// - Periodic Competitions:
//   - Player with more points globally
//   - "" with more points by month, week and day
//   - We can even split by country if we get enough users
//   - Winner will get a trophy
//   - We need to add standings list and maybe sporadic messages when they are close to pass somebody in the classification

// - On Demand challenges
//   - User challenges a user to see who makes more points on a day, week or month

// - Multiplayer mode

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
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar(key: customBarStateKey, title: 'Home'),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              print("Home Clicked");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.play_arrow_outlined),
            title: Text("Play Random Vids"),
            onTap: () {
              print("Play Random Vids Clicked");
              APIService.instance.fetchRandomVideo().then((video){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoScreen(video)),
                );
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.featured_play_list_outlined),
            title: Text("Play a Hashtag List"),
            onTap: () {
              print("Play a Hashtag List Clicked");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HashtagListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text("Play a Group Game"),
            onTap: () {
              print("Play a group game Clicked");
            },
          ),
          ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text("Play as developer"),
            onTap: () {
              print("Play aa developer game Clicked");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HashtagListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text("Challenges"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChallengesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
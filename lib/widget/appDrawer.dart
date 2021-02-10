import 'package:flutter/material.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/screens/home_screen.dart';
import 'package:youtube1/screens/hashtag_list_screen.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/screens/video_screen.dart';
import 'package:youtube1/screens/challenges_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(sharedPrefs.username),
            accountEmail: Text('${sharedPrefs.useremail} | Score: ${sharedPrefs.userscore}'),
            currentAccountPicture: new Image.asset('resources/images/tv-64.png'),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryVariant),
          ),
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
                MaterialPageRoute(builder: (context) => HomeScreen()),
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

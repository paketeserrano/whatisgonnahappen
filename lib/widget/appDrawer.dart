import 'package:flutter/material.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/screens/home_screen.dart';
import 'package:youtube1/screens/hashtag_list_screen.dart';
import 'package:youtube1/screens/user_screen.dart';
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
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryVariant,
                image: new DecorationImage(image: new ExactAssetImage('resources/images/vid-quest-logo.png'), scale: 4),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              //radius: 35,
                backgroundImage: AssetImage('resources/images/tv.png',)
            ),//Icon(Icons.group_outlined),
            title: Text("Profile"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserScreen()),
              );
            },
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Image(image: AssetImage('resources/images/home.png'), height: 30,), // Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              print("Home 2 Clicked");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Image(image: AssetImage('resources/images/game-controller-small.png'), height: 30,), //Icon(Icons.play_arrow_outlined),
            title: Text("Play Random Vids"),
            onTap: () {
              print("Play Random Vids Clicked");
              APIService.instance.fetchRandomVideo().then((video){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoScreen(video))
                //Navigator.push(
                //  context,
                //  MaterialPageRoute(builder: (context) => VideoScreen(video)),
                );
              });
            },
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Image(image: AssetImage('resources/images/hashtag.png'), height: 30,), //Icon(Icons.featured_play_list_outlined),
            title: Text("Play a Hashtag List"),
            onTap: () {
              print("Play a Hashtag List Clicked");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HashtagListScreen()),
              );
            },
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Image(image: AssetImage('resources/images/two-game-controllers-small.png'), height: 30,), //Icon(Icons.group_outlined),
            title: Text("Challenges"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChallengesScreen()),
              );
            },
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Image(image: AssetImage('resources/images/group-small.png'), height: 30,), //Icon(Icons.group_outlined),
            title: Text("Play a Group Game"),
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
                        child: Column(
                          children: [
                            Padding(
                              padding:EdgeInsets.all(20),
                              child:
                              Text(
                                'We are still in beta version.',
                                style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left:20, right:20,bottom: 20),
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
                          ]
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
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}

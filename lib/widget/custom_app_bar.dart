import 'package:flutter/material.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube1/screens/login_screen.dart';
import 'package:youtube1/screens/user_screen.dart';
import 'package:youtube1/screens/add_videos_screen.dart';
import 'package:youtube1/screens/add_videos_initial_screen.dart';
import 'package:countup/countup.dart';

class CustomAppBar extends StatefulWidget  implements PreferredSizeWidget {
  String barTitle;
  CustomAppBar({Key key, String title})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        barTitle = title,
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override CustomAppBarState createState() => CustomAppBarState();

}

List<PopupMenuEntry<Object>> getPopupMenuItems(){
  List<PopupMenuEntry<Object>> popupItems = [
    PopupMenuItem(
      value: 'Profile',
      child: Text('Profile'),
    ),
    PopupMenuDivider(
      height: 20,
    ),
  ];
  if(sharedPrefs.userrole == 'admin'){
    popupItems.add(PopupMenuItem(
      value: 'Add Video',
      child:Text('Add Video'),
    ));
    popupItems.add(PopupMenuDivider(
      height: 20,
    ));
  }
  popupItems.add(PopupMenuItem(
      value: 'Log out',
      child: Text("Log Out"),
    )
  );
  return popupItems;
}

class CustomAppBarState extends State<CustomAppBar>{
  int oldUserScore;
  int userScore;
  @override
  void initState() {
    super.initState();
    userScore = sharedPrefs.userscore;
    oldUserScore = sharedPrefs.userscore;
  }

  setScore(score){
    oldUserScore = score;
    userScore = score;
  }

  @override
  PreferredSizeWidget build(BuildContext context){
    oldUserScore = userScore;
    userScore = sharedPrefs.userscore;
    return AppBar(
      title: Text('${widget.barTitle}'),
      actions: <Widget>[
        Countup(
          begin: oldUserScore.toDouble(),
          end: userScore.toDouble(),
          duration: Duration(seconds: 1),
          separator: ',',
          style: TextStyle(
            fontSize: 36,
          ),
        ),
        PopupMenuButton<Object>(
          icon: CircleAvatar(
              backgroundImage: AssetImage('resources/images/tv.png')
          ),
          onSelected: (result) async {
            if(result == 'Profile') {
              print(sharedPrefs.username);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => UserScreen(),
                ),
              );
            }
            else if(result == 'Log out'){
              print('Log out');
              http.Response response = await APIService.instance.logoutUser();
              sharedPrefs.isloggedin = false;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
              );
            }
            else if(result == 'Add Video'){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AddVideosInitialScreen(),
                ),
              );
            }
          },
          itemBuilder: (context) => getPopupMenuItems()
        ),
      ],
    );
  }

}

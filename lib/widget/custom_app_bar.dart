import 'package:flutter/material.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube1/screens/login.page.dart';
import 'package:youtube1/screens/add_videos_screen.dart';
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

List<PopupMenuEntry<String>> getPopupMenuItems(){
  List<PopupMenuEntry<String>> popupItems = [
    PopupMenuItem(
      value: sharedPrefs.username,
      child: Text(sharedPrefs.username),
    ),
    PopupMenuItem(
      value: 'Log out',
      child: Text("Log Out"),
    ),
  ];
  if(sharedPrefs.userrole == 'admin'){
    popupItems.add(PopupMenuItem(
      value: 'Add Videos',
      child:Text(sharedPrefs.userrole),
    ));
  }
  return popupItems;
}

class CustomAppBarState extends State<CustomAppBar>{
  int oldUserScore;
  int userScore;
  @override
  void initState() {
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
        PopupMenuButton<String>(
          icon: CircleAvatar(
              backgroundImage: AssetImage('resources/images/tv-64.jpg')
          ),
          onSelected: (result) async {
            if(result == sharedPrefs.username)
              print(sharedPrefs.username);
            else if(result == 'Log out'){
              print('Log out');
              http.Response response = await APIService.instance.logoutUser();
              sharedPrefs.isloggedin = false;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
              );
            }
            else if(result == 'Add Videos'){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddVideosScreen(),
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

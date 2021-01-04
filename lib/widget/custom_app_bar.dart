import 'package:flutter/material.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube1/screens/login.page.dart';
import 'package:youtube1/screens/add_videos_screen.dart';

class CustomAppBar extends StatefulWidget  implements PreferredSizeWidget {
  String barTitle;
  CustomAppBar({Key key, String title})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        barTitle = title,
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

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

class _CustomAppBarState extends State<CustomAppBar>{
  @override
  PreferredSizeWidget build(BuildContext context){
    return AppBar(
      title: Text('${widget.barTitle}'),
      actions: <Widget>[
        PopupMenuButton<String>(
          icon: CircleAvatar(
              backgroundImage: NetworkImage('https://www.woolha.com/media/2020/03/eevee.png')
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

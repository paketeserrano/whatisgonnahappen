import 'package:flutter/material.dart';
import 'package:youtube1/models/playlist_model.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/screens/playlist_screen.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/widget/appDrawer.dart';
import 'package:youtube1/widget/custom_app_bar.dart';
import 'package:youtube1/screens/video_screen.dart';

class HashtagListScreen extends StatefulWidget {
  @override
  _HashtagListScreenState createState() => _HashtagListScreenState();
}

class _HashtagListScreenState extends State<HashtagListScreen> {
  List<Playlist> _playlists = List<Playlist>();
  bool _isLoading = false;
  final GlobalKey<CustomAppBarState> customBarStateKey = GlobalKey<CustomAppBarState>();
  var _nextVideo;
  ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _initHashtagList();
  }

  _initHashtagList() async {
    var playlists = await APIService.instance
        .fetchPlaylists();
    APIService.instance.fetchRandomVideo().then((video){
      _nextVideo = VideoScreen(video);
    });

    setState(() {
      _playlists = playlists;
    });
  }

  _buildPlaylist(Playlist playlist) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _nextVideo),
      ).then((value) {customBarStateKey.currentState.setScore(sharedPrefs.userscore); setState(() {});}),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: _theme.colorScheme.secondary,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage('https://icon-icons.com/icons2/800/PNG/64/_hashtag_icon-icons.com_65804.png'),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                playlist.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar(key: customBarStateKey, title: 'Select a playlist'),
      body: ListView.builder(
        itemCount: _playlists.length,
        itemBuilder: (BuildContext context, int index) {
          print('index channel screen: $index');
          print('playlist length: ${_playlists.length}');
          Playlist playlist = _playlists[index];
          return _buildPlaylist(playlist);
        },
      ),
    );
  }
}
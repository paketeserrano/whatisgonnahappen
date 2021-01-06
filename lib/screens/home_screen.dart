import 'package:flutter/material.dart';
import 'package:youtube1/models/channel_model.dart';
import 'package:youtube1/models/playlist_model.dart';
import 'package:youtube1/screens/playlist_screen.dart';
import 'package:youtube1/services/api_service.dart';
import 'package:youtube1/widget/appDrawer.dart';
import 'package:youtube1/widget/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Playlist> _playlists = List<Playlist>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initHome();
  }

  _initHome() async {
    var playlists = await APIService.instance
        .fetchPlaylists();

    print('<------------>');
    print(playlists);
    print(playlists.length);
    print('<------------>');

    setState(() {
      print('----------- In the set state function');
      _playlists = playlists;
    });
  }

  _buildPlaylist(Playlist playlist) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlaylistScreen(playlist),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Colors.white,
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
                  fontSize: 18.0,
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
    return Scaffold(
      drawer: AppDrawer(),
      appBar: CustomAppBar(title: 'Select a playlist'),
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
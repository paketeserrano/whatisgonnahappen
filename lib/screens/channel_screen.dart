import 'package:flutter/material.dart';
import 'package:youtube1/models/channel_model.dart';
import 'package:youtube1/models/playlist_model.dart';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/screens/playlist_screen.dart';
import 'package:youtube1/services/api_service.dart';

class ChannelScreen extends StatefulWidget {
  final Channel channel;
  ChannelScreen(this.channel);

  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  List<Playlist> _playlists = List<Playlist>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    var playlists = await APIService.instance
        .fetchChannelPlaylists(channel:widget.channel);

    print('<------------>');
    print(playlists);
    print(playlists.length);
    print('<------------>');
    setState(() {
      print('----------- In the set state function of channel screen');
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
              image: NetworkImage(playlist.profilePictureUrl),
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
      appBar: AppBar(
        title: Text(widget.channel.title),
      ),
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
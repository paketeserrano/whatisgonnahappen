import 'package:flutter/material.dart';
import 'package:youtube1/models/channel_model.dart';
import 'package:youtube1/models/playlist_model.dart';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/screens/video_screen.dart';
import 'package:youtube1/services/api_service.dart';

class PlaylistScreen extends StatefulWidget {
  Playlist playlist;
  PlaylistScreen(this.playlist);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Playlist _playlist;
  List<Video> _videos = List<Video>();

  @override
  void initState() {
    super.initState();
    _initPlaylist();
  }

  _initPlaylist() async {

    List<Video> videos = await APIService.instance
        .fetchPlaylistVideos(playlist:widget.playlist);

    setState(() {
      print('----------- In the set playlist screen state function');
      _videos = videos;
      _playlist = widget.playlist;
    });
  }

  _buildProfileInfo() {
    return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        height: 200.0,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 35.0,
                  backgroundImage: NetworkImage(_playlist.profilePictureUrl),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _playlist.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        )
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(video),
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
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.name,
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
        title: Text('YouTube Channel'),
      ),
      body: ListView.builder(
          itemCount: 1 + _videos.length,
          itemBuilder: (BuildContext context, int index) {
            print('index: $index');
            if (index == 0) {
              return _buildProfileInfo();
            }
            Video video = _videos[index - 1];
            return _buildVideo(video);
          },
        ),
    );
  }
}
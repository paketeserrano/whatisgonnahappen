import 'package:youtube1/models/video_model.dart';

class Channel {

  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final String videoCount;
  List<Video> videos;
  Map<String,String> playlistsInfo;
  List<String> playlistNames = [];
  String selectedPlaylistName;
  String selectedPlaylistId;

  Channel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.videos,
    this.playlistsInfo,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      videoCount: map['statistics']['videoCount'],
    );
  }

  void setSelectedPlaylist(String playlistName){
    selectedPlaylistName = playlistName;
    selectedPlaylistId = playlistsInfo[selectedPlaylistName];
  }

  void set setPlaylistsInfo(Map<String,String> playlists){
    print("In the playlistInfoSetter");
    playlistsInfo = playlists;

    playlistsInfo.forEach((k,v){
      playlistNames.add(k);
    });

    selectedPlaylistName = playlistNames[0];
    selectedPlaylistId = playlistsInfo[selectedPlaylistName];
  }



}
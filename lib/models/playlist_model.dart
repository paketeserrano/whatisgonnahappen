
class Playlist {

  String id;
  String youtubeId;
  String channelId;
  String title;
  String profilePictureUrl;
  int itemCount;

  Playlist({
    this.id,
    this.youtubeId,
    this.channelId,
    this.title,
    this.profilePictureUrl,
    this.itemCount,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'],
      youtubeId: map['id'],
      channelId: map['snippet']['channelId'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      itemCount: map['contentDetails']['itemCount'],
    );
  }

}

class Playlist {

  final String id;
  final String channelId;
  final String title;
  final String profilePictureUrl;
  final int itemCount;

  Playlist({
    this.id,
    this.channelId,
    this.title,
    this.profilePictureUrl,
    this.itemCount,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'],
      channelId: map['snippet']['channelId'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      itemCount: map['contentDetails']['itemCount'],
    );
  }

}
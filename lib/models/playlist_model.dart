
class Playlist {

  String id;
  String title;
  bool published;

  Playlist({
    this.id,
    this.title,
    this.published,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'].toString(),
      title: map['name'],
      published: map['published']
    );
  }

}
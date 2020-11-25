import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:youtube1/models/channel_model.dart';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/utilities/keys.dart';
import 'package:youtube1/models/playlist_model.dart';
import 'package:flutter/services.dart' show rootBundle;


class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';
  String _nextPlaylistPageToken = '';

  Future<Map<String,String>> fetchPlaylistsInfo() async {
    List<Playlist> playlists = [];

    var playlistStrInfo = await rootBundle.loadString(
        'resources/laliga-2020-resumenes');
    Map playlistInfo = new Map<String, String>();
    LineSplitter.split(playlistStrInfo).forEach((line) {
      playlistInfo[line.split(',')[0]] = line.split(',')[1];
    });
    print("---------------- $playlistInfo");

    return playlistInfo;
  }

  // Not going this route because there are more than 1000 playlists
  Future<List<Playlist>> fetchChannelPlaylists({String channelId}) async {
    List<Playlist> playlists = [];
    for (var numPages = 0; numPages < 4; numPages++) {
      Map<String, String> parameters = {
        'part': 'snippet, contentDetails',
        'channelId': channelId,
        'key': API_KEY,
        'maxResults': '100',
        'pageToken': _nextPlaylistPageToken,
      };

      Uri uri = Uri.https(
        _baseUrl,
        '/youtube/v3/playlists',
        parameters,
      );

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };

      // Get Channel
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        var playlistResponse = json.decode(response.body);
        List<dynamic> playlistsJson = playlistResponse['items'];
        _nextPlaylistPageToken = playlistResponse['nextPageToken'] ?? '';
        print('**********************************');
        print(_nextPlaylistPageToken);

        playlistsJson.forEach((playlistJson) {
          print(playlistJson['snippet']['title']);
          if (playlistJson['snippet']['title']
                  .contains('LaLiga Santander Highlights Matchday') &&
              playlistJson['snippet']['title'].contains('2020/2021')) {
            print(playlistJson['snippet']['title']);
            playlists.add(Playlist.fromMap(playlistJson));
          }
        });
      } else {
        throw json.decode(response.body)['error']['message'];
      }
    }
    return playlists;
  }

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      channel.setPlaylistsInfo = await fetchPlaylistsInfo();

      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.selectedPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          Video.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

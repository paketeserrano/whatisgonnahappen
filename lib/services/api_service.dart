import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:youtube1/models/channel_model.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/utilities/keys.dart';
import 'package:youtube1/models/playlist_model.dart';
import 'package:flutter/services.dart' show rootBundle;


class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseYoutubeUrl = 'www.googleapis.com';
  final String _baseSoccerFansUrl = '127.0.0.1:5000';
  String _nextPageToken = '';
  String _nextPlaylistPageToken = '';

  Future<List<Channel>> fetchChannel() async {
    // Get the channels from database

    Uri sfUri = Uri.http(
        _baseSoccerFansUrl,
        '/getChannels'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channels (Tournaments, like La Liga)
    // Important: In command line execute 'adb reverse tcp:5000 tcp:5000' so flask and flutter app endpoints can connect
    var response = await http.get(sfUri, headers: headers);
    List<dynamic> channelsInfo;

    if (response.statusCode == 200) {
      channelsInfo = json.decode(response.body)['channels'];
      print(channelsInfo);
      print('[[[[[[[[[[[[[[[[[[[[[');
    } else {
      throw json.decode(response.body)['error']['message'];
    }

    List<Channel> channels = List<Channel>();
    for(dynamic channelInfo in channelsInfo){
      Map<String, String> parameters = {
        'part': 'snippet, contentDetails, statistics',
        'id': channelInfo['youtube_id'],
        'key': API_KEY,
      };
      Uri uri = Uri.https(
        _baseYoutubeUrl,
        '/youtube/v3/channels',
        parameters,
      );

      // Get Channel
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body)['items'][0];
        Channel channel = Channel.fromMap(data);
        for(var index=0; index < channelsInfo.length; index++){
          if(channelsInfo[index]['youtube_id'] == channel.id){
            channel.id = channelsInfo[index]['id'].toString();
          }
        }
        channels.add(channel);
      } else {
        throw json.decode(response.body)['error']['message'];
      }
    }
    return channels;
  }

  Future<List<Playlist>> fetchChannelPlaylists({Channel channel}) async {
    List<Playlist> playlists = [];

    Map<String, String> parameters = {
      'chid': channel.id,
    };

    Uri sfUri = Uri.http(
        _baseSoccerFansUrl,
        '/getPlaylists',
        parameters
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channels (Tournaments, like La Liga)
    // Important: In command line execute 'adb reverse tcp:5000 tcp:5000' so flask and flutter app endpoints can connect
    var response = await http.get(sfUri, headers: headers);
    List<dynamic> playlistsInfo;

    if (response.statusCode == 200) {
      playlistsInfo = json.decode(response.body)['playlists'];
      print(playlistsInfo);
      print('[[[[[[[[[[[[[[[[[[[[[');
      print(playlistsInfo.length);
      print('[[[[[[[[[[[[[[[[[[[[[');
    } else {
      print(response.body);
      throw json.decode(response.body)['error']['message'];
    }

    String playlistIds = '';
    playlistsInfo.forEach((playlistInfo) {playlistIds = playlistIds + playlistInfo['youtube_id'] + ',';});

    parameters = {
      'part': 'snippet, contentDetails',
      'id': playlistIds,
      'key': API_KEY,
      'maxResults': '100',
      'pageToken': _nextPlaylistPageToken,
    };

    Uri uri = Uri.https(
      _baseYoutubeUrl,
      '/youtube/v3/playlists',
      parameters,
    );

    // Get Channel
    response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var playlistResponse = json.decode(response.body);
      List<dynamic> playlistsJson = playlistResponse['items'];

      playlistsJson.forEach((playlistJson) {
        print(playlistJson['snippet']['title']);
        Playlist playlist = Playlist.fromMap(playlistJson);
        for(var index = 0; index < playlistsInfo.length; index++) {
          var playlistInfoYoutubeId = playlistsInfo[index]['youtube_id'];
          if (playlistInfoYoutubeId == playlist.id) {
            playlist.title = playlistsInfo[index]['name'];
            playlist.channelId = playlistsInfo[index]['channel_id'].toString();
            playlist.id = playlistsInfo[index]['id'].toString();
          }
        }
        playlists.add(playlist);
      });
    } else {
      throw json.decode(response.body)['error']['message'];
    }
    return playlists;
  }

  Future<List<Video>> fetchPlaylistVideos({Playlist playlist}) async {
    List<Video> videos = [];

    Map<String, String> parameters = {
      'plid': playlist.id,
    };

    Uri sfUri = Uri.http(
        _baseSoccerFansUrl,
        '/getVideos',
        parameters
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlists (Videos with a same theme, like highlights of round 3)
    // Important: In command line execute 'adb reverse tcp:5000 tcp:5000' so flask and flutter app endpoints can connect
    var response = await http.get(sfUri, headers: headers);
    List<dynamic> videosInfo;

    if (response.statusCode == 200) {
      videosInfo = json.decode(response.body)['videos'];
      //print('[[[[[[[[[[[[[[[[[[[[[');
      //print(videosInfo);
      //print('[[[[[[[[[[[[[[[[[[[[[');
      videosInfo.forEach((videoInfo) {
        Video video = Video.fromMap(videoInfo);
        videos.add(video);
      });
    } else {
      throw json.decode(response.body)['error']['message'];
    }

    print("---------- videos ----------------");
    print(videos);
    print("----------------------------------");

    // Compile video ids from videos that needs more info from youtube
    Map<String,Video> incompleteVideos = Map<String,Video>();
    videos.forEach((video) {
      if(video.thumbnailUrl == null)
        incompleteVideos[video.youtubeId] = video;
    });

    String videoIds = "";
    for(String youtubeId in incompleteVideos.keys){
      videoIds += youtubeId + ',';
    }
    print('============== videoIds: $videoIds');
    if(incompleteVideos.isNotEmpty) {

      parameters = {
        'part': 'snippet',
        'id': videoIds,
        'pageToken': _nextPageToken,
        'key': API_KEY,
      };

      Uri uri = Uri.https(
        _baseYoutubeUrl,
        '/youtube/v3/videos',
        parameters,
      );

      Map<String, String> headers = {
        'cookie': sharedPrefs.usersessiontoken,
        HttpHeaders.contentTypeHeader: 'application/json',
      };

      // Get Playlist Videos
      response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List<dynamic> videosJson = data['items'];
        print("videosJson.length: ${videosJson.length}");
        //Add any missing property. This should only happen with new videos added and they should lack any info from youtube that we use
        videosJson.forEach((videoJson) {
          // thumbnailUrl is the only missing property from the database (for now) after adding a new video.
          print("++++++++++++++++++++++++++++++");
          print("youtubeId: ${videoJson['id']}");
          print("thumbnail: ${videoJson['snippet']['thumbnails']['high']['url']}");
          incompleteVideos[videoJson['id']].thumbnailUrl =  videoJson['snippet']['thumbnails']['high']['url'];
        });

        List<Video> videosToPost = List<Video>();
        incompleteVideos.forEach((key, video) { videosToPost.add(video);});
        sfUri = Uri.http(
            _baseSoccerFansUrl,
            '/updateVideos'
        );

        var videosToPostStr = json.encode(videosToPost);
        parameters = {
          'videos': videosToPostStr,
        };

        response = await http.post(sfUri,headers: headers,body: jsonEncode(parameters));

      } else {
        throw json.decode(response.body)['error']['message'];
      }
    }

    return videos;
  }

  void postQuestionResponse(String useremail, int questionId, int answerId) async {
    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Map<String, String> parameters = {
      'questionId' : questionId.toString(),
      'answerId' : answerId.toString(),
    };

    Uri sfUri = Uri.http(
        _baseSoccerFansUrl,
        '/postQuestionResponse'
    );

    final http.Response response = await http.post(sfUri,headers: headers,body: jsonEncode(parameters));
    print('Response-----: ${response.statusCode}');
  }

  void addVideo(Map<String,dynamic> video) async {
    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri sfUri = Uri.http(
        _baseSoccerFansUrl,
        '/addVideo'
    );

    final http.Response response = await http.post(sfUri,headers: headers,body: jsonEncode(video));
  }

  Future<http.Response> loginUser(String email, String password) async {
    var sfUri = Uri.http(
        '127.0.0.1:5000',
        '/login'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var parameters = {
      'email': email,
      'password': password,
    };

    http.Response response = await http.post(sfUri,headers: headers,body: jsonEncode(parameters));
    return response;
  }

  Future<http.Response> logoutUser() async {

      Uri sfUri = Uri.http(
          _baseSoccerFansUrl,
          '/logout'
      );

      Map<String, String> headers = {
        'cookie': sharedPrefs.usersessiontoken,
        HttpHeaders.contentTypeHeader: 'application/json',
      };

      print('-----------> ${sharedPrefs.usersessiontoken}');

      // Logout the user from flask session
      http.Response response = await http.get(sfUri, headers: headers);
      return response;
  }

  Future<http.Response> registerUser(String name, String email, String password) async {
    var sfUri = Uri.http(
        '127.0.0.1:5000',
        '/register'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var parameters = {
      'name': name,
      'email': email,
      'password': password,
    };

    http.Response response = await http.post(sfUri,headers: headers,body: jsonEncode(parameters));

    return response;
  }
}

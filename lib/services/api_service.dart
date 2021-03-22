import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:youtube1/models/channel_model.dart';
import 'package:youtube1/models/most_points_challenge.dart';
import 'package:youtube1/models/shared_preferences.dart';
import 'package:youtube1/models/user.dart';
import 'package:youtube1/models/video_model.dart';
import 'package:youtube1/utilities/keys.dart';
import 'package:youtube1/models/playlist_model.dart';
import 'package:flutter/services.dart' show rootBundle;


class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseYoutubeUrl = 'www.googleapis.com';
  final String _serverUrl = '192.168.1.233:5000';//'127.0.0.1:5000'; //'192.168.1.233:5000'; Use the commented address when testing at home with real phone- Use home ip address
  String _nextPageToken = '';
  String _nextPlaylistPageToken = '';

  Future<List<Channel>> fetchChannel() async {
    // Get the channels from database

    Uri sfUri = Uri.http(
        _serverUrl,
        '/getChannels'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channels (Tournaments, like La Liga)
    // Important: In command line execute 'adb reverse tcp:5000 tcp:5000' so flask and flutter app endpoints can connect
    // For a real phone adb -s 9b6ea4eb reverse tcp:5000 tcp:5000 where 9b6ea4eb is the device id listed in adb devices
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

  Future<List<Playlist>> fetchPlaylists() async {
    List<Playlist> playlists = [];

    Map<String, String> parameters = {
      'plid': '-1',
    };

    Uri sfUri = Uri.http(
        _serverUrl,
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

    playlistsInfo.forEach((playlistInfo) {
      Playlist playlist = Playlist.fromMap(playlistInfo);
      playlists.add(playlist);
    });

    return playlists;
  }

  Future<Video> fetchRandomVideo() async {
    Uri sfUri = Uri.http(
        _serverUrl,
        '/getRandomVideo'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var video;
    var response = await http.get(sfUri, headers: headers);
    if (response.statusCode == 200) {
      var videoInfo = json.decode(response.body)['video'];
      video = Video.fromMap(videoInfo);
      print("---------------------------");
      print(videoInfo);
      print("---------------------------");
    } else {
      throw json.decode(response.body)['error']['message'];
    }

    return video;
  }

  Future<Map<String, int>> getUserStats() async {
    Uri sfUri = Uri.http(
        _serverUrl,
        '/getUserStats'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Map<String, int> stats = Map<String,int>();
    var response = await http.get(sfUri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> statsResponse = json.decode(response.body)['stats'];
      stats['num_questions_answered'] = statsResponse['num_questions_answered'];
      stats['num_right_responses'] = statsResponse['num_right_responses'];
      stats['num_challenges_won'] = statsResponse['num_challenges_won'];
    }
    else{
      stats['num_questions_answered'] = 0;
      stats['num_right_responses'] = 0;
    }
    return stats;
  }

  Future<List<Video>> fetchPlaylistVideos({Playlist playlist}) async {
    List<Video> videos = [];

    Map<String, String> parameters = {
      'plid': playlist.id,
    };

    Uri sfUri = Uri.http(
        _serverUrl,
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
            _serverUrl,
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

  Future<int> postQuestionResponse(String useremail, int questionId, int answerId) async {
    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Map<String, String> parameters = {
      'questionId' : questionId.toString(),
      'answerId' : answerId.toString(),
    };

    Uri sfUri = Uri.http(
        _serverUrl,
        '/postQuestionResponse'
    );

    final http.Response response = await http.post(sfUri,headers: headers,body: jsonEncode(parameters));
    var userScore = sharedPrefs.userscore;
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      var responseStatus = int.parse(responseBody['status']);
      print("responseStatus: $responseStatus");
      if(responseStatus == 200){
        print("Response score:  ${responseBody['score']}");
        return responseBody['score'];
      }
    }
    return userScore;
  }

  Future<http.Response> addVideo(Map<String,dynamic> video) async {
    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri sfUri = Uri.http(
        _serverUrl,
        '/addVideo'
    );

    final http.Response response = await http.post(sfUri,headers: headers,body: jsonEncode(video));
    return response;
  }

  void likeQuestion(int questionId) async {
    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri sfUri = Uri.http(
        _serverUrl,
        '/likeQuestion'
    );

    Map<String,dynamic> payload = Map<String,dynamic>();
    payload['id'] = questionId;
    payload['type'] = 'like';

    final http.Response response = await http.post(sfUri,headers: headers,body: jsonEncode(payload));
  }

  void noLikeQuestion(int questionId) async {
    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri sfUri = Uri.http(
        _serverUrl,
        '/likeQuestion'
    );

    Map<String,dynamic> payload = Map<String,dynamic>();
    payload['id'] = questionId;
    payload['type'] = 'no_like';

    final http.Response response = await http.post(sfUri,headers: headers,body: jsonEncode(payload));
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
          _serverUrl,
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

  Future<http.Response> createMostPointsChallenge(String challengedUserName, int hours) async {
    var sfUri = Uri.http(
        '127.0.0.1:5000',
        '/createMostPointsChallenge'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var parameters = {
      'challenger_username': sharedPrefs.username,
      'challenged_username': challengedUserName,
      'challenge_duration_in_hours': hours,
    };

    Future<http.Response> response = http.post(sfUri,headers: headers,body: jsonEncode(parameters));
    return response;

  }

  Future<http.Response> setMostPointsChallengeState(MostPointChallenge challenge) async {
    var sfUri = Uri.http(
        '127.0.0.1:5000',
        '/setMostPointsChallengeState'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Future<http.Response> response = http.post(sfUri,headers: headers,body: jsonEncode(challenge.toJson()));
    return response;
  }

  Future< List<MostPointChallenge> > getUserActiveMostPointChallenges() async {
    Map<String, String> parameters = {
      'usr': sharedPrefs.username,
    };

    Uri sfUri = Uri.http(
        _serverUrl,
        '/getUserActiveMostPointChallenges',
        parameters
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(sfUri, headers: headers);

    if (response.statusCode == 200) {
      List challengesJson = json.decode(response.body)['challenges'];
      List<MostPointChallenge> challenges = new List<MostPointChallenge>();
      challengesJson.forEach((challengeJson) {
        MostPointChallenge challenge = MostPointChallenge.fromMap(challengeJson);
        challenges.add(challenge);
      });

      return challenges;
    } else {
      print('-----------------> Exception thrown');
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future< List<MostPointChallenge> > getUserCompletedMostPointChallenges() async {
    Map<String, String> parameters = {
      'usr': sharedPrefs.username,
    };

    Uri sfUri = Uri.http(
        _serverUrl,
        '/getUserCompletedMostPointChallenges',
        parameters
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(sfUri, headers: headers);

    if (response.statusCode == 200) {
      List challengesJson = json.decode(response.body)['challenges'];
      List<MostPointChallenge> challenges = new List<MostPointChallenge>();
      challengesJson.forEach((challengeJson) {
        MostPointChallenge challenge = MostPointChallenge.fromMap(challengeJson);
        challenges.add(challenge);
      });

      return challenges;
    } else {
      print('-----------------> Exception thrown');
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<http.Response> acceptMostPointsChallenge(MostPointChallenge challenge) async {
    var sfUri = Uri.http(
        '127.0.0.1:5000',
        '/acceptMostPointsChallenge'
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Future<http.Response> response = http.post(sfUri,headers: headers,body: jsonEncode(challenge.toJson()));
    return response;

  }

  Future< List<String>> usernameSuggestions(String pattern) async {
    Map<String, String> parameters = {
      'pattern': pattern,
    };

    Uri sfUri = Uri.http(
        _serverUrl,
        '/getUsernameSuggestions',
        parameters
    );

    Map<String, String> headers = {
      'cookie': sharedPrefs.usersessiontoken,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(sfUri, headers: headers);

    if (response.statusCode == 200) {
      List usernamesJson = json.decode(response.body)['usernames'];
      List<String> usernames = new List<String>();
      usernamesJson.forEach((usernameJson) {
        User user = User.fromMap(usernameJson);
        usernames.add(user.username);
      });
      print('--------> usernames: $usernames');
      return usernames;
    } else {
      print('-----------------> Exception thrown');
      throw json.decode(response.body)['error']['message'];
    }
  }


}

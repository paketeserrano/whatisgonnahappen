import 'dart:collection';
import 'package:youtube1/models/question_model.dart';
import 'dart:math';

class Video {
  int id;
  String youtubeId;
  String name;
  bool published;
  String thumbnailUrl;
  List<Question> questions;
  String channelId;

  Video({
    this.id,
    this.name,
    this.published,
    this.questions,
    this.youtubeId,
    this.thumbnailUrl,
    this.channelId,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    print("*****************************");
    print(map);
    print("*****************************");

    return Video(
      id: map['id'],
      name: map['name'],
      published: map['published'],
      questions: createQuestions(map['questions']),
      youtubeId: map['youtube_id'],
      thumbnailUrl: null,
      channelId: map['channel_id']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': this.id.toString(),
      'name': this.name,
      'youtubeId': this.youtubeId,
      'published': this.published.toString(),
      'thumbnail': this.thumbnailUrl,
      'channel_id': this.channelId,
    };
  }

  static List<Question> createQuestions(List<dynamic> questionsJson){
    List<Question> questions = List<Question>();
    for(dynamic questionJson in questionsJson){
      questions.add(Question.fromMap(questionJson));
    }
    return questions;
  }
}
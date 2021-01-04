import 'dart:collection';
import 'package:youtube1/models/question_model.dart';
import 'dart:math';

class Video {
  int id;
  String youtubeId;
  String name;
  bool published;
  String thumbnailUrl;
  SplayTreeMap<int,Question> questions;

  Video({
    this.id,
    this.name,
    this.published,
    this.questions,
    this.youtubeId,
    this.thumbnailUrl,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      name: map['name'],
      published: map['published'],
      questions: createQuestions(map['questions']),
      youtubeId: map['youtube_id'],
      thumbnailUrl: null,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': this.id.toString(),
      'name': this.name,
      'youtubeId': this.youtubeId,
      'published': this.published.toString(),
      'thumbnail': this.thumbnailUrl,
    };
  }

  static SplayTreeMap<int,Question> createQuestions(List<dynamic> questionsJson){
    SplayTreeMap<int,Question> questions = SplayTreeMap<int,Question>();
    for(dynamic questionJson in questionsJson){
      questions[questionJson['time_to_show']] = Question.fromMap(questionJson);
    }
    return questions;
  }
}
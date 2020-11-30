import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:youtube1/models/question_model.dart';
import 'dart:math';

class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  LinkedHashMap<int,Question> questions;

  LinkedHashMap<int,Question> createRandomQuestions(){
    var rng = new Random();
    LinkedHashMap<int,Question> randomQuestions = LinkedHashMap<int,Question>();
    var numQuestions = rng.nextInt(5) + 1;
    for(var index = 0; index < numQuestions; index++){
      var stopInSeconds = rng.nextInt(10) + 1 + index*10;
      randomQuestions[stopInSeconds] = Question();
    }
    return randomQuestions;
  }

  Video({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  });

  Video.random(this.id,this.title, this.thumbnailUrl, this.channelTitle){
    this.questions = this.createRandomQuestions();
  }

  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video.random(
      snippet['resourceId']['videoId'],
      snippet['title'],
      snippet['thumbnails']['high']['url'],
      snippet['channelTitle'],
    );
  }
}
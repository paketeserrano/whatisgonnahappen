
class Question{
  int id;
  int videoId;
  int officialAnswerId;
  String statement;
  int timeToShow;
  int timeToStop;
  int timeToStart;
  int timeToEnd;
  List<dynamic> answers;

  Question({
    this.id,
    this.videoId,
    this.officialAnswerId,
    this.statement,
    this.timeToShow,
    this.timeToStop,
    this.timeToEnd,
    this.timeToStart,
    this.answers,
});

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      videoId: map['video_id'],
      officialAnswerId: map['official_answer_id'],
      statement: map['statement'],
      timeToShow: map['time_to_show'],
      timeToStop: map['time_to_stop'],
      timeToStart: map['time_to_start'],
      timeToEnd: map['time_to_end'],
      answers: map['answers'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': this.id.toString(),
      'videoId': this.videoId,
      'officialAnswerId': officialAnswerId.toString(),
      'statement': this.statement,
      'timeToShow': this.timeToShow.toString(),
      'timeToStop': this.timeToStop.toString(),
      'timeToStart': this.timeToStart.toString(),
      'timeToEnd': this.timeToEnd.toString(),
      'answers': answers,
    };
  }
}
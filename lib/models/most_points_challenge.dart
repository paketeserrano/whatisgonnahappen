import 'package:youtube1/models/user.dart';
import 'dart:core';
import 'package:intl/intl.dart';

class MostPointChallenge{
  int id;
  User challenger;
  User challenged;
  int challengerPoints;
  int challengedPoints;
  DateTime startTime;
  DateTime endTime;
  String state;

  MostPointChallenge({
    this.id,
    this.challenger,
    this.challenged,
    this.challengerPoints,
    this.challengedPoints,
    this.startTime,
    this.endTime,
    this.state
  });

  factory MostPointChallenge.fromMap(Map<String, dynamic> map) {
    print("-------------------");
    print(map);
    print("-------------------");
    print("MostPointChallenge.fromMap");
    var startTime = map['start_time'] != null ? DateTime.parse(map['start_time']) : null;
    var endTime = map['end_time'] != null ? DateTime.parse(map['end_time']) : null;
    print("startTime:  $startTime");
    print("endTime:  $endTime");
    return MostPointChallenge(
      id: map['id'],
      challenger: User.fromMap(map['challenger']),
      challenged: User.fromMap(map['challenged']),
      challengerPoints: map['challenger_points'],
      challengedPoints: map['challenged_points'],
      startTime: startTime,
      endTime: endTime,
      state: map['state']
    );
  }

  Map<String, dynamic> toJson() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': this.id,
      'challenger': this.challenger.toJson(),
      'challenged': this.challenged.toJson(),
      'challenger_points': this.challengerPoints,
      'challenged_points': this.challengedPoints,
      'start_time': this.startTime == null ? null : formatter.format(this.startTime),
      'end_time': this.endTime == null ? this.endTime : formatter.format(this.endTime),
      'state': this.state
    };
  }

}
import 'package:english_words/english_words.dart';
class Question{
  int id;
  String question;
  List<String> answers;

  Question(){
    this.id = 1;
    this.question = "";
    answers = List<String>();
    nouns.take(10).forEach((element) {this.question += element;});
    adjectives.take(3).forEach((element) {this.answers.add(element);});
  }
}
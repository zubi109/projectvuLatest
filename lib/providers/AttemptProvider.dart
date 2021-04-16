import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:projectvu/models/answer.dart';
import 'package:projectvu/models/attempt.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttemptProvider with ChangeNotifier {

  List<Question> _questions = [];
  List<Answer> _answers = [];
  Quiz _quiz;
  Attempt _attempt;
  bool _attemptQuizLoading = false;
  int _counter = 0;

  List<Question> get Questions => _questions;
  set Questions(List<Question> data) {
    this._questions = data;
    notifyListeners();
  }

  List<Answer> get Answers => _answers;
  set Answers(List<Answer> data) {
    this._answers = data;
    notifyListeners();
  }

  Quiz get quiz => _quiz;
  set quiz(Quiz data) {
    this._quiz = data;
    notifyListeners();
  }

  Attempt get attempt => _attempt;
  set attempt(Attempt data) {
    this._attempt = data;
    notifyListeners();
  }

  bool get AttemptQuizLoading => _attemptQuizLoading;
  set AttemptQuizLoading(bool data) {
    this._attemptQuizLoading = data;
    notifyListeners();
  }

  int get Counter => _counter;
  set Counter(int data) {
    this._counter = data;
    notifyListeners();
  }

  void getQuestions() async{
    var snap = await FirebaseFirestore.instance
        .collection("Questions")
        .where('QuizId', isEqualTo: quiz.Id)
        .get();
    List<Question> list = [];
    for (var item in snap.docs) {
      list.add(Question.fromJson(item.data()));
    }
    Questions = list;
  }
  Future<List<Attempt>> getAttempts() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(UserData.uid.toString().split('.').last);
    var snap = await FirebaseFirestore.instance
        .collection("Attempts")
        .where('QuizId', isEqualTo: quiz.Id)
        .where('StudentId', isEqualTo: id)
        .get();
    List<Attempt> list = [];
    for (var item in snap.docs) {
      list.add(Attempt.fromJson(item.data()));
    }
    return list;
  }
}


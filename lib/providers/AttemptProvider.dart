import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/models/answer.dart';
import 'package:projectvu/models/attempt.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/student/StudentHome.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttemptProvider with ChangeNotifier {
  List<Question> _questions = [];
  List<Answer> _answers = [];
  Quiz _quiz;
  Attempt _attempt;
  bool _attemptQuizLoading = false;
  int _counter = 0;
  Timer _timer;
  int _remainingTime = 10;
  BuildContext context;

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
    RemainingTime = quiz.TimeLimit;
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

  Timer get timer => _timer;
  set timer(Timer data) {
    this._timer = data;
    notifyListeners();
  }

  int get RemainingTime => _remainingTime;
  set RemainingTime(int data) {
    this._remainingTime = data;
    notifyListeners();
  }

  void getQuestions() async {
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

  Future<List<Attempt>> getAttempts() async {
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

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (RemainingTime == 0) {
          finishQuiz();
          timer.cancel();
        } else {
          RemainingTime--;
        }
      },
    );
  }

  void finishQuiz() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Please connect to an internet connection!');
      SystemNavigator.pop();
    }
    AttemptQuizLoading = true;
    attempt.timeStamp = DateTime.now().toString();
    attempt.timeTaken = quiz.TimeLimit - RemainingTime;
    attempt.CreatedAt = DateTime.now();
    var attemptJson = attempt.toJson();
    await FirebaseFirestore.instance.collection("Attempts")
        .doc(attempt.id).set(attemptJson).then((value) {
      Counter++;
      AttemptQuizLoading = false;
      Fluttertoast.showToast(msg: "Time is over. Quiz has been submitted");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => StudentHome(),
        ),
            (context) => false,
      );
      Fluttertoast.showToast(msg: "Time is over. Quiz has been submitted");
    });
  }
}

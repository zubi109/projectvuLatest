import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';

class QuizProvider with ChangeNotifier {

  List<Question> _questions = [];
  Quiz _quiz;
  bool _createQuizLoading = false;

  List<Question> get Questions => _questions;
  set Questions(List<Question> data) {
    this._questions = data;
    notifyListeners();
  }

  Quiz get NewQuiz => _quiz;
  set NewQuiz(Quiz data) {
    this._quiz = data;
    notifyListeners();
  }

  bool get CreateQuizLoading => _createQuizLoading;
  set CreateQuizLoading(bool data) {
    this._createQuizLoading = data;
    notifyListeners();
  }

}


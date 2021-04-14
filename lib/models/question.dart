import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Question {
  String answer;
  String option3;
  String quizId;
  String id;
  int marks;
  String option1;
  String option4;
  String type;
  String option2;
  String title;

  Question(
      {this.answer,
        this.option3,
        this.quizId,
        this.id,
        this.marks,
        this.option1,
        this.option4,
        this.type,
        this.option2,
        this.title});

  Question.fromJson(Map<String, dynamic> json) {
    answer = json['Answer'];
    option3 = json['Option3'];
    quizId = json['QuizId'];
    id = json['Id'];
    marks = json['Marks'];
    option1 = json['Option1'];
    option4 = json['Option4'];
    type = json['Type'];
    option2 = json['Option2'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Answer'] = this.answer;
    data['Option3'] = this.option3;
    data['QuizId'] = this.quizId;
    data['Id'] = this.id;
    data['Marks'] = this.marks;
    data['Option1'] = this.option1;
    data['Option4'] = this.option4;
    data['Type'] = this.type;
    data['Option2'] = this.option2;
    data['Title'] = this.title;
    return data;
  }
}

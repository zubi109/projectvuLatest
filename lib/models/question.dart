import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Question {

  String quizId;
  String id;
  String type;

  String title;
  String option1;
  String option2;
  String option3;
  String option4;

  String answer;
  int marks;

  Question(
      {

        this.quizId,
        this.id,
        this.type,

        this.title,
        this.option1,
        this.option2,
        this.option3,
        this.option4,

        this.answer,
        this.marks,
        });

  Question.fromJson(Map<String, dynamic> json) {

    quizId = json['QuizId'];
    id = json['Id'];
    type = json['Type'];

    title = json['Title'];
    option1 = json['Option1'];
    option2 = json['Option2'];
    option3 = json['Option3'];
    option4 = json['Option4'];

    answer = json['Answer'];
    marks = json['Marks'];


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

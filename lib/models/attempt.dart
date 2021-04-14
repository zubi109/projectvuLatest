import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Attempt {
  int marks;
  String studentId;
  String id;
  int timeTaken;
  String timeStamp;
  String quizId;

  Attempt(
      {this.marks,
        this.studentId,
        this.id,
        this.timeTaken,
        this.timeStamp,
        this.quizId});

  Attempt.fromJson(Map<String, dynamic> json) {
    marks = json['Marks'];
    studentId = json['StudentId'];
    id = json['Id'];
    timeTaken = json['TimeTaken'];
    timeStamp = json['TimeStamp'];
    quizId = json['QuizId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Marks'] = this.marks;
    data['StudentId'] = this.studentId;
    data['Id'] = this.id;
    data['TimeTaken'] = this.timeTaken;
    data['TimeStamp'] = this.timeStamp;
    data['QuizId'] = this.quizId;
    return data;
  }
}

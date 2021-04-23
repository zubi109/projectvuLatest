import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:projectvu/models/User.dart';

@JsonSerializable()
class Attempt {
  int marks;
  String studentId;
  String id;
  int timeTaken;
  String timeStamp;
  String quizId;
  QCUser Student;
  DateTime CreatedAt;

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
    Timestamp myTimeStamp = json['CreatedAt'];
    CreatedAt = myTimeStamp.toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Marks'] = this.marks;
    data['StudentId'] = this.studentId;
    data['Id'] = this.id;
    data['TimeTaken'] = this.timeTaken;
    data['TimeStamp'] = this.timeStamp;
    data['QuizId'] = this.quizId;
    data['CreatedAt'] = Timestamp.fromDate(this.CreatedAt);
    return data;
  }
}

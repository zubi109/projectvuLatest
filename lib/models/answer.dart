import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Answer {
  String attemptId;
  String id;
  int marks;
  String questionId;
  String text;

  Answer(
      {this.attemptId, this.id, this.marks, this.questionId, this.text});

  Answer.fromJson(Map<String, dynamic> json) {
    attemptId = json['AttemptId'];
    id = json['Id'];
    marks = json['Marks'];
    questionId = json['QuestionId'];
    text = json['Text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AttemptId'] = this.attemptId;
    data['Id'] = this.id;
    data['Marks'] = this.marks;
    data['QuestionId'] = this.questionId;
    data['Text'] = this.text;
    return data;
  }
}

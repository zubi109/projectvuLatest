import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Quiz {
  int id;
  String name;
  String marks;
  String time;
  String attemptsCount;
  String description;


  Quiz(
      {this.id,
        this.name,
        this.marks,
        this.time,
        this.attemptsCount,
      this.description});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    marks = json['marks'];
    time = json['time'];
    attemptsCount = json['attemptsCount'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['marks'] = this.marks;
    data['time'] = this.time;
    data['attemptsCount'] = this.attemptsCount;
    data['description'] = this.description;
    return data;
  }
}
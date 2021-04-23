import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Quiz {
  String Id;
  String Title;
  String Description;
  int TotalMarks;
  int AttemptsCount;
  int NOQ;
  int TimeLimit;
  DateTime CreatedAt;

  Quiz(
      {this.Id,
      this.Title,
      this.Description,
      this.TotalMarks,
      this.AttemptsCount,
      this.NOQ,
      this.TimeLimit});

  Quiz.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    Title = json['Title'];
    TotalMarks = json['TotalMarks'];
    TimeLimit = json['TimeLimit'];
    AttemptsCount = json['AttemptsCount'];
    Description = json['Description'];
    NOQ = json['NOQ'];
    Timestamp myTimeStamp = json['CreatedAt'];
    CreatedAt = myTimeStamp.toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.Id;
    data['Title'] = this.Title;
    data['TotalMarks'] = this.TotalMarks;
    data['TimeLimit'] = this.TimeLimit;
    data['AttemptsCount'] = this.AttemptsCount;
    data['Description'] = this.Description;
    data['NOQ'] = this.NOQ;
    data['CreatedAt'] = Timestamp.fromDate(this.CreatedAt);
    return data;
  }
}

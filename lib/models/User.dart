import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class QCUser {
  String id;
  String email;
  String fullName;

  QCUser({this.id, this.email, this.fullName});

  QCUser.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    email = json['Email'];
    fullName = json['FullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Email'] = this.email;
    data['FullName'] = this.fullName;
    return data;
  }
}

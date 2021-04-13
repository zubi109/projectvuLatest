
import 'dart:io';
//      ****************************************************************************
//**************used for storing info for login user on splashscreen****************************
//      ****************************************************************************
class UserD {
  // singleton
  static final UserD _singleton = UserD._internal();
  factory UserD() => _singleton;
  UserD._internal();
  static UserD get userData => _singleton;
  //      ****************************************************************************
  //**************************common********************************************************
  //      ****************************************************************************
  String uid = '';
  String email ='';
  String phone ='';
  String name ='';
  String role='';
  //      ****************************************************************************
  //**************************Editor********************************************************
  //      ****************************************************************************
  String speciality = '';
  String Qualification='';
  //      ****************************************************************************
  //******************************std********************************************************
  //      ****************************************************************************
  String program='';
  String value='';
}
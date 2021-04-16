import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/student/student_home_page.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:projectvu/utilities/UserRole.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Authentication/Login.dart';
import 'admin/admin_unverified_account.dart';
import 'teacher/teacher_home.dart';
import 'utilities/user_model.dart';

class splashScreenclass extends StatefulWidget {
  //
  // String Loger_role;
  // celact(String quizNamee) {
  //   this.Loger_role = quizNamee;
  // }

  int select = 0;
  bool s = false;
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreenclass> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  int select = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/vu2.png',
            width: 15,
            height: 15,
          )),
    );
  }

  void startTime() {
    int duration = 3;
    Timer(Duration(seconds: duration), screen_director);
  }



  screen_director() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var role = _prefs.getString(UserData.role.toString().split('.').last);
    // var isLoggedIn = _prefs.getBool("IsLoggedIn");
    if (role == UserRole.Student.toString().split('.').last) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>Std()));
    }
    else if (role == UserRole.Admin.toString().split('.').last) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminUnverifiedAccountList()));

    }
    else if (role == UserRole.Editor.toString().split('.').last){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TeacherHome()));
    }
    else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Login()));
    }
    }
  }

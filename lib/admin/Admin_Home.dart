import 'package:flutter/material.dart';
import 'package:projectvu/admin/Admin_LogIn.dart';
import 'package:projectvu/admin/Quiz_List.dart';
import 'package:projectvu/admin/Student_List.dart';
import 'package:projectvu/student/student_Login.dart';
import 'package:projectvu/teacher/teacher_Login.dart';

import 'Teacher_List.dart';

class admin_home extends StatefulWidget {
  @override
  _admin_homeState createState() => _admin_homeState();
}

class _admin_homeState extends State<admin_home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white60,
        body: Center(
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  height: 110,
                  width: 110,
                  //padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 1, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(60),
                  ),

                  child: Center(
                    child: Text(
                      "QuizList",
                      style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold, color: Colors.brown,),
                    ),
                  ),

                ),
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Admin_Quiz_List()));
                },
              ),

              GestureDetector(
                child: Container(
                  height: 110,
                  width: 110,
                  //  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 1, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(60),
                  ),

                  child: Center(
                    child: Text(
                      "Editors",
                      style: TextStyle(fontSize: 16.0 ,fontWeight: FontWeight.bold, color: Colors.brown,),
                    ),
                  ),

                ),
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Admin_teacher_List()));
                  //authenticationsignup();
                },
              ),

              GestureDetector(
                child: Container(
                  height: 110,
                  width: 110,
                  //  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 1, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(60),
                  ),

                  child: Center(
                    child: Text(
                      "Attemptor",
                      style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold , color: Colors.brown,),
                    ),
                  ),

                ),
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Admin_Student_List()));
                  //authenticationsignup();
                },
              ),
            ],),
        )


    );
  }
}

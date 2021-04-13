import 'package:flutter/material.dart';
import 'package:projectvu/admin/Admin_LogIn.dart';
import 'package:projectvu/student/student_Login.dart';
import 'package:projectvu/teacher/teacher_Login.dart';

class user_role extends StatefulWidget {
  @override
  _user_roleState createState() => _user_roleState();
}

class _user_roleState extends State<user_role> {
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
                    "Admin",
                    style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold, color: Colors.brown,),
                  ),
                ),

              ),
              onTap: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogIn_Class_for_Admin()));
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
                    "Editor",
                    style: TextStyle(fontSize: 16.0 ,fontWeight: FontWeight.bold, color: Colors.brown,),
                  ),
                ),

              ),
              onTap: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogIn_Class_for_Teacher()));
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
                      builder: (context) => LogIn_Class_for_student()));
              //authenticationsignup();
            },
          ),
        ],),
      )


    );
  }
}

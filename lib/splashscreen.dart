import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/login.dart';
import 'package:projectvu/student/student_home_page.dart';

import 'admin/admin_unverified_account.dart';
import 'teacher/teacher_home_page1.dart';
import 'utilities/user_model.dart';

class splashScreenclass extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreenclass> {


  @override

  void initState() {
    startTime();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset('assets/vu2.png',width: 15, height: 15,),
      ),

    );
  }

  void startTime(){
    int duration = 2 ;
    Timer(Duration(seconds: duration), screen_director);
  }

  Future<void> screen_director() async {
    User user = await FirebaseAuth.instance.currentUser;
    if(user!=null){

      Firestore.instance.collection('user').doc(user.uid).get().then((va) {
        setState(() {
          UserD.userData.uid = user.uid;
          UserD.userData.email = va['email'];
          UserD.userData.name = va["name"];
          UserD.userData.phone = va["phone"];
        });

        if(va["role"]==1){
          setState(() {
            UserD.userData.speciality = va['speciality'];
            UserD.userData.Deportment=va['Deportment'];
            UserD.userData.Qualification=va['Qualification'];
          });
         // print('teacher speciality is ${UserD.userData.speciality}');
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Teacher_main_function()));
       } else if(va["role"]==2){
          setState(() {
          UserD.userData.program=va['program'];
          UserD.userData.value=va['value'];
          });
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Std()));
       }     else if(va["role"]==3){
          //UserD.userData.speciality = va['speciality'];
          //UserD.userData.Deportment=va['Deportment'];
          //UserD.userData.Qualification=va['Qualification'];
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminUnverifiedAccountList()));
       }
      });
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogInClass()));
    }
    }

   // FirebaseAuth.instance.currentUser.
  }
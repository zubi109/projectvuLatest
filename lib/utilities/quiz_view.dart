import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectvu/teacher/quizecreation.dart';
import 'package:projectvu/teacher/teacher_home_page1.dart';
import 'package:projectvu/utilities/user_model.dart';

import '../login.dart';

class View_quiz extends StatefulWidget {
  String quizName;
  View_quiz(
      String quizNamee
      ){
    this.quizName= quizNamee;
  }
  @override
  _View_quizState createState() => _View_quizState();
}

class _View_quizState extends State<View_quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.lightGreen,

      body: boddy(),


    );
  }

  Widget boddy(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(9),
      margin:EdgeInsets.only(left: 8,right: 8,top: 22,),

      child:  Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Row(

            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              FlatButton(
                color:Colors.black12,
                splashColor: Colors.white,
                onPressed: () {
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Teacher_main_function()));
                  });
                },
                child: Text(
                  "Quiz List",
                  style: TextStyle(fontSize: 10.0, color:Colors.white),
                ),
              ),   // Quiz List
              FlatButton(
                color:Colors.black12,
                splashColor: Colors.white,
                onPressed: () {
                  setState(() {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>(LogInClass())));

                  });
                },
                child: Text("Sign_out",
                  style: TextStyle(fontSize: 10.0, color: Colors.white),),
              ),  //sign_out

            ],),  // row for btn

        Container(
          height: 90,
          margin: EdgeInsets.all(6),
          padding:EdgeInsets.all(2),
          //alignment: Alignment.center,
          decoration: BoxDecoration(

            color: Colors.white60,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Name"),
                  Text(UserD.userData.name),
                  Text("Email:"),
                  Text(UserD.userData.email),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Program:"),
                  Text(UserD.userData.program),
                  Text("Time"),
                  //Text(UserD.userData.),
                ],
              ),
            ],
          ),
        ),

          Expanded(
              child:
                  listBuilderWidget()
          ),

          Row(

            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              FlatButton(
                color:Colors.black12,
                splashColor: Colors.white,
                onPressed: () {
                  setState(() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>quizcreator(widget.quizName)));
                  });
                },
                child: Text(
                  "Editing",
                  style: TextStyle(fontSize: 10.0, color:Colors.white),
                ),
              ),   // Editing
              FlatButton(
                color:Colors.black12,
                splashColor: Colors.white,
                onPressed: () {
                  setState(() {
                  });
                },
                child: Text("Changing Save",
                  style: TextStyle(fontSize: 10.0, color: Colors.white),),
              ),  // Changing save

            ],), // row for btn

        ],),

    );

  }

  Widget listBuilderWidget(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,

      child:  StreamBuilder(
          stream:  FirebaseFirestore.instance.collection('Quiz').doc(UserD.userData.speciality).collection(widget.quizName).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            QuerySnapshot snapData = snapshot.data;
            return ListView.builder(

                physics: BouncingScrollPhysics(),
                itemCount:snapshot.hasData? snapData.size:0,
                itemExtent:100,
                itemBuilder:(BuildContext context, int index){
                  return listTile(snapData.docs[index], index);

                } );
          }),
    ) ; }

  Widget listTile(data, index){
    return     Container(
      margin: EdgeInsets.all(1),
      padding:EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(10),
      ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Q : " + data["question"]),

            Text("      " +data["option1"]),
            Text("      " +data["option2"]),
            Text("      " +data["option3"]),
            Text("      " +data["option4"]),

           // Text(" Correct answer ${data["anwerType"]}"),
            Text('      '+data["correct_option"])
      ],
    ),
    );

  }

    }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/teacher/quizecreation.dart';
import 'package:projectvu/utilities/quiz_view.dart';
import 'package:projectvu/utilities/user_model.dart';


import '../login.dart';

class Teacher_main_function extends StatefulWidget {
  @override
  _Teacher_main_functionState createState() => _Teacher_main_functionState();
}

class _Teacher_main_functionState extends State<Teacher_main_function> {
  int selectedcolor=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(

      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,

      padding: EdgeInsets.all(10),
      color: Colors.lightGreen,

        child:editorfunction(),

    ),
    );
  }

  Widget editorfunction(){

    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Container(
              //   margin: EdgeInsets.only(bottom: 2, top: 2),
              //   decoration: BoxDecoration(
              //     border: Border.all(width: 2, color: Colors.white),
              //     borderRadius: BorderRadius.circular(9),
              //   ),
              //   child: FlatButton(
              //     color:selectedcolor==1? Colors.lightGreen: Colors.white,
              //     padding: EdgeInsets.all(2),
              //     //shape: Border.all(width: 10 ),
              //     onPressed: () {
              //       setState(() {
              //        // Navigator.push(context, MaterialPageRoute(builder: (context)=>quizcreator()));
              //       });
              //     },
              //     child: Text('CreateQuiz', style: TextStyle(fontSize: 10.0, color: selectedcolor == 1?Colors.white:Colors.black),
              //     ),
              //
              //   ),  //for CreateQuiz button 1
              //
              // ),      // Create_quiz & Navigate to teacher_home_page

              Container(
                margin: EdgeInsets.only(bottom: 2, top: 2),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: FlatButton(
                  color:selectedcolor==1? Colors.lightGreen: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(2),
                  //   shape: Border.all(width: 10 ),
                  splashColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>teacherhome()));
                    });                  },
                  child: Text("Quiz_List", style: TextStyle(fontSize: 10.0, color: selectedcolor == 1?Colors.white:Colors.black),
                  ),
                ),    // button 2
              ),     // view Quiz list

              Container(
                margin: EdgeInsets.only(bottom: 2, top: 2),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: FlatButton(
                  color:selectedcolor==1? Colors.lightGreen: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(2),
                  splashColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      quizList();
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>teacherhome()));
                    });                  },
                  child: Text("ViewResult", style: TextStyle(fontSize: 10.0, color: selectedcolor == 1?Colors.white:Colors.black),
                  ),
                ),    // button 2
              ),    //  view result

            ],),

          Expanded(
              child:Column(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: [
              Container(
                padding: EdgeInsets.all(20),
                color:Colors.white60,

                child:Text('    TEACHER is a full form of, T-Talent, E-Education, A-Attitude, C-Character, H-Harmony, E-Efficient, R-Relation. Wishing you a glorious day!'),
              ),
                  Container(
                    color: Colors.white60,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Name:"),
                            Text(UserD.userData.name),
                            Text("Email:"),
                            Text(UserD.userData.email),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Email:"),
                            Text(UserD.userData.email),
                            Text("Time"),
                            //Text(UserD.userData.),
                          ],
                        ),
                      ],
                    ),
                  ),
            ],)
            ),
          Expanded(

            child: ListView(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              physics: BouncingScrollPhysics(),

              children: [

                quizList()

              ],),
          ),//quiz list

          Container(
            margin: EdgeInsets.only(bottom: 10, top: 20),
              decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(9),
            ),
            child: FlatButton(
              color:selectedcolor==1? Colors.lightGreen: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>(LogInClass())));
              },
              child: Text("Sign_out",
                style: TextStyle(fontSize: 10.0, color: selectedcolor == 1?Colors.white:Colors.black),),
            ),  //sign_out
          ), //sign_out

        ],),

    );
  }
         //************************************************************************************************
  //******************************************Teacher function***************************************************
        //*************************************************************************************************
  Widget quizList(){
   return Container(
     margin: EdgeInsets.only(top: 10),
     alignment: Alignment.topCenter,

     child:Column(

       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Container(
           width: MediaQuery.of(context).size.width,

           child: FlatButton(

           color: Colors.white,
             onPressed: ( ){
                setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>View_quiz("quiz 1")));
               });
             },
             child:Text("Quiz 1", style: TextStyle(color: Colors.lightGreen),) ),
         ),
         Container(
           width: MediaQuery.of(context).size.width,
           child: FlatButton(
               color: Colors.white60,
               onPressed: ( ){
                 setState(() {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>View_quiz('quiz 2')));
                 });
               },
               child:Text("Quiz 2", style: TextStyle(color: Colors.lightGreen),) ),
         ),
         Container(
           width: MediaQuery.of(context).size.width,
           child: FlatButton(
               color: Colors.white,
               onPressed: ( ){
                 setState(() {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>View_quiz('quiz 3')));
                 });
               },
               child:Text("Quiz 3", style: TextStyle(color: Colors.lightGreen),) ),
         ),
         Container(
           width: MediaQuery.of(context).size.width,
           child: FlatButton(
               color: Colors.white60,
               onPressed: ( ){
                 setState(() {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>View_quiz("quiz 4")));
                 });
               },
               child:Text("Quiz 4", style: TextStyle(color: Colors.lightGreen),) ),
         )

       ],
     ),
   );
  }

}

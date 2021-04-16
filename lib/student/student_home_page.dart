import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'attempt_quize.dart';

class Std extends StatefulWidget {
  String quizName;
  String speciality;
   //String user_name;
  View_quiz(String quizNamee, String tspeciality , ) {
    this.quizName = quizNamee;
    this.speciality = tspeciality;
    //this.quizName = current_user_name;
  }

  @override
  _stdState createState() => _stdState();
}

class _stdState extends State<Std> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Teacher Home'),
      ),
      body: SingleChildScrollView(
        child: (Container(
          margin: EdgeInsets.only(top: 40),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black38,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FlatButton(
              color: Colors.white60,
              splashColor: Colors.white,
              onPressed: () async {
                setState(() {
                  FirebaseAuth.instance.signOut();
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => (user_role())));
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("student", false);
              },
              child: Text(
                "Sign_out",
                style: TextStyle(fontSize: 10.0, color: Colors.black),
              ),
            ), // sign_out
            Container(
                margin: EdgeInsets.all(10),
                height: 50,
                //color: Colors.white,

                child: Text(
                  "\t A father gives his child nothing \n better then a good education.",
                  style: TextStyle(
                    color: Colors.brown,
                  ),
                )), //quotation for student

            boddy(), // for

            //***********************************************************************************
            // ******************************Take Quize********************************************************
            //************************************************************************************
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Quiz").snapshots(),
                builder: (BuildContext context, snapshot) {
                  QuerySnapshot snapData = snapshot.data;
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return Expanded(
                      child: new ListView.builder(
                          //   physics: NeverScrollableScrollPhysics(),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapData.size,
                          itemBuilder: (BuildContext context, int index) {
//int plusindex=index+1;
                            return FlatButton(
                              color: Colors.white,
                              splashColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => (AttemptQuize(
                                              snapData.docs[index]['tilte'],
                                              snapData.docs[index]['quizId'],
                                             // snapData.docs[index]['username']
                                          ))));
                                });
                              },
                              child: Text(
                                snapData.docs[index]['tilte'],
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.brown),
                              ),
                            );
                          }),
                    );
                  }
                }),
          ]),
        )),
      ),
    );
  }

  Widget boddy() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 90,
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.all(2),
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
                    Text(""),
                    Text("Email:"),
                    Text(""),
                    //UserD.userData.email
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Program:"),
                    //Text(widget.user_name),
                    //Text(UserD.userData.program),
                    Text("Time"),
                    //Text(UserD.userData.),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

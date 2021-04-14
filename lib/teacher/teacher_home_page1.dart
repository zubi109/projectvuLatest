import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/teacher/quizecreation.dart';
import 'package:projectvu/utilities/quize_Data_Base.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Create_Quiz_Info.dart';
import 'editor_view_quize.dart';


class Teacher_main_function extends StatefulWidget {
  String speciality;
  Teacherview_subject_view(String tspeciality) {

    this.speciality=tspeciality;
  }

  @override
  _Teacher_main_functionState createState() => _Teacher_main_functionState();
}

class _Teacher_main_functionState extends State<Teacher_main_function> {
  TextEditingController _subjectController = TextEditingController();
  bool _isLoding = false;
  final _formKey = GlobalKey<FormState>();
  String quizId, quizename;
  DatabaseService databaseService = new DatabaseService();

  createQuizeline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState.validate()) {
      quizId = randomAlphaNumeric(16);

      FirebaseFirestore.instance.collection('Quiz').doc(quizId).set({
        "quizId": quizId,
        "teacherid": prefs.getString("teacherid"),
        "tilte": _subjectController.text
      }).then((value) {
        setState(() {
          _isLoding = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => quizcreator(quizId)));
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: Colors.grey,
        child:         Column(
          children: [
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 45),

              child: (Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  child: Container(
                    //  margin: EdgeInsets.only(top: 7,left: 10,right: 10),
                  //  width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child: Center(
                      child: Text(
                        "+", style: TextStyle(fontSize: 32,color:Colors.amber),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => create_quiz_info()));
                    });
                  },
                ),
                Container(
                  height: 80,
                  margin: EdgeInsets.only(top:60 ,left: 10 ,right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      "YOUR CREATED QUIZ LIST",
                      style: TextStyle(fontSize: 24.0, color: Colors.amber),
                    ),
                  ),
                ), // Text
                Container(
                    height: 70,
                    margin: EdgeInsets.only(top:1 ,left: 10 ,right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "\t A father gives his child nothing \n better then a good education.",
                        style: TextStyle(fontSize: 24.0 ,fontWeight: FontWeight.bold , color: Colors.amber
                        ),
                      ),
                    )),

                //***********************************************************************************
                // ******************************Take Quize********************************************************
                //************************************************************************************
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Quiz").where("teacherid",isEqualTo: widget.speciality)

                        .snapshots(),
                    builder: (BuildContext context, snapshot) {

                      QuerySnapshot snapData = snapshot.data;
                      if(!snapshot.hasData)
                      {
                        return  CircularProgressIndicator();
                      }else {
                        return new ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapData.size,
                            itemBuilder: (BuildContext context, int index) {


                              // Dismissible(
                              //   // Show a red background as the item is swiped away.
                              //   background: Container(color: Colors.grey),
                              //   key: Key(item),
                              //   onDismissed: (direction) {
                              //     setState(() {
                              //       items.removeAt(index);
                              //     });
                              //     ScaffoldMessenger
                              //         .of(context)
                              //         .showSnackBar(SnackBar(content: Text("$item dismissed")));
                              //   },
                              //   child: ListTile(title: Text('$')),
                              // );

                              return  SizedBox(
                                child: Container(
//                                height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,

                                  height:30,
                                  margin: EdgeInsets.only(top:2 ,left: 20 ,right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: FlatButton(
                                    color: Colors.white,
                                    splashColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                            (Editor_Quize_View(snapData.docs[index]['tilte'],snapData.docs[index]['quizId']))));
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        snapData.docs[index]['tilte'],
                                        style: TextStyle(fontSize: 20.0, color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    }),
              ])),
            ),
           ],
        ),

      ),
    );
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/Authentication/Login.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/teacher/CreateQuestion.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:projectvu/utilities/quize_Data_Base.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CreateQuiz.dart';
import 'ViewQuiz.dart';

class TeacherHome extends StatefulWidget {
  String speciality;
  Teacherview_subject_view(String tspeciality) {
    this.speciality = tspeciality;
  }

  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  TextEditingController _subjectController = TextEditingController();
  bool _isLoding = false;
  List<Quiz> quizzes = [];
  final _formKey = GlobalKey<FormState>();
  String quizId, quizename;
  DatabaseService databaseService = new DatabaseService();

  int counter_for_Quiz_number = 1;
  bool color_selection_quiz_tile = true;

  // QuerySnapshot snapData;

  // createQuizeline() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (_formKey.currentState.validate()) {
  //     quizId = randomAlphaNumeric(16);
  //
  //     FirebaseFirestore.instance.collection('Quiz').doc(quizId).set({
  //       "quizId": quizId,
  //       "teacherid": prefs.getString("teacherid"),
  //       "tilte": _subjectController.text
  //     }).then((value) {
  //       setState(() {
  //         _isLoding = false;
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => CreateQuestion(quizId)));
  //       });
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      _isLoding = true;
    });
    var snap = await FirebaseFirestore.instance.collection("Quizzes").get();
    List<Quiz> list = [];
    for (var item in snap.docs) {
      list.add(Quiz.fromJson(item.data()));
    }
    setState(() {
      quizzes = list;
      _isLoding = false;
    });
  }

  void DeleteQuiz(String reference) async {
    setState(() {
      _isLoding = true;
    });
    await FirebaseFirestore.instance
        .collection("Quizzes")
        .doc(reference)
        .delete();
    var snap = await FirebaseFirestore.instance.collection("Quizzes").get();
    List<Quiz> list = [];
    for (var item in snap.docs) {
      list.add(Quiz.fromJson(item.data()));
    }
    setState(() {
      quizzes = list;
      _isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
          const Text('Quizzes List'),
          SizedBox(),
          InkWell(
            child: Center(
              child: Text(
                "Sign_out",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            onTap: () async {
              setState(() {
                // FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => (Login())));
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(UserData.role.toString().split('.').last, "LoggedOut");
            },
          ),
        ])
      ),
      body: Column(
        children: [

          _isLoding == false
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: quizzes == null ? 0 : quizzes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      // Show a red background as the item is swiped away.
                      background: Container(color: Colors.red),
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        setState(() {
                          // items.removeAt(index);
                          DeleteQuiz(quizzes[index].Id);
                        });
                      },
                      child: SizedBox(
                        child: Container(
//                                height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,

                          height: 30,
                          margin: EdgeInsets.only(top: 2, left: 20, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: FlatButton(
                            color: counter_for_Quiz_number % 2 == 0
                                ? Colors.amber
                                : Colors.white12, //color: Colors.white,
                            splashColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => (ViewQuiz(
                                            quizzes[index]))));
                              });
                            },
                            child: Center(
                              child: Text(
                                quizzes[index].Title,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black54),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}

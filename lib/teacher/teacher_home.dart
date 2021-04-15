import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/Authentication/Login.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/teacher/CreateQuestion.dart';
import 'package:projectvu/utilities/quize_Data_Base.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CreateQuiz.dart';
import 'editor_view_quize.dart';

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



  int counter_for_Quiz_number=1;
  bool color_selection_quiz_tile=true;

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
        title: const Text('Quizzes List'),
      ),
      body: Column(
        children: [
          GestureDetector(
            child: Container(
              height: 50,
              width: 50,
              margin:EdgeInsets.only(top: 20) ,
              decoration: BoxDecoration(
                color: Colors.amber,
                border: Border.all(width: 1, color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Center(
                child: Text(
                  "Sign_out",
                  style: TextStyle(fontSize: 10.0, color: Colors.black),
                ),
              ),
            ),
            onTap: () async {
              setState(() {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => (Login())));
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("student", false);
            },
          ), // sign_out

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
                           color: counter_for_Quiz_number%2==0?Colors.amber:Colors.white12,    //color: Colors.white,
                            splashColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            (Editor_Quize_View(
                                                quizzes[index].Title,
                                                quizzes[index].Id))));
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

//             return SizedBox(
//               child: Container(
// //                                height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//
//                 height: 30,
//                 margin: EdgeInsets.only(
//                     top: 2, left: 20, right: 20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: FlatButton(
//                   color: Colors.white,
//                   splashColor: Colors.white,
//                   onPressed: () {
//                     setState(() {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                               (Editor_Quize_View(
//                                   snapData.docs[index]
//                                   ['Title'],
//                                   snapData.docs[index]
//                                   ['Id']))));
//                     });
//                   },
//                   child: Center(
//                     child: Text(
//                       snapData.docs[index]['Title'],
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.black54),
//                     ),
//                   ),
//                 ),
//               ),
//             );
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

  Widget old(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: Colors.grey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(30),
              child: FlatButton(
                color: Colors.white60,
                splashColor: Colors.white,
                onPressed: () async {
                  setState(() {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => (Login())));
                  });
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("student", false);
                },
                child: Text(
                  "Sign_out",
                  style: TextStyle(fontSize: 10.0, color: Colors.black),
                ),
              ),
            ), // sign_out

            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 45),
              child: (Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            "+",
                            style: TextStyle(fontSize: 32, color: Colors.amber),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateQuiz()));
                        });
                      },
                    ),
                    Container(
                      height: 80,
                      margin: EdgeInsets.only(top: 60, left: 10, right: 10),
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
                        margin: EdgeInsets.only(top: 1, left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "\t A father gives his child nothing \n better then a good education.",
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber),
                          ),
                        )),

                    //***********************************************************************************
                    // ******************************Take Quize********************************************************
                    //************************************************************************************
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Quiz")
                            .where("teacherid", isEqualTo: widget.speciality)
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          QuerySnapshot snapData = snapshot.data;
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
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

                                  return SizedBox(
                                    child: Container(
//                                height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,

                                      height: 30,
                                      margin: EdgeInsets.only(
                                          top: 2, left: 20, right: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: FlatButton(
                                        color: Colors.white,
                                        splashColor: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        (Editor_Quize_View(
                                                            snapData.docs[index]
                                                                ['tilte'],
                                                            snapData.docs[index]
                                                                ['quizId']))));
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            snapData.docs[index]['tilte'],
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.black54),
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

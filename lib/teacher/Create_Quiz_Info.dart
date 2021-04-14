import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/teacher/quizecreation.dart';
import 'package:projectvu/utilities/quize_Data_Base.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class create_quiz_info extends StatefulWidget {
  @override
  _create_quiz_infoState createState() => _create_quiz_infoState();
}

class _create_quiz_infoState extends State<create_quiz_info> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _numberofQuestionController = TextEditingController();
  TextEditingController _marksperquestionController = TextEditingController();
  TextEditingController _timeperquestionController = TextEditingController();
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
        backgroundColor: Colors.grey,
        body: _isLoding
            ? Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      height: 100,
                      width: 800,
                      margin: EdgeInsets.all(70),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(40),
                          border: InputBorder.none,
                          hintText: 'Enter Quiz Name',
                          prefixIcon: Icon(
                            Icons.book,
                          ),
                        ),
                        controller: _subjectController,
                      ),
                    ),
                  ),//Enter Quiz Name
                  // Form(
                  //   key: _formKey,
                  //   child: Container(
                  //     height: 100,
                  //     width: 800,
                  //     margin: EdgeInsets.all(70),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(width: 1, color: Colors.black),
                  //       borderRadius: BorderRadius.circular(50),
                  //     ),
                  //     child: TextFormField(
                  //       decoration: InputDecoration(
                  //         contentPadding: EdgeInsets.all(40),
                  //         border: InputBorder.none,
                  //         hintText: 'Enter Quiz Description',
                  //         prefixIcon: Icon(
                  //           Icons.book,
                  //         ),
                  //       ),
                  //       controller: _descriptionController,
                  //     ),
                  //   ),
                  // ),//Enter Quiz Description
                  // Form(
                  //   key: _formKey,
                  //   child: Container(
                  //     height: 100,
                  //     width: 800,
                  //     margin: EdgeInsets.all(70),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(width: 1, color: Colors.black),
                  //       borderRadius: BorderRadius.circular(50),
                  //     ),
                  //     child: TextFormField(
                  //       decoration: InputDecoration(
                  //         contentPadding: EdgeInsets.all(40),
                  //         border: InputBorder.none,
                  //         hintText: 'Number Of Question',
                  //         prefixIcon: Icon(
                  //           Icons.book,
                  //         ),
                  //       ),
                  //       controller: _numberofQuestionController,
                  //     ),
                  //   ),
                  // ),//Number Of Question
                  // Form(
                  //   key: _formKey,
                  //   child: Container(
                  //     height: 100,
                  //     width: 800,
                  //     margin: EdgeInsets.all(70),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(width: 1, color: Colors.black),
                  //       borderRadius: BorderRadius.circular(50),
                  //     ),
                  //     child: TextFormField(
                  //       decoration: InputDecoration(
                  //         contentPadding: EdgeInsets.all(40),
                  //         border: InputBorder.none,
                  //         hintText: 'Marks Per Question',
                  //         prefixIcon: Icon(
                  //           Icons.book,
                  //         ),
                  //       ),
                  //       controller: _marksperquestionController,
                  //     ),
                  //   ),
                  // ),//Marks Per Question
                  // Form(
                  //   key: _formKey,
                  //   child: Container(
                  //     height: 100,
                  //     width: 800,
                  //     margin: EdgeInsets.all(70),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       border: Border.all(width: 1, color: Colors.black),
                  //       borderRadius: BorderRadius.circular(50),
                  //     ),
                  //     child: TextFormField(
                  //       decoration: InputDecoration(
                  //         contentPadding: EdgeInsets.all(40),
                  //         border: InputBorder.none,
                  //         hintText: 'Time PerQuestion',
                  //         prefixIcon: Icon(
                  //           Icons.book,
                  //         ),
                  //       ),
                  //       controller: _timeperquestionController,
                  //     ),
                  //   ),
                  // ),//Time PerQuestion

                  InkWell(
                    onTap: () {
                      createQuizeline();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  quizcreator(_subjectController.text ,)));
                    },
                    child: Container(
                      height: 106,
                      width: 106,
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1, color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

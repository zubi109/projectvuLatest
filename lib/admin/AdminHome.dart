import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/Authentication/Login.dart';
import 'package:projectvu/admin/ViewQuizAttempts.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/teacher/CreateQuiz.dart';
import 'package:projectvu/teacher/ViewQuiz.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AdminHome extends StatefulWidget {
  String speciality;
  Teacherview_subject_view(String tspeciality) {
    this.speciality = tspeciality;
  }

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  bool _isLoding = false;
  List<Quiz> quizzes = [];
  List<Question> questions = [];
  // final _formKey = GlobalKey<FormState>();
  // String quizId, quizename;
  // DatabaseService databaseService = new DatabaseService();

  int counter_for_Quiz_number = 1;
//  bool color_selection_quiz_tile = true;


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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  "Logout",
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
        body: _isLoding == false
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: quizzes == null ? 0 : quizzes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: FlatButton(
                        color: counter_for_Quiz_number % 2 == 0
                            ? Colors.amber
                            : Colors.white12, //color: Colors.white,
                        splashColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (ViewQuizAttempts(
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
                  );
                })
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
      ),
    );
  }
}

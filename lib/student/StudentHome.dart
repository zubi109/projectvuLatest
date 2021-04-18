import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/Authentication/Login.dart';
import 'package:projectvu/models/attempt.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/providers/AttemptProvider.dart';
import 'package:projectvu/student/AttemptQuiz.dart';
import 'package:projectvu/student/ViewResult.dart';
import 'package:projectvu/teacher/CreateQuestion.dart';
import 'package:projectvu/teacher/CreateQuiz.dart';
import 'package:projectvu/teacher/ViewQuiz.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:projectvu/utilities/quize_Data_Base.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class StudentHome extends StatefulWidget {
  String speciality;
  Teacherview_subject_view(String tspeciality) {
    this.speciality = tspeciality;
  }

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  TextEditingController _subjectController = TextEditingController();
  bool _isLoding = false;
  List<Quiz> quizzes = [];
  final _formKey = GlobalKey<FormState>();
  String quizId, quizename;
  DatabaseService databaseService = new DatabaseService();

  int counter_for_Quiz_number = 1;
  bool color_selection_quiz_tile = true;

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

  void attemptQuiz(Quiz quiz) async {
    setState(() {
      _isLoding = true;
    });

    context.read<AttemptProvider>().quiz = quiz;
    var list = await context.read<AttemptProvider>().getAttempts();

    if (quiz.AttemptsCount == null || quiz.AttemptsCount == 0) {
      Fluttertoast.showToast(
        msg: "Quiz attempts limit has not been set",
        backgroundColor: Colors.red,
      );
    } else if (list == null) {
      setState(() {
        _isLoding = false;
      });
      await _showMyDialog(quiz);
    } else if (list.length != quiz.AttemptsCount) {
      setState(() {
        _isLoding = false;
      });
      await _showMyDialog(quiz);
    } else {
      Fluttertoast.showToast(
        msg:
            "You can not attempt this quiz more than ${quiz.AttemptsCount} times",
        backgroundColor: Colors.red,
      );
    }
    setState(() {
      _isLoding = false;
    });
  }

  void initAttempt(Quiz que) async {
    setState(() {
      _isLoding = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var stuId = pref.getString(UserData.uid.toString().split(".").last);
    context.read<AttemptProvider>().Counter = 1;
    context.read<AttemptProvider>().Answers = [];
    var uuid = Uuid();
    Attempt attempt = new Attempt(
      id: uuid.v4(),
      marks: 0,
      quizId: que.Id,
      studentId: stuId,
      timeTaken: 0,
      timeStamp: DateTime.now().toString(),
    );
    var data = attempt.toJson();

    await FirebaseFirestore.instance
        .collection("Attempts")
        .doc(attempt.id)
        .set(data)
        .then((value) {
      context.read<AttemptProvider>().attempt = attempt;
      context.read<AttemptProvider>().getQuestions();
      context.read<AttemptProvider>().AttemptQuizLoading = false;
      context.read<AttemptProvider>().startTimer();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => AttemptQuiz(),
        ),
        (context) => false,
      );
    });
    setState(() {
      _isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amber,
            title:
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  prefs.setString(
                      UserData.role.toString().split('.').last, "LoggedOut");
                },
              ),
            ])),
        body: _isLoding == false
            ? ListView.builder(
            shrinkWrap: true,
            itemCount: quizzes == null ? 0 : quizzes.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        quizzes[index].Title,
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.black54),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            child: Center(
                              child: Text(
                                "View Quiz",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.amber),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      (ViewQuiz(quizzes[index]))));
                            },
                          ),
                          InkWell(
                            child: Center(
                              child: Text(
                                "Attempt",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.amber),
                              ),
                            ),
                            onTap: () async {
                              await attemptQuiz(quizzes[index]);
                            },
                          ),
                          InkWell(
                            child: Center(
                              child: Text(
                                "View Result",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.amber),
                              ),
                            ),
                            onTap: () {
                              initViewResult(quizzes[index]);
                            },
                          ),
                        ],
                      )
                    ],
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

  initViewResult(Quiz quiz) async{
    setState(() {
      _isLoding = true;
    });

    var pref = await SharedPreferences.getInstance();
    var stuId = pref.getString(UserData.uid.toString().split(".").last);

    var attSnap = await FirebaseFirestore.instance
        .collection("Attempts")
        .where('QuizId', isEqualTo: quiz.Id)
        .where('StudentId', isEqualTo: stuId)
        .get();
    List<Attempt> attList = [];
    for (var item in attSnap.docs) {
      attList.add(Attempt.fromJson(item.data()));
    }

    if(attList.length == 0){
      Fluttertoast.showToast(msg: "You have not attempted this quiz yet!");
    }
    else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              (ViewResult(quiz))));
    }
    setState(() {
      _isLoding = false;
    });
  }

  Future<void> _showMyDialog(Quiz que) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attempt Quiz'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Make sure, If you close the application during the quiz or if quiz timer is finish then Quiz will automatically be submitted!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(color: Colors.red, fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Start',
                  style: TextStyle(color: Colors.amber, fontSize: 16)),
              onPressed: () {
                initAttempt(que);
              },
            )
          ],
        );
      },
    );
  }
}

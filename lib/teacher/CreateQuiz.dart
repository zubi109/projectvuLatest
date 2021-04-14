import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/providers/QuizProvider.dart';
import 'package:projectvu/teacher/CreateQuestion.dart';
import 'package:projectvu/utilities/quize_Data_Base.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _numberofQuestionController = TextEditingController();
  TextEditingController _timeLimitController = TextEditingController();
  TextEditingController _attemptsCountController = TextEditingController();
  bool _isLoding = false;
  String quizId, quizename;
  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<QuizProvider>(context);
  }

  createQuizeline() {
    var NewQuiz = new Quiz(
      Title: _nameController.text,
      Description: _descriptionController.text,
      AttemptsCount: int.parse(_attemptsCountController.text),
      NOQ: int.parse(_numberofQuestionController.text),
      TimeLimit: int.parse(_timeLimitController.text),
    );



    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateQuestion(
                  NewQuiz,
                )));
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (_formKey.currentState.validate()) {
    //   quizId = randomAlphaNumeric(16);
    //
    //   FirebaseFirestore.instance.collection('Quiz').doc(quizId).set({
    //     "quizId": quizId,
    //     "teacherid": prefs.getString("teacherid"),
    //     "tilte": _subjectController.text
    //   }).then((value) {
    //     setState(() {
    //       _isLoding = false;
    //       Navigator.pushReplacement(context,
    //           MaterialPageRoute(builder: (context) => quizcreator(quizId)));
    //     });
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Create Quiz',
        ),
      ),
      backgroundColor: Colors.white,
      body: _isLoding
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: 'Quiz Name',
                    ),
                    controller: _nameController,
                  ), //
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: 'Description',
                    ),
                    controller: _descriptionController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: 'No. of Questions',
                    ),
                    controller: _numberofQuestionController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: 'Time Limit (seconds)',
                    ),
                    controller: _timeLimitController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: 'Allowed Attempts',
                    ),
                    controller: _attemptsCountController,
                  ), // Enter Quiz Name
                  SizedBox(
                    height: 20,
                  ),
                  Spacer(),
                  Row(children: [
                    Expanded(
                        child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          createQuizeline();
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(fontSize: 22),
                        ),
                        style: ButtonStyle(),
                      ),
                    ))
                  ]),
                ],
              ),
            ),
    );
  }
}

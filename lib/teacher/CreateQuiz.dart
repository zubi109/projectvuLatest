import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/providers/QuizProvider.dart';
import 'package:projectvu/teacher/CreateQuestion.dart';
import 'package:projectvu/utilities/GlobalProperties.dart';
import 'package:projectvu/utilities/quize_Data_Base.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  TextEditingController _nameController = TextEditingController();
 // TextEditingController _descriptionController = TextEditingController();
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

  createQuizeline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Please connect to an internet connection!');
      return;
    }
    // asses the Quiz Model
    var uuid = Uuid(); // for set the uid
    var NewQuiz = new Quiz(
      Id: uuid.v4(),
      Title: _nameController.text,
   //   Description: _descriptionController.text,
      AttemptsCount: int.parse(_attemptsCountController.text),
      NOQ: int.parse(_numberofQuestionController.text),
      TimeLimit: int.parse(_timeLimitController.text),
    );
    int QueCounter = 0;
    List<Question> questions = [];
    Question question = new Question();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CreateQuestion(NewQuiz, QueCounter, questions, question)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text(
            'Create Quiz',
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: _isLoding
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Center(
                child: Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              cursorColor: Colors.amber,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber)),
                                hintText: 'Quiz Name',
                              ),
                              controller: _nameController,
                            ), //quiz name
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter no. of questions';
                                }
                                if (!Global.isNumeric(value)) {
                                  return 'Invalid input!';
                                }
                                return null;
                              },
                              cursorColor: Colors.amber,
                              // keyboardType: TextInputType.number,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber)),
                                hintText: 'No. of Questions',
                                // keyboardType: TextInputType.numberWithOptions(decimal: true),
                              ),
                              controller: _numberofQuestionController,
                            ), //number of qestion
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter time limit';
                                }
                                if (!Global.isNumeric(value)) {
                                  return 'Invalid input!';
                                }
                                return null;
                              },
                              cursorColor: Colors.amber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber)),
                                hintText: 'Time Limit (seconds)',
                              ),
                              controller: _timeLimitController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter no. of allowed attempts per student';
                                }
                                if (!Global.isNumeric(value)) {
                                  return 'Invalid input!';
                                }
                                return null;
                              },
                              cursorColor: Colors.amber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.amber)),
                                hintText: 'Allowed Attempts',
                              ),
                              controller: _attemptsCountController,
                            ), // Enter Quiz Name
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            //Spacer(),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                color: Colors.amber,
                                height: 50,
                                child: ElevatedButton(
                                    // primary: Colors.amber, // background
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Creating Quiz...'),
                                          backgroundColor: Colors.amber,
                                        ));
                                        createQuizeline();
                                      }
                                    },
                                    child: Text(
                                      "Next",
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.amber))),
                              ))
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

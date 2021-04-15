import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/providers/QuizProvider.dart';
import 'package:projectvu/teacher/CreateQuestion.dart';
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
  // asses the Quiz Model
    var uuid = Uuid();
    var NewQuiz = new Quiz(
      Id: uuid.v4(),
      Title: _nameController.text,
      Description: _descriptionController.text,
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
            builder: (context) => CreateQuestion(
                  NewQuiz, QueCounter,questions, question
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
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
                    cursorColor: Colors.amber,

                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber)),

                      hintText: 'Quiz Name',
                    ),
                    controller: _nameController,
                  ), //
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber)),
                      hintText: 'Description',
                    ),
                    controller: _descriptionController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.amber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber)),
                      hintText: 'No. of Questions',
                    ),
                    controller: _numberofQuestionController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.amber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber)),
                      hintText: 'Time Limit (seconds)',
                    ),
                    controller: _timeLimitController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.amber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber)),
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
                          if(_nameController.text.isEmpty){
                            return Fluttertoast.showToast(msg: 'Pleas Enter Quiz Name');
                          }
                          else if(_descriptionController.text.isEmpty){
                            return Fluttertoast.showToast(msg: 'Pleas Enter Quiz Descriptions');
                          }
                          else if(_numberofQuestionController.text.isEmpty){
                            return Fluttertoast.showToast(msg: 'Pleas Enter Number of Question');
                          }
                          else if(_timeLimitController.text.isEmpty){
                            return Fluttertoast.showToast(msg: 'Pleas Enter Quiz Time Limit in Seconds');
                          }
                          else if(_attemptsCountController.text.isEmpty){
                            return Fluttertoast.showToast(msg: 'Pleas write Quiz Name');
                          }
                          else{
                            createQuizeline();
                          }

                        },
                        child: Text(
                          "Next",
                          style: TextStyle(fontSize: 22),
                        ),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.green;
                            return null; // Use the component's default.
                          },
                        )),
                      ),
                    ))
                  ]),
                ],
              ),
            ),
    );
  }
}

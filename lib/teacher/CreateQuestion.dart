import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/teacher/teacher_home.dart';
import 'package:projectvu/utilities/GlobalProperties.dart';
import 'package:projectvu/utilities/QuestionType.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateQuestion extends StatefulWidget {
  Quiz quiz ;
  int counter ;
  List<Question> questions;
  Question que;
  CreateQuestion( Quiz quiz,int count,List<Question> questions, Question que) {
    this.quiz = quiz;
    this.counter = count;
    this.questions = questions;
    this.que = que;
  }
  @override
  _CreateQuestionState createState() => _CreateQuestionState(quiz,counter,questions,que);
}

class _CreateQuestionState extends State<CreateQuestion> {
  Quiz newQuiz;
  int counter;
  List<Question> questions;
  Question que;
  bool isLoading = false;
  _CreateQuestionState(Quiz quiz, int counter,List<Question> questions,Question que){
    newQuiz = quiz;
    this.counter = counter;
    this.questions = questions;
    this.que = que;
  }

  Question newQuestion = new Question();
  int correct_answer = 0, totalmarks = 0, quesion_number = 1;
  String quesiontype;
  String quiznumber = "Quiz";
  String stringAnswer = '';
  bool _isTrue = false;
  void setAnswerForTrueFalse(bool value){
setState(() {
  if(value)
  newQuestion.answer = "True";
  else
    newQuestion.answer = "False";
});
}

  TextEditingController _questionController = TextEditingController();
  TextEditingController _option1Controller = TextEditingController(text: "option1");
  TextEditingController _option2Controller = TextEditingController(text: "option2");
  TextEditingController _option3Controller = TextEditingController(text: "option3");
  TextEditingController _option4Controller = TextEditingController(text: "option4");
  TextEditingController _questionMarksController = TextEditingController();
  TextEditingController _shortquestionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int answertype = 0, opstionNumber = 1;
//  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter++;
    if(que.id != null){
      if(questions.any((element) => element.id == que.id)){
        var item = questions.where((element) => element.id == que.id).first;
        var index = questions.indexOf(item);
        questions[index] = que;
      }
      else{
        questions.add(que);
      }
    }

  }

  createQuizeline() {
    // asses the Quiz Model
     Question(
     //  id: ,
       title: _questionController.text,

       option1: _option1Controller.text,
       option2: _option2Controller.text,
       option3: _option2Controller.text,
       option4: _option4Controller.text,
       marks: int.parse(_questionMarksController.text),
       //quizId: ,
      // type:answertype ,
       //answer: answertype,
       // AttemptsCount: int.parse(_attemptsCountController.text),
      // NOQ: int.parse(_numberofQuestionController.text),
      // TimeLimit: int.parse(_timeLimitController.text),
    );



    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => CreateQuestion(
    //           Question(),
    //         )));
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

  Future<bool> _onWillPop() async {
    // counter--;
    // questions.removeLast();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
           resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text('Create Question'),
              Text(counter.toString()+ "/" + newQuiz.NOQ.toString()),
            ]),

          ),
          body: !isLoading 
              ?Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,

            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                    children: [
                      Card(
                          margin: EdgeInsets.fromLTRB(0,0,0,10),
                          child: NewQuestionTypes()
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(0,0,0,20),
                        child: Column(
                          children: [
                            question(),
                            setAnswers(),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        margin: EdgeInsets.only(right: 20, bottom: 20),
                        child: TextFormField(
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Please enter Marks';
                            }
                            if (!Global.isNumeric(value)) {
                              return 'Invalid input!';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.amber,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber)),
                            hintText: 'Marks',
                          ),
                          onChanged: (marks) {
                            setState(() {});
                            // print(questionmarks);
                          },
                          controller: _questionMarksController,
                        ),
                      ),
                      counter != newQuiz.NOQ
                      ?Row(children: [
                        Expanded(
                            child: Container(
                              color: Colors.amber,
                              height: 50,
                              child: ElevatedButton(
                                // primary: Colors.amber, // background
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      if(quesiontype != QuestionType.MCQ.toString().split('.').last){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Adding Question...'),
                                          backgroundColor: Colors.amber,
                                        ));
                                        nextQuestion();
                                      }
                                      else{
                                        if(newQuestion.answer == _option1Controller.text ||
                                            newQuestion.answer == _option2Controller.text ||
                                            newQuestion.answer == _option3Controller.text ||
                                            newQuestion.answer == _option4Controller.text){
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Adding Question...'),
                                            backgroundColor: Colors.amber,
                                          ));
                                          nextQuestion();
                                        }
                                        else{
                                          Fluttertoast.showToast(
                                            msg: "Please select answer from available 4 options!",
                                            backgroundColor: Colors.red
                                          );
                                        }
                                      }
                                    }

                                  },
                                  child: Text(
                                    "Next",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)
                                  )
                              ),
                            ))
                      ])
                      :Row(children: [
                        Expanded(
                            child: Container(
                              color: Colors.amber,
                              height: 50,
                              child: ElevatedButton(
                                // primary: Colors.amber, // background
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      if(quesiontype != QuestionType.MCQ.toString().split('.').last){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Creating Quiz...'),
                                          backgroundColor: Colors.amber,
                                        ));
                                        finishQuiz();
                                      }
                                      else{
                                        if(newQuestion.answer == _option1Controller.text ||
                                            newQuestion.answer == _option2Controller.text ||
                                            newQuestion.answer == _option3Controller.text ||
                                            newQuestion.answer == _option4Controller.text){
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Creating Quiz...'),
                                            backgroundColor: Colors.amber,
                                          ));
                                          finishQuiz();
                                        }
                                        else{
                                          Fluttertoast.showToast(
                                              msg: "Please select answer from available 4 options!",
                                              backgroundColor: Colors.red
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Finish",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)
                                  )
                              ),
                            ))
                      ]),//for finish question
                ]),
              ),
            ),
          )
          :Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.amber,
              valueColor:
              new AlwaysStoppedAnimation<Color>(Colors.white54),
            ),
          ),
        ),
      ),
    );
  }

  Widget setAnswers(){
    if(quesiontype == QuestionType.MCQ.toString().split('.').last){
      return radio_Buttonoption();
    }
    else if(quesiontype == QuestionType.TrueFalse.toString().split('.').last){
      return chackBox();
    }
    else if(quesiontype == QuestionType.ShortQuestion.toString().split('.').last){
      return Short_Question_Buttonoption();
    }
    else{
      return SizedBox();
    }
  }
  Widget question() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
      ),
      child: Row(

        children: [
          Text(
            'Q ',
            style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TextFormField(
              validator: (value){
                if (value == null || value.isEmpty) {
                  return 'Please enter the question';
                }
                return null;
              },
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter the Question',
              ),
              controller: _questionController,
            ),
          ),
        ],
      ),
    );
  }
  Widget radio_Buttonoption(){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10 ,right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),

          child: ListTile(
            title:  TextFormField(
              validator: (value){
                if(quesiontype != QuestionType.MCQ.toString().split('.').last){
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return 'Please enter text for this option';
                }
                if(value == _option2Controller.text ||
                value == _option3Controller.text ||
                value == _option4Controller.text){
                  return "Options can not be same";
                }
                return null;
              },
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter first option',
              ),
              controller: _option1Controller,
                  ),
            leading: Radio<String>(
              value: _option1Controller.text,
              groupValue: newQuestion.answer,
              onChanged: (String value) {
                setState(() {
                  newQuestion.answer = value;
                });
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10 ,right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: TextFormField(
              validator: (value){
                if(quesiontype != QuestionType.MCQ.toString().split('.').last){
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return 'Please enter text for this option';
                }
                if(value == _option1Controller.text ||
                    value == _option3Controller.text ||
                    value == _option4Controller.text){
                  return "Options can not be same";
                }
                return null;
              },
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter second option',
              ),
              controller: _option2Controller,
            ),
            leading: Radio<String>(
              value: _option2Controller.text,
              groupValue: newQuestion.answer,
              onChanged: (String value) {
                setState(() {
                  newQuestion.answer = value;
                });
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10 ,right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: TextFormField(
              validator: (value){
                if(quesiontype != QuestionType.MCQ.toString().split('.').last){
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return 'Please enter text for this option';
                }
                if(value == _option1Controller.text ||
                    value == _option2Controller.text ||
                    value == _option4Controller.text){
                  return "Options can not be same";
                }
                return null;
              },
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter third option',
              ),
              controller: _option3Controller,
            ),
            leading: Radio<String>(
              value: _option3Controller.text,
              groupValue: newQuestion.answer,
              onChanged: (String value) {
                setState(() {
                  newQuestion.answer = value;
                });
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10 ,right: 20,bottom: 20 ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: TextFormField(
              validator: (value){
                if(quesiontype != QuestionType.MCQ.toString().split('.').last){
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return 'Please enter text for this option';
                }
                if(value == _option1Controller.text ||
                    value == _option2Controller.text ||
                    value == _option3Controller.text){
                  return "Options can not be same";
                }
                return null;
              },
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter forth option',
              ),
                controller: _option4Controller,
            ),
            leading: Radio<String>(
              value: _option4Controller.text,
              groupValue: newQuestion.answer,
              onChanged: (String value) {
                setState(() {
                  newQuestion.answer = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
  Widget Short_Question_Buttonoption(){
    return Container(
      margin: EdgeInsets.only(top:1 ,left: 20 ,right: 20 , bottom: 19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title:  TextFormField(
              validator: (value){
                if(quesiontype != QuestionType.ShortQuestion.toString().split('.').last){
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return 'Please enter correct answer';
                }
                return null;
              },
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter the Answer',
              ),
              controller: _shortquestionController,
            ),
          ),
        ],
      ),
    );
  }
  Widget chackBox(){
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget> [
           Container(
             height: 60,
             width: 370,
             margin: EdgeInsets.only(top: 7 ,left: 10 ,right: 10),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(30),
               color: Colors.white,
             ),
             child:  new CheckboxListTile(
                 title: const Text('True',
                   style: TextStyle(color: Colors.amber ,),
                 ),
                 controlAffinity: ListTileControlAffinity.leading,
                 value: _isTrue,
                // groupValue: courectanswe,
                 onChanged: (bool value){
                   setState(() {
                     _isTrue = value;
                   });
                   setAnswerForTrueFalse(_isTrue);
                 }
                 ),
           ),
            Container(
              height: 60,
              width: 370,
              margin: EdgeInsets.only(top: 7 ,left: 10 ,right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: new CheckboxListTile(
                  title: const Text('False',
                    style: TextStyle(color: Colors.amber ,),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: !_isTrue,
                  onChanged: (bool value){
                    setState(() {
                      _isTrue = !value;
                    });
                    setAnswerForTrueFalse(_isTrue);
                  }
              ),
            )
          ],
        ),

      ],
    );

  }

  Widget NewQuestionTypes(){
    return Container(
      margin: EdgeInsets.only(top:1 ,left: 10 ,right: 10 , bottom: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Question Type'),
          ),
          ListTile(
            title: const Text('MCQs'),
            leading: Radio<String>(
              value: QuestionType.MCQ.toString().split('.').last,
              groupValue: quesiontype,
              onChanged: (String value) {
                setState(() {
                  quesiontype = value;
                });
              },
            ),
          ), //MCQS
          ListTile(
            title: const Text('True/False'),
            leading: Radio<String>(
              value: QuestionType.TrueFalse.toString().split('.').last,
              groupValue: quesiontype,
              onChanged: (String value) {
                setState(() {
                  setAnswerForTrueFalse(_isTrue);
                  quesiontype = value;
                });
              },
            ),
          ),    //True & False
          ListTile(
            title: const Text('Short Question'),
            leading: Radio<String>(
              value: QuestionType.ShortQuestion.toString().split('.').last,
              groupValue: quesiontype,
              onChanged: (String value) {
                setState(() {
                  quesiontype = value;
                });
              },
            ),
          ),  //Short Question
        ],
      ),
    );
  }

  void nextQuestion()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Please connect to an internet connection!');
      return;
    }
    setState(() {
      isLoading = true;
    });
    var uuid = Uuid();
    newQuestion.id = uuid.v4();
    newQuestion.quizId = newQuiz.Id;
    newQuestion.type = quesiontype;
    newQuestion.marks = int.parse(_questionMarksController.text);
    newQuestion.option1 = _option1Controller.text;
    newQuestion.option2 = _option2Controller.text;
    newQuestion.option3 = _option3Controller.text;
    newQuestion.option4 = _option4Controller.text;
    newQuestion.title = _questionController.text;
    if(newQuestion.type == QuestionType.ShortQuestion.toString().split('.').last){
      newQuestion.answer = _shortquestionController.text;
    }
    setState(() {
      isLoading = false;
    });
    // questions.add(newQuestion);
    // counter++;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateQuestion(
                newQuiz, counter,questions,newQuestion
            )));
  }

  void finishQuiz()async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Please connect to an internet connection!');
      return;
    }
    setState(() {
      isLoading = true;
    });
    var uuid = Uuid();
    newQuestion.id = uuid.v4();
    newQuestion.quizId = newQuiz.Id;
    newQuestion.type = quesiontype;
    newQuestion.marks = int.parse(_questionMarksController.text);
    newQuestion.option1 = _option1Controller.text;
    newQuestion.option2 = _option2Controller.text;
    newQuestion.option3 = _option3Controller.text;
    newQuestion.option4 = _option4Controller.text;
    newQuestion.title = _questionController.text;
    if(newQuestion.type == QuestionType.ShortQuestion.toString().split('.').last){
      newQuestion.answer = _shortquestionController.text;
    }

    questions.add(newQuestion);
    int sum = 0;
    questions.forEach((element) {
      sum += element.marks;
    });
    newQuiz.TotalMarks = sum;
    newQuiz.CreatedAt = DateTime.now();
    var quizJson = newQuiz.toJson();
    await FirebaseFirestore.instance
        .collection('Quizzes')
        .doc(newQuiz.Id)
        .set(quizJson).then((value) {
          for(var item in questions){
            var queJson = item.toJson();
            FirebaseFirestore.instance
                .collection('Questions')
            .doc(item.id).set(queJson);
          }
    });
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => TeacherHome(),
      ),
          (_) => false,
    );
    setState(() {
      isLoading = false;
    });
  }
}

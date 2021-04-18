import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:projectvu/models/answer.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/providers/AttemptProvider.dart';
import 'package:projectvu/student/StudentHome.dart';
import 'package:projectvu/utilities/QuestionType.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AttemptQuiz extends StatefulWidget {
  AttemptQuiz() {}
  @override
  _AttemptQuizState createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<AttemptQuiz> {
  _AttemptQuizState() {}

  Question newQuestion = new Question();
  int correct_answer = 0, totalmarks = 0, quesion_number = 1;
  String quesiontype;
  String quiznumber = "Quiz";
  String givenAnswer = '';
  bool _isTrue = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _option1Controller =
  TextEditingController(text: "option1");
  TextEditingController _option2Controller =
  TextEditingController(text: "option2");
  TextEditingController _option3Controller =
  TextEditingController(text: "option3");
  TextEditingController _option4Controller =
  TextEditingController(text: "option4");
  TextEditingController _questionMarksController = TextEditingController();
  TextEditingController _shortquestionController = TextEditingController();

  int answertype = 0, opstionNumber = 1;
  
  void setAnswerForTrueFalse(bool value) {
    setState(() {
      if (value)
        givenAnswer = "True";
      else
        givenAnswer = "False";
    });
  }

  createQuizeline() {
    // asses the Quiz Model
    Question(
      //  id: ,
      title: _questionController.text,

      option1: _option1Controller.text,
      option2: _option2Controller.text,
      option3: _option3Controller.text,
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
    var count = context.read<AttemptProvider>().Counter;
    if (count == 1) {
      await _showMyDialog();
      return false;
    } else {
      var counter = context.read<AttemptProvider>().Counter;
      var answers = context.read<AttemptProvider>().Answers;
      var attempt = context.read<AttemptProvider>().attempt;
      var ans = answers[counter - 2];
      attempt.marks -= ans.marks;
      attempt.timeStamp = DateTime.now().toString();

      var attJson = attempt.toJson();
      await FirebaseFirestore.instance.collection("Attempts")
      .doc(attempt.id).set(attJson).then((value) async {
        await FirebaseFirestore.instance.collection("Answers")
            .doc(ans.id).delete();
      });

      answers.removeAt(counter - 2);
      counter--;
      context.read<AttemptProvider>().Answers = answers;
      context.read<AttemptProvider>().attempt = attempt;
      context.read<AttemptProvider>().Counter = counter;
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AttemptProvider>().AttemptQuizLoading;
    final newQuiz = context.watch<AttemptProvider>().quiz;
    final counter = context.watch<AttemptProvider>().Counter;
    final questions = context.watch<AttemptProvider>().Questions;
    final remainingTime = context.watch<AttemptProvider>().RemainingTime;
    context.watch<AttemptProvider>().context = context;
    DateTime time = new DateTime(2021, 0, 0, 0, 0, remainingTime, 0);

    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backwardsCompatibility: false,
            backgroundColor: Colors.amber,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Flexible(
                child: Text(
                  newQuiz.Title,
                  overflow: TextOverflow.fade,
                ),
                flex: 3,
              ),
              Text(counter.toString() + '/' + newQuiz.NOQ.toString()),
            ]),
          ),
          body: !loading
              ? SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    child: Form(
                      child: Column(children: [
                        Text("Time Left: " + DateFormat("HH:mm:ss").format(time)),
                        SizedBox(height:20),
                        Card(
                          child: Column(children: [
                            SizedBox(height: 20),
                                question(questions[counter - 1]),
                          setAnswers(questions[counter - 1]),
                          ]),
                        ),
                        SizedBox(height:20),
                        counter != newQuiz.NOQ
                            ?Row(children: [
                          Expanded(
                              child: Container(
                                color: Colors.amber,
                                height: 50,
                                child: ElevatedButton(
                                  // primary: Colors.amber, // background
                                    onPressed: () {
                                      nextQuestion(questions[counter - 1]);
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
                                      finishQuiz(questions[counter - 1]);
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
              : Center(
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

  Widget setAnswers(Question que) {
    if (que.type == QuestionType.MCQ.toString().split('.').last) {
      return radio_Buttonoption(que);
    }
    else if (que.type == QuestionType.TrueFalse.toString().split('.').last) {
      setAnswerForTrueFalse(_isTrue);
      return chackBox();
    }
    else if (que.type == QuestionType.ShortQuestion.toString().split('.').last) {
      return Short_Question_Buttonoption();
    }
    else {
      return SizedBox();
    }
  }

  Widget question(Question que) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '\t\t Q ',
            style: TextStyle(
                color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(que.title),
          ),

        ],
      ),
    );
  }

  Widget radio_Buttonoption(Question que) {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top: 7, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: Text(que.option1),
            leading: Radio<String>(
              value: que.option1,
              groupValue: givenAnswer,
              onChanged: (String value) {
                setState(() {
                  givenAnswer = value;
                });
              },
            ),
          ),
        ),
        Container(
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top: 1, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: Text(que.option2),
            leading: Radio<String>(
              value: que.option2,
              groupValue: givenAnswer,
              onChanged: (String value) {
                setState(() {
                  givenAnswer = value;
                });
              },
            ),
          ),
        ),
        Container(
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top: 1, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: Text(que.option3),
            leading: Radio<String>(
              value: que.option3,
              groupValue: givenAnswer,
              onChanged: (String value) {
                setState(() {
                  givenAnswer = value;
                });
              },
            ),
          ),
        ),
        Container(
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top: 1, left: 10, right: 10, bottom: 19),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: Text(que.option4),
            leading: Radio<String>(
              value: que.option4,
              groupValue: givenAnswer,
              onChanged: (String value) {
                setState(() {
                  givenAnswer = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget Short_Question_Buttonoption() {
    return Container(
      height: 60,
      width: 370,
      margin: EdgeInsets.only(top: 1, left: 10, right: 10, bottom: 19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: TextFormField(
              cursorColor: Colors.amber,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter the Answer',
              ),
              controller: _shortquestionController,
            )
          ),
        ],
      ),
    );
  }

  Widget chackBox() {
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              width: 370,
              margin: EdgeInsets.only(top: 7, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: new CheckboxListTile(
                  title: const Text(
                    'True',
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isTrue,
                  // groupValue: courectanswe,
                  onChanged: (bool value) {
                    setState(() {
                      _isTrue = value;
                    });
                    setAnswerForTrueFalse(_isTrue);
                  }),
            ),
            Container(
              height: 60,
              width: 370,
              margin: EdgeInsets.only(top: 7, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: new CheckboxListTile(
                  title: const Text(
                    'False',
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: !_isTrue,
                  onChanged: (bool value) {
                    setState(() {
                      _isTrue = !value;
                    });
                    setAnswerForTrueFalse(_isTrue);
                  }),
            )
          ],
        ),
      ],
    );
  }

  void nextQuestion(Question que) {
    context.read<AttemptProvider>().AttemptQuizLoading = true;
    var attempt = context.read<AttemptProvider>().attempt;
    var uuid = Uuid();

    Answer ans = new Answer(
        id: uuid.v4(),
        marks: que.answer == givenAnswer ? que.marks : 0,
        text: givenAnswer,
        questionId: que.id,
        attemptId: attempt.id);
    if (que.type == QuestionType.ShortQuestion.toString().split(".").last) {
      ans.text = _shortquestionController.text;
      ans.marks = que.answer == ans.text ? que.marks : 0;
    }
    attempt.marks += ans.marks;
    attempt.timeStamp = DateTime.now().toString();
    var ansJson = ans.toJson();
    var attemptJson = attempt.toJson();
    FirebaseFirestore.instance
        .collection("Answers")
        .doc(ans.id)
        .set(ansJson)
        .then((value) {
      FirebaseFirestore.instance
          .collection("Attempts")
          .doc(attempt.id)
          .set(attemptJson)
          .then((value) {
        context.read<AttemptProvider>().attempt = attempt;

        context.read<AttemptProvider>().Answers.add(ans);
        // var answers = context.read<AttemptProvider>().Answers;
        // if(answers.any((element) => element.id == ans.id)){
        //    var item = answers.where((element) => element.id == ans.id).first;
        //    var index = answers.indexOf(item);
        //    context.read<AttemptProvider>().Answers[index] = ans;
        // }
        // else{
        //   context.read<AttemptProvider>().Answers.add(ans);
        // }

        context.read<AttemptProvider>().Counter++;
        context.read<AttemptProvider>().AttemptQuizLoading = false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AttemptQuiz()));
      });
    });
    // newQuestion.id = uuid.v4();
    // newQuestion.quizId = newQuiz.Id;
    // newQuestion.type = quesiontype;
    // newQuestion.marks = int.parse(_questionMarksController.text);
    // newQuestion.option1 = _option1Controller.text;
    // newQuestion.option2 = _option2Controller.text;
    // newQuestion.option3 = _option3Controller.text;
    // newQuestion.option4 = _option4Controller.text;
    // newQuestion.title = _questionController.text;
    // if(newQuestion.type == QuestionType.ShortQuestion.toString().split('.').last){
    //   newQuestion.answer = _shortquestionController.text;
    // }
    //
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => AttemptQuiz(
    //             newQuiz, counter,questions,newQuestion
    //         )));
  }

  void finishQuiz(Question que) {
    context.read<AttemptProvider>().AttemptQuizLoading = true;
    var attempt = context.read<AttemptProvider>().attempt;
    var remTime = context.read<AttemptProvider>().RemainingTime;
    var quiz = context.read<AttemptProvider>().quiz;
    var uuid = Uuid();

    Answer ans = new Answer(
        id: uuid.v4(),
        marks: que.answer == givenAnswer ? que.marks : 0,
        text: givenAnswer,
        questionId: que.id,
        attemptId: attempt.id);
    if (que.type == QuestionType.ShortQuestion.toString().split(".").last) {
      ans.text = _shortquestionController.text;
      ans.marks = que.answer == ans.text ? que.marks : 0;
    }
    attempt.marks += ans.marks;
    attempt.timeStamp = DateTime.now().toString();
    attempt.timeTaken = quiz.TimeLimit - remTime;
    var ansJson = ans.toJson();
    var attemptJson = attempt.toJson();
    FirebaseFirestore.instance
        .collection("Answers")
        .doc(ans.id)
        .set(ansJson)
        .then((value) {
      FirebaseFirestore.instance
          .collection("Attempts")
          .doc(attempt.id)
          .set(attemptJson)
          .then((value) {
        context.read<AttemptProvider>().attempt = attempt;

        context.read<AttemptProvider>().Answers.add(ans);

        // context.read<AttemptProvider>().Counter++;
        // context.read<AttemptProvider>().AttemptQuizLoading = false;
        context.read<AttemptProvider>().timer.cancel();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => StudentHome(),
          ),
          (context) => false,
        );
      });
    });
  }

  Future<void> _showMyDialog() async {
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
                    'If you close the application, your quiz will be submitted. Do you want to close?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No',
                  style: TextStyle(color: Colors.amber, fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes',
                  style: TextStyle(color: Colors.red, fontSize: 16)),
              onPressed: () {
                context.read<AttemptProvider>().timer.cancel();
                context.read<AttemptProvider>().finishQuiz();
                SystemNavigator.pop();
              },
            )
          ],
        );
      },
    );
  }
}

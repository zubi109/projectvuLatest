import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/models/answer.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/providers/AttemptProvider.dart';
import 'package:projectvu/student/StudentHome.dart';
import 'package:projectvu/teacher/teacher_home.dart';
import 'package:projectvu/utilities/QuestionType.dart';
import 'package:projectvu/utilities/user_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class AttemptQuiz extends StatefulWidget {

  AttemptQuiz() {
  }
  @override
  _AttemptQuizState createState() => _AttemptQuizState();
}

class _AttemptQuizState extends State<AttemptQuiz> {
  _AttemptQuizState(){
  }

  Question newQuestion = new Question();
  int correct_answer = 0, totalmarks = 0, quesion_number = 1;
  String quesiontype;
  String quiznumber = "Quiz";
  String givenAnswer = '';
bool _isTrue = false;
void setAnswerForTrueFalse(bool value){
setState(() {
  if(value)
    givenAnswer = "True";
  else
    givenAnswer = "False";
});
}

  TextEditingController _questionController = TextEditingController();
  TextEditingController _option1Controller = TextEditingController(text: "option1");
  TextEditingController _option2Controller = TextEditingController(text: "option2");
  TextEditingController _option3Controller = TextEditingController(text: "option3");
  TextEditingController _option4Controller = TextEditingController(text: "option4");
  TextEditingController _questionMarksController = TextEditingController();
  TextEditingController _shortquestionController = TextEditingController();

  int answertype = 0, opstionNumber = 1;
//  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // counter++;
    // if(que.id != null){
    //   if(questions.any((element) => element.id == que.id)){
    //     var item = questions.where((element) => element.id == que.id).first;
    //     var index = questions.indexOf(item);
    //     questions[index] = que;
    //   }
    //   else{
    //     questions.add(que);
    //   }
    // }

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
    var count = context.read<AttemptProvider>().Counter;
    if(count == 1){
      await _showMyDialog();
      return false;
    }
    else{
      var counter = context.watch<AttemptProvider>().Counter;
      var answers = context.watch<AttemptProvider>().Answers;
      var attempt = context.watch<AttemptProvider>().attempt;
      var ans = answers[counter - 1];
      attempt.marks -= ans.marks;
      answers.removeAt(counter-1);
      counter--;
      context.watch<AttemptProvider>().Answers = answers;
      context.watch<AttemptProvider>().attempt = attempt;
      context.watch<AttemptProvider>().Counter = counter;
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {

    final loading = context.watch<AttemptProvider>().AttemptQuizLoading;
    final newQuiz = context.watch<AttemptProvider>().quiz;
    final counter = context.watch<AttemptProvider>().Counter;
    final questions = context.watch<AttemptProvider>().Questions;
    final answers = context.watch<AttemptProvider>().Answers;
    final attempt = context.watch<AttemptProvider>().attempt;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
         resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backwardsCompatibility: false,
          backgroundColor: Colors.amber,
          title: Row(children: [
            Flexible(
              child: Text(newQuiz.Title,overflow: TextOverflow.fade,),
              flex: 3,
            ),
            Spacer(),
            Text(counter.toString()),
            Text('/'),
            Text(newQuiz.NOQ.toString()),
          ]),

        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white54,

          child:!loading
          ?SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 45),
            child: Container(
              child: Column(
                  children: [
                    question(questions[counter-1]),
                    setAnswers(questions[counter-1]),
                    counter != newQuiz.NOQ
                    ?GestureDetector(
                      child: Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          border: Border.all(width: 1, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold, color: Colors.brown,),
                          ),
                        ),
                      ),
                      onTap: () {
                        nextQuestion(questions[counter-1]);
                        // setState(() {
                        //   // totalmarks = int.parse(_questionMarksController.text) + totalmarks;
                        //   if(answertype==1){
                        //     if(_questionController.text.isEmpty){
                        //       return Fluttertoast.showToast(msg: 'Question is missing');
                        //     }
                        //     else  if(_option1Controller.text.isEmpty ){
                        //       return  Fluttertoast.showToast(msg: 'option 1 is missing');
                        //     }
                        //     else  if(_option2Controller.text.isEmpty){
                        //       return Fluttertoast.showToast(msg: 'option 2 is missing');
                        //     }
                        //     else  if(_option3Controller.text.isEmpty ){
                        //       return  Fluttertoast.showToast(msg: 'option 3 is missing');
                        //     }
                        //     else  if(_option4Controller.text.isEmpty ){
                        //       return Fluttertoast.showToast(msg: 'option 4 is missing');
                        //     }
                        //     else if(correct_answer==0){
                        //       return Fluttertoast.showToast(msg: 'Correct Answer is missing');
                        //     }
                        //     else{
                        //       quiz_maker_fairbase();
                        //     }
                        //   }
                        //   if(answertype==2){
                        //     stringAnswer=_shortquestionController.text;
                        //     if(_questionController.text.isEmpty){
                        //       return Fluttertoast.showToast(msg: 'Question is missing');
                        //     }
                        //     else  if(_option1Controller.text.isEmpty ){
                        //       return   Fluttertoast.showToast(msg: 'option 1 is missing');
                        //     }
                        //     else  if(_option2Controller.text.isEmpty){
                        //       return Fluttertoast.showToast(msg: 'option 2 is missing');
                        //     }
                        //     else if(stringAnswer=='Null'){
                        //       return Fluttertoast.showToast(msg: 'Correct Answer is missing');
                        //       quesion_number = quesion_number + 1;
                        //     }
                        //   else{
                        //       quiz_maker_fairbase();
                        //       quesion_number = quesion_number + 1;
                        //     }
                        //   }
                        //   if(answertype==3){
                        //     if(_questionController.text.isEmpty){
                        //             return Fluttertoast.showToast(msg: 'Question is missing');}
                        //     else if(_shortquestionController.text.isEmpty){
                        //      return Fluttertoast.showToast(msg: 'Answer is missing');
                        //     }
                        //     else if(stringAnswer=='Null'){
                        //       return Fluttertoast.showToast(msg: 'Correct Answer is missing');
                        //       quesion_number = quesion_number + 1;
                        //     }
                        //     else{
                        //       //stringAnswer=_shortquestionController.text;
                        //       quiz_maker_fairbase();
                        //     }
                        //   }
                        // });
                      },
                    ) //for Add question
                    :GestureDetector(
                  child: Container(
                    height: 80,
                    width: 80,
                    margin:EdgeInsets.only(top: 20) ,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: Text(
                        "Finish",
                        style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold, color: Colors.brown,),
                      ),
                    ),
                  ),
                      onTap: (){
                        finishQuiz(questions[counter-1]);
                      },
                ), //for finish question

              ]),
            ),
          )
          :Expanded(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.amber,
                valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.white54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget setAnswers(Question que){
    if(que.type == QuestionType.MCQ.toString().split('.').last){
      return radio_Buttonoption(que);
    }
    else if(que.type == QuestionType.TrueFalse.toString().split('.').last){
      return chackBox();
    }
    else if(que.type == QuestionType.ShortQuestion.toString().split('.').last){
      return Short_Question_Buttonoption();
    }
    else{
      return SizedBox();
    }
  }

  Widget question(Question que) {
    return Container(
      height: 90,
      margin: EdgeInsets.only(left: 10 ,right: 10),
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
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(que.title),
          ),
          // Text(
          // 'Total_Marks  ' + totalmarks.toString(),
          // style: TextStyle(
          //   color: Colors.grey,
          //   fontSize: 18,
          //   fontWeight: FontWeight.w500),
          // ),
        ],
      ),
    );
  }

  Widget radio_Buttonoption(Question que){
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top: 7 ,left: 10 ,right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),

          child: ListTile(
            title:  Text(que.option1),
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
          margin: EdgeInsets.only(top: 1 ,left: 10 ,right: 10),
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
          margin: EdgeInsets.only(top:1 ,left: 10 ,right: 10),
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
          margin: EdgeInsets.only(top:1 ,left: 10 ,right: 10 ,bottom: 19),
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
  Widget Short_Question_Buttonoption(){
    return Container(
      height: 60,
      width: 370,
      margin: EdgeInsets.only(top:1 ,left: 10 ,right: 10 , bottom: 19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title:  TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your Answer',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
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

  void nextQuestion(Question que){

    context.read<AttemptProvider>().AttemptQuizLoading = true;
    var attempt = context.read<AttemptProvider>().attempt;
    var uuid = Uuid();

    Answer ans = new Answer(
      id: uuid.v4(),
      marks: que.answer == givenAnswer ? que.marks : 0,
      text: givenAnswer,
      questionId: que.id,
      attemptId: attempt.id
    );
    if(que.type == QuestionType.ShortQuestion.toString().split(".").last){
      ans.text = _shortquestionController.text;
      ans.marks = que.answer == ans.text ? que.marks : 0;
    }
    attempt.marks += ans.marks;
    attempt.timeStamp = DateTime.now().toString();
    var ansJson = ans.toJson();
    var attemptJson = attempt.toJson();
    FirebaseFirestore.instance.collection("Answers")
    .doc(ans.id).set(ansJson).then((value) {
      FirebaseFirestore.instance.collection("Attempts")
          .doc(attempt.id).set(attemptJson).then((value) {
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
              context,
              MaterialPageRoute(builder: (context) => AttemptQuiz())
          );
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

  void finishQuiz(Question que){
    context.read<AttemptProvider>().AttemptQuizLoading = true;
    var attempt = context.read<AttemptProvider>().attempt;
    var uuid = Uuid();
    Answer ans = new Answer(
        id: uuid.v4(),
        marks: que.answer == givenAnswer ? que.marks : 0,
        text: givenAnswer,
        questionId: que.id,
        attemptId: attempt.id
    );
    attempt.marks += ans.marks;
    attempt.timeStamp = DateTime.now().toString();
    var ansJson = ans.toJson();
    var attemptJson = attempt.toJson();
    FirebaseFirestore.instance.collection("Answers")
        .doc(ans.id).set(ansJson).then((value) {
      FirebaseFirestore.instance.collection("Attempts")
          .doc(attempt.id).set(attemptJson).then((value) {
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
            context,
            MaterialPageRoute(builder: (context) => AttemptQuiz())
        );
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
                SystemNavigator.pop();
              },
            )
          ],
        );
      },
    );
  }
}

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/teacher/teacher_home.dart';
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
         resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Row(children: [
            Text('Create Question'),
            Spacer(),
            Text(counter.toString()),
            Text('/'),
            Text(newQuiz.NOQ.toString()),
          ]),

        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,

          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 45),
            child: Container(
              child: Column(
                  children: [
                    NewQuestionTypes(),

                    question(),

                    setAnswers(),

                    Container(
                      alignment: Alignment.topCenter,
                     // width: MediaQuery.of(context).size.width * .20,
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(width: 1, color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              counter: SizedBox(),
                              //filled: true,
                              //fillColor: Colors.white60,
                              border: InputBorder.none,
                              hintText: ' Marks  ',
                              hintStyle: TextStyle( fontSize: 12),
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
                          onChanged: (marks) {
                            setState(() {});
                            // print(questionmarks);
                          },
                          controller: _questionMarksController,
                        ),
                      ),
                    ),
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
                        nextQuestion();
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
                        finishQuiz();
                      },
                ), //for finish question

              ]),
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
                color: Colors.grey,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your Question',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
              ),
              controller: _questionController,
            ),
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
  Widget radio_Buttonoption(){
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
            title:  TextField(
                      decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter 1st Option',
                      hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
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
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top: 1 ,left: 10 ,right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter 2nd Option',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
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
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top:1 ,left: 10 ,right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter 3rd Option',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
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
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top:1 ,left: 10 ,right: 10 ,bottom: 19),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter 4th Option',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
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

  void nextQuestion(){
    // String uuid = GUIDGen.generate();
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

    // questions.add(newQuestion);
    // counter++;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateQuestion(
                newQuiz, counter,questions,newQuestion
            )));
  }

  void finishQuiz(){

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
    var quizJson = newQuiz.toJson();
    FirebaseFirestore.instance
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
  }
}

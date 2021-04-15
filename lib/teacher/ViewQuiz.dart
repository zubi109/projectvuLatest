import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/student/student_home_page.dart';
import 'package:projectvu/teacher/teacher_home.dart';
import 'package:projectvu/utilities/QuestionType.dart';
import 'package:projectvu/utilities/user.dart';

class ViewQuiz extends StatefulWidget {
  Quiz quiz;
  ViewQuiz(quiz) {
    this.quiz = quiz;
  }
  @override
  _ViewQuizState createState() => _ViewQuizState();
}

class _ViewQuizState extends State<ViewQuiz> {
  var currenindex = 0;
  var quizlength = 0;

  List<Question> questions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    var snap = await FirebaseFirestore.instance
        .collection("Questions")
        .where('QuizId', isEqualTo: widget.quiz.Id)
        .get();
    List<Question> list = [];
    for (var item in snap.docs) {
      list.add(Question.fromJson(item.data()));
    }
    setState(() {
      questions = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Quiz View'),
      ),
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: boddy(),
    );
  }

  Widget boddy() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(9),
      margin: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 22,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // row for btn
          Container(
            height: 150,
            child: Card(
              elevation: 10,
              semanticContainer: false,
              margin: EdgeInsets.all(6),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Title: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${widget.quiz.Title}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Description: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${widget.quiz.Description}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(children: [
                          Text("Time Limit: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${widget.quiz.TimeLimit}s"),
                        ]),
                        Row(children: [
                          Text("Total Marks: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${widget.quiz.TotalMarks}s"),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(children: [
                          Text("No. of Questions: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${widget.quiz.NOQ}"),
                        ]),
                        Row(children: [
                          Text("Attempts Limit: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${widget.quiz.AttemptsCount}s"),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ), // user info

          Expanded(child: listBuilderWidget()),
        ],
      ),
    );
  }

  Widget listBuilderWidget() {
    if (questions != null) {
      return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: questions == null ? 0 : questions.length,
          itemBuilder: (BuildContext context, int index) {
            return listTile(questions[index]);
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget listTile(Question question) {
    return Card(
      child: Column(
        children: [
          // Text(data["question"]),
          ListTile(
            title: Text('Q: ' + question.title),
          ),
          ListTile(
            title: Text('A: ' + question.answer),
          ),
          ListTile(
            title: Text('Question Type: ' + question.type),
          ),
          ListTile(
            title: Text('Marks: ' + question.marks.toString()),
          ),
          question.type == QuestionType.MCQ.toString().split('.').last
              ? Column(
                  children: [
                    ListTile(
                      title: Text('Option1: ' + question.option1),
                    ),
                    ListTile(
                      title: Text('Option2: ' + question.option2),
                    ),
                    ListTile(
                      title: Text('Option3: ' + question.option3),
                    ),
                    ListTile(
                      title: Text('Option4: ' + question.option4),
                    ),
                  ],
                )
              : SizedBox()

          // ListTile(
          //   title: Text("      " + data["option2"]),
          // ),
          // ListTile(
          //   title: Text("      " + data["option3"]),
          // ),
          // ListTile(
          //   title: Text("      " + data["option4"]),
          // ),
        ],
      ),
    );
  }

// void getSubjects(){
//
//   FirebaseFirestore.instance.collection("Quiz").doc("c++").collection("quiz 1").doc().get().then((value){
//     print(value)
//   });
// }

}

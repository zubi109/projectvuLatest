import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectvu/models/answer.dart';
import 'package:projectvu/models/attempt.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/utilities/QuestionType.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:projectvu/utilities/UserRole.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewResult extends StatefulWidget {
  Quiz quiz;
  ViewResult(quiz) {
    this.quiz = quiz;
  }
  @override
  _ViewResultState createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
  var currenindex = 0;
  var quizlength = 0;
  String role;

  List<Question> questions = [];
  List<Answer> answers = [];
  Attempt attempt;
  int attemptCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    var pref = await SharedPreferences.getInstance();
    var stuId = pref.getString(UserData.uid.toString().split(".").last);

    var qSnap = await FirebaseFirestore.instance
        .collection("Questions")
        .where('QuizId', isEqualTo: widget.quiz.Id)
        .get();
    List<Question> qlist = [];
    for (var item in qSnap.docs) {
      qlist.add(Question.fromJson(item.data()));
    }

    var attSnap = await FirebaseFirestore.instance
        .collection("Attempts")
        .where('QuizId', isEqualTo: widget.quiz.Id)
        .where('StuId', isEqualTo: stuId)
        .orderBy("TimeStamp",descending: true)
        .get();
    List<Attempt> attList = [];
    for (var item in attSnap.docs) {
      attList.add(Attempt.fromJson(item.data()));
    }

    setState(() {
      role = pref.getString(UserData.role.toString().split(".").last);
      questions = qlist;
      attempt = attList.first;
      attemptCount = attList.length;
    });

    var ansSnap = await FirebaseFirestore.instance
        .collection("Answers")
        .where('AttemptId', isEqualTo: attempt.id)
        .get();
    List<Answer> ansList = [];
    for (var item in ansSnap.docs) {
      ansList.add(Answer.fromJson(item.data()));
    }

    setState(() {
      answers = ansList;
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
                        Text("${widget.quiz.Title}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(children: [
                          Text("Time Limit: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)), //time
                          Text("${widget.quiz.TimeLimit}"),
                        ]),
                        Row(children: [
                          Text("Total Marks: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                          Text("${widget.quiz.TotalMarks}"),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(children: [
                          Text("No. of Questions: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                          Text("${widget.quiz.NOQ}"),
                        ]),
                        Row(children: [
                          Text("Attempts Limit: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                          Text(widget.quiz.AttemptsCount == null
                              ? "0"
                              : widget.quiz.AttemptsCount.toString()),
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
  } // quiz info

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
            title: Text(
              'Q: ' + question.title,
              style: TextStyle(color: Colors.amber),
            ),
          ), //Question
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.getString(UserData.role.toString().split('.').last);
          // //role = UserRole.Student.toString().split('.').last;

          ListTile(
            title: role == UserRole.Student.toString().split(".").last
                ? SizedBox()
                : Text('Answer: ' + question.answer),
          ), //Answer
          ListTile(
            title: Text('Question Type: ' + question.type),
          ), //question type
          ListTile(
            title: Text('Marks: ' + question.marks.toString()),
          ), //marks
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
                ) //mcq options
              : SizedBox()
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

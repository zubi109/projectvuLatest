import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/models/answer.dart';
import 'package:projectvu/models/attempt.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/utilities/QuestionType.dart';
import 'package:intl/intl.dart';


class ViewResultForAdmin extends StatefulWidget {
  Quiz quiz;
  String stuId;
  ViewResultForAdmin(quiz,stuId) {
    this.quiz = quiz;
    this.stuId = stuId;
  }
  @override
  _ViewResultForAdminState createState() => _ViewResultForAdminState();
}

class _ViewResultForAdminState extends State<ViewResultForAdmin> {
  var currenindex = 0;
  var quizlength = 0;
  // String role;

  List<Question> questions = [];
  List<Answer> answers = [];
  Attempt attempt;
  int attemptCount;
  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Please connect to an internet connection!');
      return;
    }
    setState(() {
      isLoading = true;
    });
    var stuId = widget.stuId;

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
        .where('StudentId', isEqualTo: stuId)
        .get();
    List<Attempt> attList = [];
    for (var item in attSnap.docs) {
      attList.add(Attempt.fromJson(item.data()));
    }

    setState(() {
      questions = qlist;
      attList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
      attempt = attList.last;
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
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Quiz Result'),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: !isLoading
            ?boddy()
            :Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.amber,
            valueColor:
            new AlwaysStoppedAnimation<Color>(Colors.white54),
          ),
        ),
      ),
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
                          Text("Time Taken: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)), //time
                          Text("${DateFormat("HH:mm:ss").format(DateTime(2021, 0, 0, 0, 0, attempt.timeTaken, 0))}"),
                        ]),
                        Row(children: [
                          Text("Obtained Marks: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                          Text("${attempt.marks}/${widget.quiz.TotalMarks}"),
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
                          Text("Attempts Count: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)),
                          Text(attemptCount == null
                              ? "0/" + widget.quiz.AttemptsCount.toString()
                              : attemptCount.toString() + "/" + widget.quiz.AttemptsCount.toString()),
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
      return CircularProgressIndicator(
        backgroundColor: Colors.amber,
        valueColor:
        new AlwaysStoppedAnimation<Color>(Colors.white54),
      );
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

          getAnswer(question), //Answer
          ListTile(
            title: Text('Question Type: ' + question.type),
          ), //question type
          getObtainedMarks(question), //marks
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

  Widget getAnswer(Question question){
    var ans = answers.where((element) => element.questionId == question.id).first;
    return ListTile(
         title : ans.text != null ?Text('Answer: ' + ans.text) : Text('Answer: '),
      subtitle: ans.text == question.answer ?Text('Correct', style: TextStyle(color: Colors.green)) :Text('Wrong', style: TextStyle(color: Colors.red)),
    );
  }

  Widget getObtainedMarks(Question question){
    var ans = answers.where((element) => element.questionId == question.id).first;
    return ListTile(
      title : Text('${ans.marks}/${question.marks}'),
    );
  }
// void getSubjects(){
//
//   FirebaseFirestore.instance.collection("Quiz").doc("c++").collection("quiz 1").doc().get().then((value){
//     print(value)
//   });
// }

}

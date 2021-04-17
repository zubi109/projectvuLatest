import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/Authentication/Login.dart';
import 'package:projectvu/admin/ViewResultForAdmin.dart';
import 'package:projectvu/models/User.dart';
import 'package:projectvu/models/attempt.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/teacher/CreateQuiz.dart';
import 'package:projectvu/teacher/ViewQuiz.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ViewQuizAttempts extends StatefulWidget {
  Quiz quiz;
  ViewQuizAttempts(Quiz quiz) {
    this.quiz = quiz;
  }

  @override
  _ViewQuizAttemptsState createState() => _ViewQuizAttemptsState();
}

class _ViewQuizAttemptsState extends State<ViewQuizAttempts> {

  bool _isLoding = false;
  List<Attempt> attempts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async {
    setState(() {
      _isLoding = true;
    });
    var snap = await FirebaseFirestore.instance.collection("Attempts").where("QuizId",isEqualTo: widget.quiz.Id).get();
    List<Attempt> list = [];
    for (var item in snap.docs) {
      var att = Attempt.fromJson(item.data());
      if(list.any((element) => element.studentId == att.studentId)){
        var oldAtt = list.where((element) => element.studentId == att.studentId).first;
        var compare = oldAtt.timeStamp.compareTo(att.timeStamp);
        if(compare < 0){
          var index = list.indexOf(oldAtt);
          att.Student = await getStudent(att);
          list[index] = att;
        }
      }
      else{
        att.Student = await getStudent(att);
        list.add(att);
      }
    }
    setState(() {
      attempts = list;
      _isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
          const Text('Attempts List'),
          SizedBox(),
          InkWell(
            child: Center(
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            onTap: () async {
              setState(() {
                // FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => (Login())));
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(UserData.role.toString().split('.').last, "LoggedOut");
            },
          ),
        ])
      ),
      body: _isLoding == false
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: attempts == null ? 0 : attempts.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: FlatButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (ViewResultForAdmin(
                                      widget.quiz,attempts[index].Student.id))));
                        });
                      },
                      child: Center(
                        child: Text(
                          attempts[index].Student.fullName,
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.amber,
                valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.white54),
              ),
            ),
    );
  }
  
  Future<QCUser> getStudent (Attempt attempt) async{
    var snap = await FirebaseFirestore.instance.collection("Student").doc(attempt.studentId).get();
    return QCUser.fromJson(snap.data());
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/Authentication/Login.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/question.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/teacher/CreateQuestion.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:projectvu/utilities/quize_Data_Base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CreateQuiz.dart';
import 'ViewQuiz.dart';

class TeacherHome extends StatefulWidget {
  String speciality;
  Teacherview_subject_view(String tspeciality) {
    this.speciality = tspeciality;
  }

  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {

  bool _isLoding = false;
  List<Quiz> quizzes = [];
  List<Question> questions = [];

  int counter_for_Quiz_number = 1;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    await initData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

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
      _isLoding = true;
    });
    try{
      var snap = await FirebaseFirestore.instance.collection("Quizzes").orderBy('CreatedAt',descending: true).get();
      List<Quiz> list = [];
      for (var item in snap.docs) {
        list.add(Quiz.fromJson(item.data()));
      }
      setState(() {
        quizzes = list;
        _isLoding = false;
      });
    } on Exception catch(e){
      setState(() {
        _isLoding = false;
      });
    }
  }

  void DeleteQuiz(String reference) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Please connect to an internet connection!');
      return;
    }
    setState(() {
      _isLoding = true;
    });
    await FirebaseFirestore.instance
        .collection("Quizzes")
        .doc(reference)
        .delete().then((value) async {
      var queSnap = await FirebaseFirestore.instance
          .collection("Questions")
          .where('QuizId',isEqualTo: reference).get();
      for (var item in queSnap.docs) {
        var que = Quiz.fromJson(item.data());
        await FirebaseFirestore.instance
            .collection("Questions").doc(que.Id).delete();
      }
    });
    var snap = await FirebaseFirestore.instance.collection("Quizzes").get();
    List<Quiz> list = [];
    for (var item in snap.docs) {
      list.add(Quiz.fromJson(item.data()));
    }
    setState(() {
      quizzes = list;
      _isLoding = false;
    });
  }

  void DeleteQuestion(String reference) async {
    setState(() {
      _isLoding = true;
    });

    await FirebaseFirestore.instance
        .collection("Question")
        .doc(reference)
        .delete();
    var snap = await FirebaseFirestore.instance.collection("Questions").get();
    List<Quiz> list = [];
    for (var item in snap.docs) {
      //list.add(Question.fromJson(item.data()));
    }
    setState(() {
      questions = list.cast<Question>();
      _isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
            const Text('Quizzes List'),
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
            ?SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("pull up load");
              }
              else if(mode==LoadStatus.loading){
                body =  CupertinoActivityIndicator();
              }
              else if(mode == LoadStatus.failed){
                body = Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("release to load more");
              }
              else{
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: quizzes == null ? 0 : quizzes.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  // Show a red background as the item is swiped away.
                  background: Container(color: Colors.red),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      // items.removeAt(index);
                      DeleteQuiz(quizzes[index].Id);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: FlatButton(
                        color: counter_for_Quiz_number % 2 == 0
                            ? Colors.amber
                            : Colors.white12, //color: Colors.white,
                        splashColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (ViewQuiz(
                                        quizzes[index]))));
                          });
                        },
                        child: Center(
                          child: Text(
                            quizzes[index].Title,
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.none) {
              Fluttertoast.showToast(msg: 'Please connect to an internet connection!');
              return;
            }
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreateQuiz()));
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber,
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectvu/student/student_home_page.dart';
import 'package:projectvu/teacher/teacher_home.dart';
import 'package:projectvu/utilities/user.dart';


class Editor_Quize_View extends StatefulWidget {
  String quizName;
  String quizid;
  Editor_Quize_View(String quizNamee, quizid) {
    this.quizid = quizid;;
    this.quizName = quizNamee;
  }
  @override
  _Editor_Quize_ViewState createState() => _Editor_Quize_ViewState();
}
class _Editor_Quize_ViewState extends State<Editor_Quize_View> {
  var currenindex=0;
  var quizlength=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Questions List'),
      ),
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                color: Colors.black12,
                onPressed: () {
                  setState(() {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (user_role())));
                  });
                },
                child: Text(
                  "Sign_out",
                  style: TextStyle(fontSize: 10.0, color: Colors.white),
                ),
              ), //sign_out
            ],
          ), // row for btn

          Container(
            height: 90,
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Name"),
                   // Text(UserD.userData.name),
                    Text("Email:"),
                   // Text(UserD.userData.email),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Program:"),
                    //Text(UserD.userData.program),
                    Text("Time"),
                    //Text(UserD.userData.),
                  ],
                ),
              ],
            ),
          ),// user info

          Expanded(child: listBuilderWidget()),

          Container(
            color: Colors.white,
            child:           FlatButton(
              color: Colors.black12,
              // splashColor: Colors.white,
              onPressed: () {
                setState(() {
                  currenindex++;
                });
              },
              child: Text(
                "Next",
                style: TextStyle(fontSize: 30.0, color: Colors.brown),
              ),
            ), // row for btn
          ),
          FlatButton(
            color: Colors.black12,
            splashColor: Colors.white,
            onPressed: () {
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (TeacherHome())));
              });
            },
            child: Text(
              "Finesh",
              style: TextStyle(fontSize: 10.0, color: Colors.white),
            ),
          ), // Quiz List

        ],
      ),
    );
  }

  Widget listBuilderWidget() {
    return Container(
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Quiz')
              .doc(widget.quizid)
              .collection("NOQ")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            QuerySnapshot snapData = snapshot.data;
            if (snapshot.hasData) {
// setState(() {
//   quizlength=snapData.size';'
//
// });
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount:snapshot.hasData? snapData.size:0,
                  itemBuilder: (BuildContext context, int index) {
                    return index<currenindex ?  CircularProgressIndicator() : listTile(snapData.docs[currenindex], index);
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget listTile(data, index) {
    return Column(
      children: [
        Text(data["question"]),
        ListTile(
          title: Text("      " + data["option1"]),
        ),
        ListTile(
          title: Text("      " + data["option2"]),
        ),
        ListTile(
          title: Text("      " + data["option3"]),
        ),
        ListTile(
          title: Text("      " + data["option4"]),
        ),
      ],
    );



  }

// void getSubjects(){
//
//   FirebaseFirestore.instance.collection("Quiz").doc("c++").collection("quiz 1").doc().get().then((value){
//     print(value)
//   });
// }

}

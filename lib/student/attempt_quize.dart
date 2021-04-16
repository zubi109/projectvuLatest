import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectvu/models/quiz.dart';
import 'package:projectvu/student/student_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttemptQuize extends StatefulWidget {
  String quizName;
  String quizuid;
 // String username;
  AttemptQuize(String quiz_id, String quiz_Name, ) {
    this.quizuid = quiz_id;
    this.quizName = quiz_Name;
   // this.username=user_name;
  }
  @override
  _AttemptQuizeState createState() => _AttemptQuizeState();
}

class _AttemptQuizeState extends State<AttemptQuize> {
  var current_index = 0;
  var quizlength = 0;
  int questionselect ,tobtain=0 ,store_obtain_number,totalmarks = 0, quesion_number = 1, quesiontype = 0 ;
  String selected_answer = "0";
  String chstringAnswer = '';
  String select_question='0';
String fetched_corect_answer;

//  TextEditingController _chquestionController = TextEditingController();

  // TextEditingController _choption1Controller = TextEditingController();
  // TextEditingController _choption2Controller = TextEditingController();
  // TextEditingController _choption3Controller = TextEditingController();
  // TextEditingController _choption4Controller = TextEditingController();
  //
  // TextEditingController _chquestionMarksController = TextEditingController();


  setSelectRadio(int val)
  {
    setState(() {
      questionselect=val;
    });
  }

  @override
  void initState() {
    questionselect = 0;
    // TODO: implement initState
    super.initState();
    current_index=0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      body: Container(
      margin:EdgeInsets.only(top: 70),
          child: boddy()
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                color: Colors.black12,
                splashColor: Colors.white,
                onPressed: () {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => (Std())));
                  });
                },
                child: Text(
                  "finish",
                  style: TextStyle(fontSize: 10.0, color: Colors.white),
                ),
              ), // finish
              FlatButton(
                color: Colors.black12,
                onPressed: () {
                  setState(() {
                    FirebaseAuth.instance.signOut();
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => (user_role())));
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
                   // Text(widget.username ,),
                    //Text(UserD.userData.name),
                   // Text("Email:"),
                   // Text(UserD.userData.email),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("timer"),
                 //   Text(UserD.userData.program),
                    //Text("Time"),
                    //Text(UserD.userData.),
                  ],
                ),
              ],
            ),
          ),

          Container(
              height: 200,
              width: 400,
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(10),
              ),

              child: listBuilderWidget()

          ),    //listBuilderWidget() call
          GestureDetector(
            child: Container(
              height: 110,
              width: 110,
              //  padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(width: 1, color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(60),
              ),

              child: Center(
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ), // next button
        ],
      ),
    );
  }

        Widget listBuilderWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Quiz')
              .doc(widget.quizuid)
              .collection("NOQ")
              .snapshots(),

          builder: (BuildContext context, AsyncSnapshot snapshot) {
            QuerySnapshot snapData = snapshot.data;
            if (snapshot.hasData) {
            return current_index +1> snapData.size ? CircularProgressIndicator():
              ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapData.docs[current_index].data();

                    return listTile(snapData.docs[current_index], index);
                  });
            }//else if(snapshot.){store_obtain_number = tobtain.toInt();}
            else {
              store_obtain_number = tobtain.toInt();
              return CircularProgressIndicator();
              // return Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) =>
              //     (Rezult_Creator())));
              //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Rezult_Creator()));

            }
          }),
        );
        }

        Widget listTile(data, index) {
          fetched_corect_answer = data['correct_option'];
          select_question=data["question"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(data["question"]),

        Container(
           height: 30,
           child: Row(
                children: [
                  data["anwerType"] == 1
                      ? RadioButtonoption(data["option1"])
                      : data["anwerType"] == 2
                      ? chackBox_ButtonOption(data["option1"])
                      : data["anwerType"] == 3
                      ? trueFalse_btn_opsion(true, 1)
                      : data["anwerType"]==4
                      ? text_btn_opsion()
                       : "",

                  Text("      " + data["option1"]),
                ],
              ),
         ),

        Container(
          height: 30,
          child: Row(
                children: [
                  data["anwerType"] == 1
                      ? RadioButtonoption(data["option2"])
                      : data["anwerType"] == 2
                      ? chackBox_ButtonOption(data["option2"])
                      : data["anwerType"] == 3
                      ? trueFalse_btn_opsion(true, 1)
                      : data["anwerType"]==4
                      ? text_btn_opsion()
                      : "",

                  Text("      " + data["option2"]),
                ],
              ),
        ),

        Container(
          height: 30,
          child: Row(
              children: [
                data["anwerType"] == 1
                    ? RadioButtonoption(data["option3"])
                    : data["anwerType"] == 2
                    ? chackBox_ButtonOption(data["option3"])
                     : data["anwerType"] == 3
                     ? trueFalse_btn_opsion(true, 1)
                     : data["anwerType"]==4
                     ? text_btn_opsion()
                    : "",

                Text("      " + data["option3"]),
              ],
            ),
        ),

        Container(
          height: 30,
          child: Row(
            children: [
                data["anwerType"] == 1
                    ? RadioButtonoption(data["option4"])
                    : data["anwerType"] == 2
                    ? chackBox_ButtonOption(data["option4"])
                     //: data["anwerType"] == 3
                    //? trueFalse_btn_opsion(data[""])
                    // : data["anwerType"]==4
                    // ? text_btn_opsion()
                    : "",

              Text("      " + data["option4"]),
            ],
          ),
        ),

          ],

    );

  }

  Widget RadioButtonoption(value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected_answer = value;
          fetched_corect_answer == selected_answer ? tobtain=tobtain+2 : SizedBox();
        });
      },
      child: Container(
          height: 15,
          width: 15,
          margin: EdgeInsets.all(7),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Colors.lightGreen)),
          child: Container(
              decoration: BoxDecoration(
                  color:
                      value == selected_answer ? Colors.lightGreen : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1,
                      color: selected_answer == value
                          ? Colors.lightGreen
                          : Colors.white)))),
    );

  }

  Widget chackBox_ButtonOption(value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          fetched_corect_answer == selected_answer ? tobtain=tobtain+2 : SizedBox();
          selected_answer = value;
        });
      },
      child: Container(
        height: 15,
        width: 15,
        margin: EdgeInsets.all(7),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 1, color: Colors.lightGreen)),
        child: Container(
          decoration: BoxDecoration(
              color: value == selected_answer ? Colors.lightGreen : Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(
                  width: 1,
                  color: value == selected_answer
                      ? Colors.lightGreen
                      : Colors.white)),
        ),
      ),
    );
  }

  Widget trueFalse_btn_opsion(bool val, int value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(9),
      margin: EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RadioButtonoption(value),
     // fetched_corect_answer == selected_answer ? tobtain=tobtain+2 : SizedBox();
          // controller = prefs.get("houseNumber");
          Text(
            val ? 'True' : "False",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget text_btn_opsion() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '\t\t\t Enter Your Answer',
          hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        onChanged: (val) {
          setState(() {
            chstringAnswer = val;
          });
        },
      ),
    );
  }

  void quiz_maker_fairbase() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    // ignore: deprecated_member_use
    Firestore.instance
        .collection('Attempt_Quiz_Record')
        .doc(widget.quizName)
        .collection(widget.quizuid)
        .doc()
    .collection(prefs.getString("studentid"))
    .doc()
        .collection("NOQ").add({

      'quizid': widget.quizuid,
     // 'user name': widget.username,
      'student': prefs.getString("studentid"),

      'question': select_question,
      'userselectanswer': selected_answer,


      //'obtainmarks':store_obtain_number,
      'obtainmarks':tobtain.toInt(),
     // 'date': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      setState(() {
      });
    });
  }



// void getSubjects(){
  //
  //   FirebaseFirestore.instance.collection("Quiz").doc("c++").collection("quiz 1").doc().get().then((value){
  //     print(value)
  //   });
  // }

}

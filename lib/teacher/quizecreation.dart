import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/teacher/teacher_home_page1.dart';
import 'package:projectvu/utilities/user.dart';
import 'package:projectvu/utilities/user_model.dart';
import 'package:flutter/material.dart';

class quizcreator extends StatefulWidget {
  String quizName;
  quizcreator(String quizNamee) {
    this.quizName = quizNamee;
  }
  @override
  _quizcreatorState createState() => _quizcreatorState();
}

class _quizcreatorState extends State<quizcreator> {






  int courectanswe = 0, totalmarks = 0, quesion_number = 1, quesiontype = 0;
  String quiznumber = "Quiz";
  String stringAnswer = '';

  TextEditingController _questionController = TextEditingController();

  TextEditingController _option1Controller = TextEditingController();
  TextEditingController _option2Controller = TextEditingController();
  TextEditingController _option3Controller = TextEditingController();
  TextEditingController _option4Controller = TextEditingController();

  int answertype = 0, opstionNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: true,
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

                  Container(
                height: 90,
               margin: EdgeInsets.only(top:1 ,left: 10 ,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    "CREATE YOUR QUIZ",
                    style: TextStyle(fontSize: 24.0 ,fontWeight: FontWeight.bold , color: Colors.amber),
                  ),
                ),
              ), //Text Create Text

                  NewQuestionTypes(),

                  question(),

                  answertype == 1
                      ? radio_Buttonoption()
                        : answertype == 2
                            ? tru_false_Buttonoption()
                             : answertype == 3
                               ? Short_Question_Buttonoption()
                                : SizedBox(),

                  GestureDetector(
                    child: Container(
                      height: 110,
                      width: 110,
                      //padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(width: 1, color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(60),
                      ),

                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold, color: Colors.brown,),
                        ),
                      ),

                    ),
                    onTap: () {

                      setState(() {
                        quesion_number = quesion_number + 1;
                        // totalmarks = int.parse(_questionMarksController.text) + totalmarks;
                        if(answertype<3){
                          if(_questionController.text.isEmpty||_option1Controller.text.isEmpty||_option2Controller.text.isEmpty||_option3Controller.text.isEmpty||_option4Controller.text.isEmpty){
                            Fluttertoast.showToast(msg: 'Something is missing');
                            if(_questionController.text.isEmpty){
                              Fluttertoast.showToast(msg: 'Question is missing');
                            }
                            else  if(_option1Controller.text.isEmpty ){
                              Fluttertoast.showToast(msg: 'option 1 is missing');
                            }
                            else  if(_option2Controller.text.isEmpty){
                              Fluttertoast.showToast(msg: 'option 2 is missing');
                            }
                            else  if(_option3Controller.text.isEmpty ){
                              Fluttertoast.showToast(msg: 'option 3 is missing');
                            }
                            else  if(_option4Controller.text.isEmpty ){
                              Fluttertoast.showToast(msg: 'option 4 is missing');
                            }
                            // else  if(_questionMarksController.text.isEmpty && answertype==1){
                            //   Fluttertoast.showToast(msg: 'please enter the question marks');
                            // }
                          }
                        }
                        else{
                        }
                        quiz_maker_fairbase();

                      });
                    },
                  ), //for Add question
                  GestureDetector(
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
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Teacher_main_function()));     });
                    },
              ), //for finish question

            ]),
          ),
        ),
      ),
    );
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
            '\t\t Q ' + quesion_number.toString() + ':\t\t',
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
                      hintText: 'Enter Your Option',
                      hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
                    ),
              controller: _option1Controller,
                  ),
            leading: Radio<int>(
              value: 1,
              groupValue: courectanswe,
              onChanged: (int value) {
                setState(() {
                  courectanswe=value;
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
                hintText: 'Enter Your Option',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
              ),
              controller: _option2Controller,
            ),
            leading: Radio<int>(
              value: 2,
              groupValue: courectanswe,
              onChanged: (int value) {
                setState(() {
                  courectanswe=value;
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
                hintText: 'Enter Your Option',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
              ),
              controller: _option3Controller,
            ),
            leading: Radio<int>(
              value: 3,
              groupValue: courectanswe,
              onChanged: (int value) {
                setState(() {
                  courectanswe=value;
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
                hintText: 'Enter Your Option',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.amber),
              ),
                controller: _option4Controller,
            ),
            leading: Radio<int>(
              value: 4,
              groupValue: courectanswe,
              onChanged: (int value) {
                setState(() {
                  courectanswe=value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
  Widget tru_false_Buttonoption(){
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          width: 370,
          margin: EdgeInsets.only(top:7 ,left: 10 ,right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: ListTile(
            title: const Text('True',
              style: TextStyle(color: Colors.amber ,),
            ),
            leading: Radio<int>(
              value: 1,
              groupValue: courectanswe,
              onChanged: (int value) {
                setState(() {
                  courectanswe=value;
                  stringAnswer="True";
                  courectanswe==1?_option1Controller.text='True':SizedBox();
                  courectanswe==1?_option2Controller.text='False':SizedBox();
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
            title: const Text('False',
              style: TextStyle(color: Colors.amber),
            ),
            leading: Radio<int>(
              value: 2,
              groupValue: courectanswe,
              onChanged: (int value) {
                setState(() {
                  courectanswe=value;
                  stringAnswer="False";
                  courectanswe==2?_option2Controller.text='False':SizedBox();
                  courectanswe==2?_option1Controller.text='True':SizedBox();
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
              controller: _option1Controller,
            ),
            leading: Radio<int>(
              value: 1,
              groupValue: courectanswe,
              onChanged: (int value) {
                setState(() {
                  courectanswe=value;
                  stringAnswer=_option1Controller.text;
                });
              },
            ),
          ),
        ],
      ),
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
            title: const Text('MCQs'),
            leading: Radio<int>(
              value: 1,
              groupValue: answertype,
              onChanged: (int value) {
                setState(() {
                  answertype = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('True/False'),
            leading: Radio<int>(
              value: 2,
              groupValue: answertype,
              onChanged: (int value) {
                setState(() {
                  answertype = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Short Question'),
            leading: Radio<int>(
              value: 3,
              groupValue: answertype,
              onChanged: (int value) {
                setState(() {
                  answertype = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }


  void quiz_maker_fairbase() async{

    // ignore: deprecated_member_use
    Firestore.instance
        .collection('Quiz')
        .doc(widget.quizName)
        .collection("NOQ").add({
//      'teacherUID': UserD.userData.uid,
      'question': _questionController.text,
      'option1': _option1Controller.text,
      'option2': _option2Controller.text,
      'option3': _option3Controller.text,
      'option4': _option4Controller.text,

      'correct_option': answertype == 1 ?  courectanswe.toString():  stringAnswer,

      'quiznumber': widget.quizName,
      //'date': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      setState(() {
        courectanswe = 0;
        stringAnswer = 'NULL';

        _questionController.clear();
        _option1Controller.clear();
        _option2Controller.clear();
        _option3Controller.clear();
        _option4Controller.clear();
      });
    }).catchError((onError){
      print(onError);
    });
  }



}

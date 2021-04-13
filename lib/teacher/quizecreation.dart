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

 // TextEditingController _questionMarksController = TextEditingController();

  int answertype = 0, opstionNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //margin: EdgeInsets.all(1),
         // padding: EdgeInsets.all(6),
          color: Colors.grey,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 45),
          child: Container(
            child: Column(
             // mainAxisAlignment: MainAxisAlignment.center,
              //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              FlatButton(
                color: Colors.white,
                textColor: Colors.grey,
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => (user_role())));
                },
                child: Text(
                  "Sign_out",
                  style: TextStyle(fontSize: 10.0),
                ),
              ), //sign_out_btn
              NewQuestionTypes(),
              question(),
              answertype == 1
                  ? radio_btn_opsion_call()
                  : answertype == 2
                      ? trueFalse_btn_opsion_call()
                      // : answertype == 3
                      //     ? chack_btn_opsion_call()
                      //     : answertype == 4
                      //         ? text_btn_opsion_call()
                              : SizedBox(),
              // Container(
              //   alignment: Alignment.topCenter,
              //   width: MediaQuery.of(context).size.width * .20,
              //   child: TextFormField(
              //     maxLength: 1,
              //     keyboardType: TextInputType.number,
              //     textAlign: TextAlign.center,
              //     decoration: InputDecoration(
              //         counter: SizedBox(),
              //         filled: true,
              //         fillColor: Colors.white,
              //         border: InputBorder.none,
              //         hintText: ' Marks  ',
              //         hintStyle: TextStyle( fontSize: 12),
              //         contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
              //     onChanged: (marks) {
              //       setState(() {});
              //       // print(questionmarks);
              //     },
              //     controller: _questionMarksController,
              //   ),
              // ),

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
              Container(
                height: 80,
                width: 80,
                //padding: EdgeInsets.all(5.0),
                margin:EdgeInsets.only(top: 20) ,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: GestureDetector(
                 // color: Colors.white,
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Teacher_main_function()));
                    });

                  },
                  child: Center(
                    child: Text(
                      "Finish",
                      style: TextStyle(fontSize: 16.0 , fontWeight: FontWeight.bold, color: Colors.brown,),
                    ),
                  ),

                ),
              ), //for finish question

            ]),
          ),
        ),
      ),
    );
  }

  Widget question() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(9),
      margin: EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Q ' + quesion_number.toString() + ': ',
            style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w900),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your Question',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
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

  Widget radio_btn_opsion(TextEditingController controller, int value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RadioButtonoption(value),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your Option',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget radio_btn_opsion_call() {
    return Container(
      child: Column(
        children: [
          radio_btn_opsion(_option1Controller, 1),
          radio_btn_opsion(_option2Controller, 2),
          radio_btn_opsion(_option3Controller, 3),
          radio_btn_opsion(_option4Controller, 4),
        ],
      ),
    );
  }
  Widget RadioButtonoption(value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          courectanswe = value;
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
                      value == courectanswe ? Colors.lightGreen : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1,
                      color: courectanswe == value
                          ? Colors.lightGreen
                          : Colors.white)))),
    );
  }

  // Widget chack_btn_opsion(TextEditingController controller, int box) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Colors.white,
  //     ),
  //     padding: EdgeInsets.all(5),
  //     margin: EdgeInsets.all(5),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         chackBox_ButtonOption(box),
  //         Expanded(
  //           child: TextField(
  //             controller: controller,
  //             decoration: InputDecoration(
  //               border: InputBorder.none,
  //               hintText: 'Enter Your opstion',
  //               hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Widget chack_btn_opsion_call() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         chack_btn_opsion(_option1Controller, 1),
  //         chack_btn_opsion(_option2Controller, 2),
  //         chack_btn_opsion(_option3Controller, 3),
  //         chack_btn_opsion(_option4Controller, 4),
  //       ],
  //     ),
  //   );
  // }
  // Widget chackBox_ButtonOption(value) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         courectanswe = value;
  //       });
  //     },
  //     child: Container(
  //       height: 15,
  //       width: 15,
  //       margin: EdgeInsets.all(7),
  //       padding: EdgeInsets.all(2),
  //       decoration: BoxDecoration(
  //           shape: BoxShape.rectangle,
  //           border: Border.all(width: 1, color: Colors.lightGreen)),
  //       child: Container(
  //         decoration: BoxDecoration(
  //             color: value == courectanswe ? Colors.lightGreen : Colors.white,
  //             shape: BoxShape.rectangle,
  //             border: Border.all(
  //                 width: 1,
  //                 color: value == courectanswe
  //                     ? Colors.lightGreen
  //                     : Colors.white)),
  //       ),
  //     ),
  //   );
  // }

  Widget trueFalse_btn_opsion_call() {
    return Container(
      child: Column(
        children: [
          trueFalse_btn_opsion(true, 1),
          trueFalse_btn_opsion(false, 2),
        ],
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
          True_False_RadioButtonoption(value),

          // controller = prefs.get("houseNumber");
          Text(
            value ==1 ? 'True' : 'False',
            style: TextStyle(color: Colors.grey),

          ),
        ],
      ),
    );
  }
  Widget True_False_RadioButtonoption(value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value==1 ? stringAnswer="true":stringAnswer="false";
          courectanswe = value;
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
                  value == courectanswe ? Colors.lightGreen : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1,
                      color: courectanswe == value
                          ? Colors.lightGreen
                          : Colors.white)))),
    );
  }
  //
  // Widget text_btn_opsion_call() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         text_btn_opsion(),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget text_btn_opsion() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Colors.white,
  //     ),
  //     padding: EdgeInsets.all(5),
  //     margin: EdgeInsets.all(5),
  //     child: TextField(
  //      //  new controller: ,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: '\t\t\t Enter Your Answer',
  //         hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
  //       ),
  //       onChanged: (val) {
  //         setState(() {
  //             stringAnswer = val;
  //         });
  //       },
  //     ),
  //   );
  // }

  Widget NewQuestionTypes(){
    return Column(
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
    );
  }

  Widget question_Type() {
    return Container(
      child: Column(
       // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
           // mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: radio_Button_For_Question_Type('MCQ', 1),
              ),
              Expanded(
                child: radio_Button_For_Question_Type('true_False', 2),

              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Expanded(
          //       child: radio_Button_For_Question_Type('MCQ', 3),
          //     ),
          //     Expanded(
          //       child: radio_Button_For_Question_Type('Short Question', 4),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
  Widget radio_Button_For_Question_Type(String value, int type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          answertype = type;
        });
      },
      child: Container(
        margin: EdgeInsets.all(7),
        child: Row(
          children: [
            Container(
              height: 15,
              width: 15,
              margin: EdgeInsets.only(right: 9),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Colors.white)),
              child: answertype == type
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.white)),
                    )
                  : SizedBox(),
            ),
            Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
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

      'correct_option': answertype < 2 ?  courectanswe.toString():  stringAnswer,

//      'questionmarks': _questionMarksController.text,

    //  'totalmarks': totalmarks,
      //"anwerType": answertype,[][""

      'quiznumber': widget.quizName,
      //'date': DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      setState(() {
        courectanswe = 0;
        stringAnswer = 'NULL';

        //_questionMarksController.clear();

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

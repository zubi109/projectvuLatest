import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:projectvu/teacher/teacher_home_page1.dart';
import 'package:projectvu/utilities/user_model.dart';

import 'package:flutter/material.dart';

import '../login.dart';
class quizcreator extends StatefulWidget {
   String quizName;
   quizcreator(
       String quizNamee
       ){
     this.quizName= quizNamee;
   }
  @override
  _quizcreatorState createState() => _quizcreatorState();
}

class _quizcreatorState extends State<quizcreator> {

  int    courectanswe=0   ,   totalmarks=0    ,   quesion_number=1    ,   quesiontype=0    ;
  String quiznumber= "Quiz" ;
  String stringAnswer= '' ;

  TextEditingController _questionController = TextEditingController();

  TextEditingController _option1Controller = TextEditingController();
  TextEditingController _option2Controller = TextEditingController();
  TextEditingController _option3Controller = TextEditingController();
  TextEditingController _option4Controller = TextEditingController();

  TextEditingController _questionMarksController = TextEditingController();

  int answertype=0 ,opstionNumber=1 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(2),
        color: Colors.lightGreen,

        child: Column(
          children: [
            FlatButton(
              color: Colors.white,
              textColor: Colors.lightGreen,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>(LogInClass())));
              },
              child: Text("Sign_out",
                style: TextStyle(fontSize: 10.0),),
            ),  //sign_out_btn
            crator(),
            question(),
           answertype==1?radio_btn_opsion_call():
           answertype==2?chack_btn_opsion_call():
           answertype==3? trueFalse_btn_opsion_call():
           answertype==4? text_btn_opsion_call():SizedBox(),
            Container(
              alignment: Alignment.topCenter,
             width: MediaQuery.of(context).size.width*.20,

              child: TextFormField(
                maxLength: 1,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counter: SizedBox(),
                  filled: true,
                  fillColor: Colors.white60,
                  border: InputBorder.none,
                  hintText: ' Marks  ',
                  hintStyle: TextStyle(color: Colors.lightGreen,fontSize: 12),
                  contentPadding: EdgeInsets.fromLTRB(20,10,20,10)
                ),
                onChanged: (marks){
                  setState(() {
                  //  questionmarks=int.parse(marks);
                   // int.parse(marks) > 10 ?questionmarks=int.parse(marks):Text('enter less then 10 marks');
                  }
                  );
                  // print(questionmarks);
                },
                controller: _questionMarksController,
              ),
            ),
            FlatButton(
              color: Colors.white,
              onPressed: () {setState(() {
                  quesion_number=quesion_number+1;
                  totalmarks = int.parse(_questionMarksController.text) + totalmarks;
                });
                quiz_maker_fairbase();              },
              child: Text("Add", style: TextStyle(fontSize: 10.0, color: Colors.lightGreen),
              ),
            ),  //for Add question

          ]
        ),
      ),
    );
  }



  Widget question(){
    return Container(
decoration: BoxDecoration(
  borderRadius:BorderRadius.circular(10),
  color: Colors.white,
),

      padding: EdgeInsets.all(9),
      margin: EdgeInsets.all(9),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Q '+quesion_number.toString()+': ', style: TextStyle(color: Colors.lightGreen, fontSize: 18 ,fontWeight:FontWeight.w900),),
          Expanded(
            child: TextField(
  decoration: InputDecoration(
    border: InputBorder.none,
    hintText: 'Enter Your Question',
    hintStyle: TextStyle(fontSize: 14.0, color: Colors.lightGreen),
  ),
  controller: _questionController,
),
          ),
          Center(child: Expanded(child: Text('Total_Marks  '+totalmarks.toString(), style: TextStyle(color: Colors.lightGreen,fontSize: 18,fontWeight: FontWeight.w900),),)),
        ],
      ),
    );
  }

  Widget radio_btn_opsion(TextEditingController controller, int value){
    return Container(
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RadioButtonoption(value),
          Expanded(
            child:TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your Opstion',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.lightGreen),

              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget radio_btn_opsion_call(){
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
  Widget RadioButtonoption(  value){
    return GestureDetector(
      onTap: (){
        setState(() {
          courectanswe=value;
        });
      },
      child: Container (
            height: 15,
            width: 15,
            margin: EdgeInsets.all(7),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.lightGreen)),
            child: Container(
              decoration: BoxDecoration(
                  color:value==courectanswe ? Colors.lightGreen : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1, color:  courectanswe==value ? Colors.lightGreen : Colors.white))
            )
          ),
    );
  }


  Widget chack_btn_opsion(TextEditingController controller , int box){
    return Container(
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          chackBox_ButtonOption(box),
          Expanded(
            child:TextField(
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your opstion',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.lightGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget chack_btn_opsion_call(){
    return Container(
      child: Column(
        children: [
          chack_btn_opsion(_option1Controller,1),
          chack_btn_opsion(_option2Controller,2),
          chack_btn_opsion(_option3Controller,3),
          chack_btn_opsion(_option4Controller,4),
        ],
      ),
    );
  }
  Widget chackBox_ButtonOption( value){
    return GestureDetector(
      onTap: (){
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
            shape: BoxShape.rectangle,
            border: Border.all(width: 1, color: Colors.lightGreen)),
        child: Container(
          decoration: BoxDecoration(
              color:value==courectanswe ? Colors.lightGreen : Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(
                  width: 1, color: value==courectanswe ? Colors.lightGreen : Colors.white)),
        ),
      ),
    );
  }

  Widget trueFalse_btn_opsion( bool val, int value){
    return Container(
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(9),
      margin: EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RadioButtonoption(value),
         Text(val? 'True':"False", style: TextStyle( color:Colors.lightGreen),),
        ],
      ),
    );
  }
  Widget trueFalse_btn_opsion_call(){
    return Container(
      child: Column(
        children: [
          trueFalse_btn_opsion(true,1),
          trueFalse_btn_opsion(false,2),
        ],
      ),
    );
  }

  Widget text_btn_opsion(){
    return Container(
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: TextField(
       decoration: InputDecoration(
       border: InputBorder.none,
       hintText: 'Enter Your Answer',
         hintStyle: TextStyle(fontSize: 14.0, color: Colors.lightGreen),
       ),

        onChanged: (val){
         setState(() {
           stringAnswer=val;
         });
        },

    ),


    );
  }
  Widget text_btn_opsion_call(){
    return Container(
      child: Column(
        children: [
          text_btn_opsion(),
        ],
      ),
    );
  }

  Widget crator(){
return Container(
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RadioButton('MCQ', 1),
          ),
          Expanded(
            child: RadioButton('MCQ', 2),
          ),

        ],
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RadioButton('true_False' ,3),
          ),
          Expanded(
            child: RadioButton('Short Question' , 4),
          ),
        ],
      ),
    ],
  ),
);
  }
  Widget RadioButton(String value, int type){
  return GestureDetector(
    onTap: (){
      setState(() {
        answertype = type;
      });
    },
    child:  Container(
      margin: EdgeInsets.all(7),
      child: Row(
        children: [
          Container(
            height: 15,
            width: 15,
            margin: EdgeInsets.only(right: 9),
            padding:EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.white)),
            child:answertype==type? Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 1,color: Colors.white)),
            ):SizedBox(),
          ),
          Text(value, style: TextStyle(color:Colors.white),),
        ],
      ),
    ),
  );
}

  void quiz_maker_fairbase(){
    // ignore: deprecated_member_use
    Firestore.instance.collection('Quiz').doc(UserD.userData.speciality).collection(widget.quizName).doc().set({

      'teacherUID':UserD.userData.uid,

      'question':_questionController.text,

      'option1':_option1Controller.text,
      'option2':_option2Controller.text,
      'option3':_option3Controller.text,
      'option4':_option4Controller.text,

      'correct_option': answertype <= 4 ? stringAnswer : courectanswe.toString(),
      'questionmarks': _questionMarksController.text,
      'totalmarks': totalmarks,
      "anwerType":answertype,

      'quiznumber':widget.quizName,
      'date':DateTime.now().millisecondsSinceEpoch

    }).then((value) {
      setState(() {
        courectanswe = 0;
        stringAnswer='';
         _questionMarksController.clear();

         _questionController.clear();
         _option1Controller.clear();
         _option2Controller.clear();
         _option3Controller.clear();
         _option4Controller.clear();
      });
    });
  }

}

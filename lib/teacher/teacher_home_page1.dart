import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectvu/teacher/subject_view.dart';
import 'package:projectvu/utilities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_Subject.dart';


class Teacher_main_function extends StatefulWidget {
  @override
  _Teacher_main_functionState createState() => _Teacher_main_functionState();
}

class _Teacher_main_functionState extends State<Teacher_main_function> {
  int selectedcolor = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        color: Colors.grey,
        child: editorfunction(),
      ),
    );
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
 //   getdetail();
  }

  // void getdetail() async{
  //   User user = await FirebaseAuth.instance.currentUser;
  //       //  User teacher= await FirebaseFirestore.instance.currentTeacher;
  //       if (user != null) {
  //         Firestore.instance.collection('teacher').doc(user.uid).get().then((va) {
  //           setState(() {
  //             UserD.userData.uid = user.uid;
  //             UserD.userData.email = va['email'];
  //             UserD.userData.name = va["name"];
  //             UserD.userData.phone = va["phone"];
  //           });
  //         });
  //
  // }

          //}




  Widget editorfunction(){
    return Container(
     // margin: EdgeInsets.only(top: 10),
    //  padding: EdgeInsets.only(top: 10),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 3, top: 50),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: FlatButton(
                  color: Colors.grey,
                  onPressed: () {
                    setState(() {
                      teacher_Functionalty_List();
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>teacherhome()));
                    });
                  },
                  child: Text(
                    "ViewResult",
                    style: TextStyle(
                        fontSize: 10.0,
                        color:
                            selectedcolor == 1 ? Colors.white : Colors.black),
                  ),
                ), // button 2
              ), //  view result
              Container(
                margin: EdgeInsets.only(bottom: 3, top: 50, left: 9),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: FlatButton(
                  color: Colors.grey,
                  textColor: Colors.black,
                  onPressed: ()  async{
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (user_role())));

                    SharedPreferences prefs=await SharedPreferences.getInstance();
                    prefs.setBool("teacher", false);


                  },
                  child: Text(
                    "Sign_out",
                    style: TextStyle(
                        fontSize: 10.0,
                        color:
                            selectedcolor == 1 ? Colors.white : Colors.black),
                  ),
                ), //sign_out
              ), //sign_out
            ],
          ),

          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 1, right: 10, left: 10, bottom: 1),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white60),
                  borderRadius: BorderRadius.circular(9),
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Name:"),
           //             Text(UserD.userData.name),
                        Text("Email:"),
         //               Text(UserD.userData.email),
                      ],
                    ),
       //              Row(
       //                mainAxisAlignment: MainAxisAlignment.spaceAround,
       //                children: [
       //                  Text("Email:"),
       // //                 Text(UserD.userData.email),
       //                  Text("Time"),
       //                  //Text(UserD.userData.),
       //                ],
       //              ),
                 ],
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white60),
                  borderRadius: BorderRadius.circular(9),
                ),
              //  color: Colors.white60,
                child: Text(
                    '    TEACHER is a full form of, T-Talent, E-Education, A-Attitude, C-Character, H-Harmony, E-Efficient, R-Relation. Wishing you a glorious day!',
                  style: TextStyle(color:Colors.white),),
              ),

            ],
          )),
          teacher_Functionalty_List(), //quiz list
        ],
      ),
    );
  }

  //************************************************************************************************
  //******************************************Teacher function***************************************************
  //*************************************************************************************************
  Widget teacher_Functionalty_List() {
    return Container(
      margin: EdgeInsets.only(top: 2),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: 20,left: 10,right: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  "View quiz",style: TextStyle(fontSize: 32,color:Colors.brown),
                ),
              ),
            ),
            onTap: () async{
              SharedPreferences prefs=await SharedPreferences.getInstance();
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (Teacherview_subject_view(prefs.getString("teacherid")))));
              });
            },
          ),     // view quiz
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(top: 7,left: 10,right: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  "Create Quiz", style: TextStyle(fontSize: 32,color:Colors.brown),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Create_subject()));
              });
            },
          ),    // Create quiz

        ],
      ),
    );
  }
}

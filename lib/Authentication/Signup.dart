import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/Authentication/Login.dart';
import 'package:projectvu/admin/admin_unverified_account.dart';
import 'package:projectvu/models/User.dart';
import 'package:projectvu/student/student_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {


  bool visiblesignup = true,
       visiblesignup2 = true,
      selectroll = true;
  var roll = 0 , uid ;
  // createUserline() {
  //   QCUser user = new QCUser(id: );
  //
  // }

  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confPassController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,

      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:  signUpFields(),
        ),
      ),
    );
  }
//***********************************************************authentication_Sign_up********************************************************

  Future<void> authenticationsignup() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (_passwordController.text == _confPassController.text) {
      await auth
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((v) async {
        if (v.user != null) {
          studentDataEnter(v);
        }
      });
    }
  }


  void studentDataEnter(v) {
    var user =  new QCUser(id: v.user.uid,email: v.user.email, fullName: _fullnameController.text);
    var json =  user.toJson();
    //print('student sign up');
    FirebaseFirestore.instance.collection('Student').doc(v.user.uid).set(json).then((value) {
      setState(() {
        uid= v.user.uid;
        _fullnameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confPassController.clear();
      });
    });
    Navigator.pop(context);
  }


//***********************************************************signUp********************************************************
  Widget signUpFields() {
    return Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                'REGISTRATION',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(left: 10, right: 10),
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        counter: SizedBox(),
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: InputBorder.none,
                        hintText: 'Enter Your Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      // maxLength: 15,
                      controller: _fullnameController,
                    ),
                  ), //name
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: InputBorder.none,
                        hintText: 'Enter Your email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      controller: _emailController,
                    ),
                  ), //email
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      cursorColor: Colors.blueAccent,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(fontSize: 20.0, color: Colors.brown),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              visiblesignup = !visiblesignup;
                            });
                            visiblesignup==true?Fluttertoast.showToast(
                              msg: 'Password Not visible',):Fluttertoast.showToast(
                              msg: 'Password visible',
                            );
                          },
                          child: visiblesignup
                              ? Icon(Icons.remove_red_eye_outlined)
                              : Icon(Icons.remove_red_eye),
                        ),
                      ),
                      obscureText: visiblesignup,
                      controller: _passwordController,
                    ),
                  ), //password

                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      cursorColor: Colors.blueAccent,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: InputBorder.none,
                        hintText: 'Enter confirmation Password',
                        hintStyle: TextStyle(fontSize: 20.0, color: Colors.brown),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              visiblesignup2 = !visiblesignup2;
                            });
                            visiblesignup2==true?Fluttertoast.showToast(
                              msg: 'Password NOT visible',):Fluttertoast.showToast(
                              msg: 'Password visible',
                            );
                          },
                          child: visiblesignup2
                              ? Icon(Icons.remove_red_eye_outlined)
                              : Icon(Icons.remove_red_eye),
                        ),
                      ),
                      obscureText: visiblesignup2,
                      controller: _confPassController,
                    ),
                  ), //confirmation password

                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.brown,
                      onPressed: () {
                        if (_fullnameController.text.isEmpty)
                          return Fluttertoast.showToast(
                              msg: "Pleass Enter Your name");
                        if (_emailController.text.isEmpty)
                          return Fluttertoast.showToast(
                              msg: "Pleass Enter Your Email");
                        if (_passwordController.text.isEmpty)
                          return Fluttertoast.showToast(
                              msg: "Pleass Enter Your Password");
                        if (_confPassController.text.isEmpty)
                          return Fluttertoast.showToast(
                              msg: "Pleass Enter Your Password");
                        // if (_passwordController.text != _confPassController.text)
                        //   return Fluttertoast.showToast(
                        //       msg: "Pleass check Your Password");
                        // if (_programController.text.isEmpty)
                        //   return Fluttertoast.showToast(
                        //       msg: "Pleass Enter Your Password");
                        // if (_semesterController.text.isEmpty)
                        //   return Fluttertoast.showToast(
                        //       msg: "Pleass Select Your Semester");
                        authenticationsignup();
                      },
                      child: Text(
                        "Sign_Up",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ), //signup
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an Account?"),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                      });
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18.0, color: Colors.red),
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}

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
  bool visiblesignup = true, visiblesignup2 = true, selectroll = true;
  var roll = 0, uid;

  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          'Registration Form',
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: signUpFields(),
        ),
      ),
    );
  }
//***********************************************************authentication_Sign_up********************************************************

  Future<void> authenticationsignup() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (_passwordController.text == _confPassController.text) {
      await auth.createUserWithEmailAndPassword(
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
    var user = new QCUser(
        id: v.user.uid,
        email: v.user.email,
        fullName: _fullnameController.text);
    var json = user.toJson();
    //print('student sign up');
    FirebaseFirestore.instance
        .collection('Student')
        .doc(v.user.uid)
        .set(json)
        .then((value) {
      setState(() {
        uid = v.user.uid;
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
        margin: EdgeInsets.only(left: 10, right: 20),      // margin: EdgeInsets.only(top:50 ,left: 20 ,right: 20,bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            // //border: Border.all(width: 1, color: Colors.black),
            // borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: InputBorder.none,
              hintText: 'Enter Your Name',
              hintStyle: TextStyle(fontSize: 16.0, color: Colors.amber),
              prefixIcon: Icon(Icons.person),
            ),
            // maxLength: 15,
            controller: _fullnameController,
          ),
        ), //name

        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            // //border: Border.all(width: 1, color: Colors.black),
            // borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: InputBorder.none,
              hintText: 'Enter Your email',
              hintStyle: TextStyle(fontSize: 16.0, color: Colors.amber),
              prefixIcon: Icon(Icons.email),
            ),
            controller: _emailController,
          ),
        ), //email

        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            // //border: Border.all(width: 1, color: Colors.black),
            // borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextField(
            cursorColor: Colors.blueAccent,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: InputBorder.none,
              hintText: 'Enter Password',
              hintStyle: TextStyle(fontSize: 16.0, color: Colors.amber),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    visiblesignup = !visiblesignup;
                  });
                  visiblesignup == true
                      ? Fluttertoast.showToast(
                          msg: 'Password Not visible',
                        )
                      : Fluttertoast.showToast(
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
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            // //border: Border.all(width: 1, color: Colors.black),
            // borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextField(
            cursorColor: Colors.blueAccent,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: InputBorder.none,
              hintText: 'Enter confirm Password',
              hintStyle: TextStyle(fontSize: 16.0, color: Colors.amber),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    visiblesignup2 = !visiblesignup2;
                  });
                  visiblesignup2 == true
                      ? Fluttertoast.showToast(
                          msg: 'Password NOT visible',
                        )
                      : Fluttertoast.showToast(
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

        GestureDetector(
          child: Container(
            height: 50,
            width: 90,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.amber,
              border: Border.all(width: 2, color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Sign_Up",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
          onTap: () {
            if (_fullnameController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "Pleass Enter Your name");
            if (_emailController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "Pleass Enter Email");
            if (_passwordController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "Pleass Enter Password");
            if (_confPassController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "Pleass Enter confirm Password");
            if (_passwordController.text != _confPassController.text)
              return Fluttertoast.showToast(
                  msg: "Confirm Password not match");
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

        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Already have an account? "),
            InkWell(
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                });
              },
              child: Text(
                "Sign in",
                style: TextStyle(fontSize: 18.0, color: Colors.amber),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}

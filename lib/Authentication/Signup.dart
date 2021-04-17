import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/Authentication/Login.dart';
import 'package:projectvu/admin/admin_unverified_account.dart';
import 'package:projectvu/models/User.dart';

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
          child: Card(child: signUpFields()),
        ),
      ),
    );
  }
//***********************************************************authentication_Sign_up********************************************************

  Future<void> authenticationsignup() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
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
    } catch(signUpError) {
      if(signUpError is PlatformException) {
        if(signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          /// `foo@bar.com` has alread been registered.
        }
      }
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
            if (_fullnameController.text.isEmpty&&_emailController.text.isEmpty&&_passwordController.text.isEmpty&&_confPassController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "All fields Empty ");
            else if (_fullnameController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "Please Enter Your name");
            else if( !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text))
              return Fluttertoast.showToast(
                  msg: ' NOT valid email Format');
           else if (_emailController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "Please Enter Email");
            else if (_passwordController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "Please Enter Password");
            else if (_confPassController.text.isEmpty)
              return Fluttertoast.showToast(
                  msg: "Please Enter confirm Password");
            else if (_passwordController.text != _confPassController.text)
              return Fluttertoast.showToast(
                  msg: "Confirm Password not match");
            else{authenticationsignup();}
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

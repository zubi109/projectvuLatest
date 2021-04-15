import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/teacher/teacher_home.dart';
import 'package:projectvu/utilities/GlobalProperties.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:projectvu/utilities/UserRole.dart';
import 'package:projectvu/utilities/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool visiblelog = true;
  var id, email, name, role;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: loginpage(),
          // child: loginScreen ? loginpage() : signUpFields(),
        ),
      ),
    );
  }

  Future<void> authentication_login() async {
    print(_emailController.text);
    print(_passwordController.text);
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((v) {
      if (v.user != null) {
        id = v.user.uid;
        email = v.user.email;
        // name = v.user.displayName;

        if (Global.AdminEmail == v.user.email)
          role = UserRole.Admin.toString().split('.').last;
        else if (Global.EditorEmail == v.user.email)
          role = UserRole.Editor.toString().split('.').last;
        else
          role = UserRole.Student.toString().split('.').last;

        FirebaseFirestore.instance
            .collection(role)
            .doc(v.user.uid)
            .get()
            .then((d) {
          Map<String, dynamic> userData = d.data();

          if (Global.AdminEmail == v.user.email)
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TeacherHome()));
          else if (Global.EditorEmail == v.user.email)
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TeacherHome()));
          else
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TeacherHome()));
        });
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(UserData.role.toString().split('.').last, role);
    prefs.setString(UserData.uid.toString().split('.').last, id);
    // prefs.setString(UserData.name.toString().split('.').last, name);
    prefs.setString(UserData.email.toString().split('.').last, email);
    // prefs.setBool("IsLoggedIn", true);
    //'name': _nameController.text,
    //  'email': v.user.email,
  }

  Widget loginpage() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(120),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown),
                ),
              ),
            ), // logo title
            Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: InputBorder.none,
                    hintText: 'mike@mike.com',
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                  controller: _emailController,
                ),
              ), // email

              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: InputBorder.none,
                    hintText: '**********',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          visiblelog = !visiblelog;
                        });
                        visiblelog==true?Fluttertoast.showToast(
                          msg: 'Password NOT visible',):Fluttertoast.showToast(
                          msg: 'Password visible',
                        );
                      },
                      child: visiblelog
                          ? Icon(Icons.remove_red_eye_outlined)
                          : Icon(Icons.remove_red_eye),
                    ),
                  ),
                  obscureText: visiblelog,
                  controller: _passwordController,
                ),
              ), //password
              // password

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(1),
                  splashColor: Colors.white,
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please enter email');
                    }
                    if (_passwordController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please enter Password');
                    }
                    else {
                      authentication_login();
                    }
                  },
                  child: Text(
                    "LogIn",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ), //login button
            ]),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't Have an Account?"),
                InkWell(
                  onTap: () {
                    setState(() {
                          Navigator.push(context, MaterialPageRoute(
                          builder: (context) => (signup())));
                          });
                          // loginScreen = false;
                  },
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.deepOrange,
                    ),
                  ),
                )
              ],
            )),
          ],
        ));
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/student/StudentHome.dart';
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: loginpage(),
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
                MaterialPageRoute(builder: (context) => StudentHome()));
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
                color: Colors.amber
                ,
                //border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(120),
              ),
              child: Center(

                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize:32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent.withOpacity(1.0),
                  ),
                ),
              ),
            ), // logo title
            Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                margin: EdgeInsets.all(5),

                decoration: BoxDecoration(
                  // //border: Border.all(width: 1, color: Colors.black),
                  // borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextFormField(
                  cursorColor: Colors.amber,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border: InputBorder.none,
                    hintText: 'user@quizcreator.com',
                    hintStyle: TextStyle(fontSize: 16.0, color: Colors.amber),
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
                ),
               child: TextFormField(
                  cursorColor: Colors.amber,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber)),
                    hintText: '**********',
                    hintStyle: TextStyle(fontSize: 16.0, color: Colors.amber),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          visiblelog = !visiblelog;
                        });
                        visiblelog == true
                            ? Fluttertoast.showToast(
                          msg: 'Password NOT visible',
                        )
                            : Fluttertoast.showToast(
                          msg: 'Password visible',
                        );
                      },
                      child: visiblelog
                          ? Icon(Icons.remove_red_eye_outlined)
                          : Icon(Icons.remove_red_eye),
                    ), ),
                 obscureText: visiblelog,
                 controller: _passwordController,),

              ), // password

              Container(
                height: 50,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  border: Border.all(width: 2, color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (_emailController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please enter email');
                    }
                    if (_passwordController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please enter Password');
                    } else {
                      authentication_login();
                    }
                  },
                  child: Center(
                    child: Text(
                      "LogIn",
                      style: TextStyle(fontSize: 20.0 , color:Colors.blueAccent),
                    ),
                  ),
                ),
              ), //login button
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text("Don't Have an Account?"),
            InkWell(
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (signup())));
                });
                // loginScreen = false;
              },
              child: Text(
                "REGISTER",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.amber,
                ),
              ),
            )
              ],
            ), // for sign_up
          ],
        )
    );
  }
}

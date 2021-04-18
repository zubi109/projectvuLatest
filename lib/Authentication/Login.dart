import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/admin/AdminHome.dart';
import 'package:projectvu/student/StudentHome.dart';
import 'package:projectvu/teacher/teacher_home.dart';
import 'package:projectvu/utilities/GlobalProperties.dart';
import 'package:projectvu/utilities/UserData.dart';
import 'package:projectvu/utilities/UserRole.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool visiblelog = true;
  bool isLoading = false;
  var id, email, name, role;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Card(
        margin: EdgeInsets.all(20),
            child: loginpage()
        ),
      ),
    );
  }

  Future<void> authentication_login() async {
    setState(() {
      isLoading = true;
    });
    print(_emailController.text);
    print(_passwordController.text);
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text
      ).then((v) async {
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

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(UserData.role.toString().split('.').last, role);
          prefs.setString(UserData.uid.toString().split('.').last, id);
          prefs.setString(UserData.email.toString().split('.').last, email);

          FirebaseFirestore.instance
              .collection(role)
              .doc(v.user.uid)
              .get()
              .then((d) {
            Map<String, dynamic> userData = d.data();

            if (Global.AdminEmail == v.user.email)
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AdminHome()));
            else if (Global.EditorEmail == v.user.email)
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TeacherHome()));
            else
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => StudentHome()));
          });
        }
      });
      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      if (e.code == 'firebase_auth') {
        if(e.details['code'] == '"code" -> "user-not-found"'){
          Fluttertoast.showToast(msg:'No user found for that email.');
          setState(() {
            isLoading = false;
          });
        }
        else if (e.details['code'] == 'wrong-password') {
          Fluttertoast.showToast(msg:'Wrong password provided for that user.');
          setState(() {
            isLoading = false;
          });
        }
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg:'No user found for that email.');
        setState(() {
          isLoading = false;
        });
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg:'Wrong password provided for that user.');
        setState(() {
          isLoading = false;
        });
      }
    }
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
                      color: Colors.white.withOpacity(1.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),// logo title
            Theme(
              data: Theme.of(context)
                  .copyWith(primaryColor: Colors.amber),
              child: TextField(
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                  prefixStyle: TextStyle(color: Colors.amber),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber)),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: InputBorder.none,
                  hintText: 'Email',
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.amber),
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                ),
                controller: _emailController,
              ),
            ), // email
            SizedBox(height: 20),
            Theme(
              data: Theme.of(context)
                  .copyWith(primaryColor: Colors.amber),
              child: TextField(
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
            ),
            SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: Container(
                    color: Colors.amber,
                    height: 50,
                    child: ElevatedButton(
                      // primary: Colors.amber, // background
                        onPressed: () {
                          if (_emailController.text.isEmpty && _passwordController.text.isEmpty) {
                            return Fluttertoast.showToast(msg: 'Enter email & Password');
                          }
                          if (_emailController.text.isEmpty) {
                            return Fluttertoast.showToast(msg: 'Please enter email');
                          }
                          else if (_passwordController.text.isEmpty) {
                            Fluttertoast.showToast(msg: 'Please enter Password');
                          }
                          else if( !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text)) {
                            return Fluttertoast.showToast(msg: ' NOT valid email Format');
                          }
                          else {
                            authentication_login();
                          }
                        },
                        child: !isLoading
                            ?Text(
                          "Login",
                          style: TextStyle(fontSize: 22),
                        )
                        :CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)
                          // style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          //       (Set<MaterialState> states) {
                          //     if (states.contains(MaterialState.pressed))
                          //       return Colors.amber;
                          //     return null; // Use the component's default.
                          //   },
                          // )),
                        )
                    ),
                  ))
            ]),// password
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text("Don't Have an Account?  "),

            InkWell(
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (signup())));
                });
                // loginScreen = false;
              },
              child: Text(
                "Register",
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

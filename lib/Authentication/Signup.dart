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
  bool isLoading = false;

  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text(
            'Registration Form',
          ),
        ),
        body: Card(margin: EdgeInsets.all(20), child: signUpFields()),
      ),
    );
  }
//***********************************************************authentication_Sign_up********************************************************

  Future<void> authenticationsignup() async {
    setState(() {
      isLoading = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
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
      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      if (e.code == 'firebase_auth') {
        if(e.details['code'] == '"code" -> "weak-password"'){
          Fluttertoast.showToast(msg:'The password provided is too weak.');
          setState(() {
            isLoading = false;
          });
        }
        else if (e.details['code'] == 'email-already-in-use') {
          Fluttertoast.showToast(msg:'The account already exists for that email.');
          setState(() {
            isLoading = false;
          });
        }
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg:'The password provided is too weak.');
        setState(() {
          isLoading = false;
        });
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg:'The account already exists for that email.');
        setState(() {
          isLoading = false;
        });
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
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
              'Signup',
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
        SizedBox(height: 20),// logo title
        Theme(
          data: Theme.of(context)
              .copyWith(primaryColor: Colors.amber),
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
        SizedBox(height: 20),// logo title
        Theme(
          data: Theme.of(context)
              .copyWith(primaryColor: Colors.amber),
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
        SizedBox(height: 20),// logo title
        Theme(
          data: Theme.of(context)
              .copyWith(primaryColor: Colors.amber),
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
        SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: Container(
                color: Colors.amber,
                height: 50,
                child: ElevatedButton(
                  // primary: Colors.amber, // background
                    onPressed: () {
                      if (_fullnameController.text.isEmpty &&
                          _emailController.text.isEmpty &&
                          _passwordController.text.isEmpty &&
                          _confPassController.text.isEmpty)
                        return Fluttertoast.showToast(msg: "All fields Empty ");
                      else if (_fullnameController.text.isEmpty)
                        return Fluttertoast.showToast(msg: "Please Enter Your name");
                      else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(_emailController.text))
                        return Fluttertoast.showToast(msg: ' NOT valid email Format');
                      else if (_emailController.text.isEmpty)
                        return Fluttertoast.showToast(msg: "Please Enter Email");
                      else if (_passwordController.text.isEmpty)
                        return Fluttertoast.showToast(msg: "Please Enter Password");
                      else if (_confPassController.text.isEmpty)
                        return Fluttertoast.showToast(
                            msg: "Please Enter confirm Password");
                      else if (_passwordController.text != _confPassController.text)
                        return Fluttertoast.showToast(msg: "Confirm Password not match");
                      else {
                        authenticationsignup();
                      }
                    },
                    child: !isLoading
                        ?Text(
                      "Signup",
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
        ]),// logo title
        SizedBox(height: 20),// logo title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have an account?  "),
            InkWell(
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                });
                // loginScreen = false;
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.amber,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

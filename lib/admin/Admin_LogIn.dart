
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/admin/Student_List.dart';
import 'package:projectvu/admin/admin_unverified_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Admin_Home.dart';


class LogIn_Class_for_Admin extends StatefulWidget {
  @override
  _LogIn_Class_for_AdminState createState() => _LogIn_Class_for_AdminState();
}

class _LogIn_Class_for_AdminState extends State<LogIn_Class_for_Admin> {
  bool loginScreen = true,
      visiblelog = true,
      visiblesignup = true,
      visiblesignup2 = true,
      selectroll = true;

  // ..............for date of birth selection show the calendar........................
  String date = 'Select Date of Birth';

  Future<Null> selectTimePicker(BuildContext) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1975),
        lastDate: DateTime.now());
    if (picked != null && picked != date) {
      setState(() {
        date = '${picked.day}-${picked.month}-${picked.year}';
        print(date.toString());
      });
    }
  }

//..........................................................................................

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confPassController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,

      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),


       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),

        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

          child: loginScreen ? loginpage() : signUpFields(),

        ),
      ),
    );
  }

  Future<void> authenticationsignup() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (_passwordController.text == _confPassController.text) {
      await auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ).then((v) async {
        if (v.user != null) {
          adminData(v);
        }
      });
    }
  }

  void adminData(v){
    FirebaseFirestore.instance.collection('admin').doc(v.user.uid).set({
      'uid': v.user.uid,
      'name': _nameController.text,
      'email': v.user.email,
      'phone': _phoneController.text,
       }).then((value) {
      setState(() {
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confPassController.clear();
        loginScreen = true;
      });
    });
  }


//***********************************************************authenticationlogin********************************************************
  Future<void> authenticationlogin() async {
    print(_emailController.text);
    print(_passwordController.text);
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text).then((v) {
      if (v.user != null) {
        print(v.user.uid);
        FirebaseFirestore.instance
            .collection('admin')
            .doc(v.user.uid)
            .get()
            .then((d) {
          Map<String, dynamic> userData = d.data();
          print(userData["phone"]);
          print(userData['uid']);
          print(userData['email']);
          print(userData[date.toString()]);

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => admin_home()));

        });
      }
    });
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setBool("admin", true);
  }

  //********************************************************************************************
//**********************************************Widget's********************************************************
  //********************************************************************************************

  //************************************************************************************************************
//***********************************************************log in page********************************************************
  //**************************************************************************************************************
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
                  style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.w600,color: Colors.brown),
                ),
              ),
            ), // logo title
            Column(
                mainAxisSize: MainAxisSize.min, children: [
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
                        Fluttertoast.showToast(msg: 'Write toast msg here', );
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
                  textColor: Colors.black,
                  padding: EdgeInsets.all(1),
                  splashColor: Colors.white,
                  onPressed: () {
                    if(_emailController.text.length<5){
                      Fluttertoast.showToast(msg: 'Please enter email');
                    }else {
                      authenticationlogin();
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
                          loginScreen = false;
                        });
                      },
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.deepOrange,
                        ),
                      ),
                    )],
                )
            ),
          ],
        ));
  }
//***********************************************************signUp********************************************************
  Widget signUpFields() {
    return Container(
        margin: EdgeInsets.only(left: 1, right: 1),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 70),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                'REGISTRATION',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold , color: Colors.brown),
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(left: 10, right: 10),
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 1),
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
                      controller: _nameController,
                    ),
                  ), //name

                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
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
                    margin: EdgeInsets.only(top: 1, bottom: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: InputBorder.none,
                        hintText: 'Enter Mobile Number',
                        prefixIcon: Icon(Icons.phone_iphone),
                      ),
                      controller: _phoneController,
                    ),
                  ), //phone

                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        FlatButton(
                            child: Text(date),
                            color: Colors.white,
                            textColor: Colors.black,
                            onPressed: () {
                              selectTimePicker(context);
                            }),
                      ],
                    ),
                  ), //DOB

                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              visiblesignup = !visiblesignup;
                            });
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
                    margin: EdgeInsets.only(top: 1, bottom: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: InputBorder.none,
                        hintText: 'Enter confirmation Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              visiblesignup2 = !visiblesignup2;
                            });
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
                    margin: EdgeInsets.only(top: 1, bottom: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.blueAccent,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                     // splashColor: Colors.blueAccent,
                      onPressed: authenticationsignup,
                      child: Text(
                        "Sign_Up",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ), //signup

                  Container(
                      margin: EdgeInsets.only(top: 10 , bottom: 3,left: 170, right: 5),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Have an Account?"),
                          InkWell(
                            onTap: () {
                              setState(() {
                                loginScreen = true;
                              });
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      )),

                ],
              ),
            ),
          ],
        ));
  }

}
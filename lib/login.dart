import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectvu/admin/admin_unverified_account.dart';
import 'package:projectvu/student/student_home_page.dart';
import 'teacher/teacher_home_page1.dart';


class LogInClass extends StatefulWidget {
  @override
  _LogInClassState createState() => _LogInClassState();
}

class _LogInClassState extends State<LogInClass> {
  bool loginScreen = true,
      visiblelog = true,
      visiblesignup = true,
      visiblesignup2 = true,
      selectroll = true;
  var roll = 0;

  // ..............for date of birth selection show the calendar........................
  String date = 'Select Date of Birth';
  String _value;

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

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _confPassController = TextEditingController();
  TextEditingController _programController = TextEditingController();
  TextEditingController _qualificationController = TextEditingController();
  TextEditingController _deportmentController = TextEditingController();
  TextEditingController _specialityController = TextEditingController();
  TextEditingController _desinationController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomPadding: false,

      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(

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
        if(roll==1){
          teacherDataEnter(v);
        }else if(roll == 2){
          studentDataEnter(v);
        }
        }
      });
    }
  }

  void teacherDataEnter(v){
    FirebaseFirestore.instance.collection('user').doc(v.user.uid).set({
      'name': _nameController.text,
      'email': v.user.email,
      'phone': _phoneController.text,
      'Qualification':_qualificationController.text,
      'Deportment':_deportmentController.text,
      'speciality':_specialityController.text,
      'uid': v.user.uid,
      'status':1,
      'role': 1
    }).then((value) {
      setState(() {
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confPassController.clear();
        _specialityController.clear();
        _deportmentController.clear();
        _qualificationController.clear();
        loginScreen = true;
      });
    });
  }

  void studentDataEnter(v){
    //print('student sign up');
    FirebaseFirestore.instance.collection('user').doc(v.user.uid).set({
      'name': _nameController.text,
      'email': v.user.email,
      'phone': _phoneController.text,
      'program': _programController.text,
      'uid': v.user.uid,
      'role': 2 ,
      'status':1,
      'value':_value,
    }).then((value) {
      setState(() {
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confPassController.clear();
        _programController.clear();
        _qualificationController.clear();
        loginScreen = true;
      });
    });
    }   //student data_base

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
            .collection('user')
            .doc(v.user.uid)
            .get()
            .then((d) {
              Map<String, dynamic> userData = d.data();
          print(userData["phone"]);
          print(userData['uid']);
          print(userData['email']);
          print(userData[date.toString()]);

              if(userData['role']==3){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => AdminUnverifiedAccountList()));
                  }
                  else if(userData['role']==2) {
                   Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Std()));
                  }else if(userData['role']==1){
                         Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => Teacher_main_function()));
                        }
        });
      }
    });
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Text(
                'Login',
                style: TextStyle(fontSize: 20.0),
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
                  color: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
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
                  controller: _nameController,
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
                margin: EdgeInsets.only(top: 5, bottom: 5),
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
                margin: EdgeInsets.only(top: 5, bottom: 5),
                padding: EdgeInsets.only(left: 15),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Select Roll",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectroll = true;
                                  roll = 1;
                                });
                              },
                              child: radioButton(selectroll),
                            ),
                            Text(" Teacher   "),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectroll = false;
                                  roll = 2;
                                });
                              },
                              child: radioButton(!selectroll),
                            ),
                            Text(" Student"),

                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ), //roll selection

              roll == 1
                  ? editor()
                  : roll == 2
                      ? student()
                      : SizedBox(),

              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
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
                margin: EdgeInsets.only(top: 5, bottom: 5),
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
                margin: EdgeInsets.only(top: 5, bottom: 5),
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
                  splashColor: Colors.blueAccent,
                  onPressed: authenticationsignup,
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
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(1),
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
    ));
  }


  //*********************************************************student********************************************************
  Widget student() {
    return Container(
      child: Column(
        children: [
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
                hintText: 'Program',
                prefixIcon: Icon(Icons.description),
              ),
              controller: _programController,
            ),
          ), //program

          Container(
            child: DropdownButton<String>(
              isExpanded: true,
              items: [
                DropdownMenuItem<String>(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 5,),
                        Text("Select Semester")
                      ],)
                ),
                DropdownMenuItem<String>(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //  Icon(Icons.search),
                      SizedBox(width: 5,),
                      Text("Semester 1")

                    ],),

                  value:  "Semester 1",
                ),
                DropdownMenuItem<String>(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Icon(Icons.search),
                      SizedBox(width: 5,),
                      Text("Semester 2")
                    ],),
                  value:  "Semester 2",
                ),
                DropdownMenuItem<String>(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //  Icon(Icons.search),
                      SizedBox(width: 5,),
                      Text("Semester 3")
                    ],),
                  value:  "Semester 3",
                ),
                DropdownMenuItem<String>(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Icon(Icons.search),
                      SizedBox(width: 5,),
                      Text("Semester 4")
                    ],),
                  value:  "Semester 4",
                ),
                DropdownMenuItem<String>(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Icon(Icons.search),
                      SizedBox(width: 5,),
                      Text("Semester 5")
                    ],),
                  value:  "Semester 5",
                ),
                DropdownMenuItem<String>(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(Icons.search),
                      SizedBox(width: 5,),
                      Text("Semester 6")
                    ],),
                  value:  "Semester 6",
                ),
                DropdownMenuItem<String>(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Icon(Icons.search),
                      SizedBox(width: 5,),
                      Text("Semester 7")
                    ],),
                  value:  "Semester 7",
                ),
                DropdownMenuItem<String>(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Icon(Icons.search),
                      SizedBox(width: 5,),
                      Text("Semester 8")

                    ],),
                  value:  "Semester 8",
                ),
              ],
              onChanged: (String value){
                setState(() {
                  _value=value;
                  // Fluttertoast.showToast(msg: value);
                });
              },
              hint: Text("Select Items"),
              value: _value,
            ),
          ),
        ],
      ),
    );
  }

  //*********************************************************editor********************************************************
  Widget editor() {
    return Container(
      child: Column(
        children: [
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
                hintText: 'Qualification',
                prefixIcon: Icon(
                  Icons.description,
                ),
              ),
              controller: _qualificationController,
            ),
          ),
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
                hintText: 'Deportment',
                prefixIcon: Icon(
                  Icons.home_work_outlined,
                ),
              ),
              controller: _deportmentController,
            ),
          ),
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
                hintText: 'speciality',
                prefixIcon: Icon(
                  Icons.description,
                ),
              ),
              controller: _specialityController,
            ),
          ),
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
                hintText: 'Desination',
                prefixIcon: Icon(
                  Icons.work_outlined,
                ),
              ),
              controller: _desinationController,
            ),
          ),
        ],
      ),
    );
  }

  //*********************************************************radioButton********************************************************
  Widget radioButton(bool selected) {
    return Container(
      height: 15,
      width: 15,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.black)),
      child: Container(
        decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
                width: 1, color: selected ? Colors.black : Colors.white)),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:projectvu/login.dart';


class Std extends StatefulWidget {
  @override
  _stdState createState() => _stdState();
}

class _stdState extends State<Std> {
 int selectedcolor=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (

          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            color: Colors.black38,

            child: Column(
              children: [
                FlatButton(
                  color:selectedcolor==1? Colors.lightGreen: Colors.white,
                  splashColor: Colors.white,
                  onPressed: () {
                    setState(() {
                     FirebaseAuth.instance.signOut();
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>(LogInClass())));
                    });
                  },
                  child: Text("Sign_out",
                    style: TextStyle(fontSize: 10.0, color: selectedcolor==1?Colors.white:Colors.black),),
                ),

              ],
            ),
          )

      ),
    );
  }
}

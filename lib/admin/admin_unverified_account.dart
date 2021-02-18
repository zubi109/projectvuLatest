import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectvu/login.dart';


class AdminUnverifiedAccountList extends StatefulWidget {
  @override
  _AdminUnverifiedAccountListState createState() => _AdminUnverifiedAccountListState();
}

class _AdminUnverifiedAccountListState extends State<AdminUnverifiedAccountList> {

  int selectedRole = 1  , status_check=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.blueAccent,

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(9),
        margin:EdgeInsets.only(left: 8,right: 8,top: 20,),

        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                FlatButton(
                  color:selectedRole==1?Colors.green: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  splashColor: Colors.white,
                  onPressed: () {
                   setState(() {
                     selectedRole=1;
                   });
                  },
                  child: Text(
                    "Teacher List",
                    style: TextStyle(fontSize: 10.0, color: selectedRole==1?Colors.white:Colors.black),
                  ),
                ),   // Teacher List selectedRole = 1
                FlatButton(
                 color:selectedRole==2? Colors.lightGreen: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black, splashColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      selectedRole=2;
                    });
                  },
                  child: Text("Student List",
                    style: TextStyle(fontSize: 10.0, color: selectedRole==2?Colors.white:Colors.black),),
                ),  // Student list selectedRole = 2
                FlatButton(
                  color:selectedRole==1||selectedRole==2? Colors.lightGreen: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  splashColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>(LogInClass())));

                    });
                  },
                  child: Text("Sign_out",
                    style: TextStyle(fontSize: 10.0, color: selectedRole==1||selectedRole==2?Colors.white:Colors.black),),
                ),  //sign_out

              ],),  // row for list btn

            Expanded(child: listBuilderWidget()),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [

                FlatButton(
                  color:status_check==2?Colors.green: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  splashColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      status_check=2;
                    });
                  },
                  child: Text(
                    "Confirm List",
                    style: TextStyle(fontSize: 10.0, color: status_check==2?Colors.white:Colors.black),
                  ),
                ),   // confirm List selectedRole = 1
                FlatButton(
                  color:status_check==3? Colors.green: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  //padding: EdgeInsets.all(2),
                  //shape: Border.all(width: 10 ),
                  splashColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      status_check=3;
                    });
                  },
                  child: Text("Rejected List",
                    style: TextStyle(fontSize: 10.0, color: status_check==3?Colors.white:Colors.black),),
                ),  // reject list selectedRole = 2
                FlatButton(
                  color:status_check==1? Colors.green: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  splashColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      status_check=1 ;
                    });
                  },
                  child: Text("Pending List",
                    style: TextStyle(fontSize: 10.0, color: status_check==1?Colors.white:Colors.black),),
                ),  // pending list selectedRole = 2

              ],),
          ],
        ),
      ),
    );
  }

Widget listBuilderWidget(){
return  StreamBuilder(
    stream: FirebaseFirestore.instance.collection('user').where('status', isEqualTo:status_check ).where('role', isEqualTo: selectedRole).snapshots(),
    builder: (BuildContext context, AsyncSnapshot snapshot){

      QuerySnapshot snapData = snapshot.data;

     return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount:snapshot.hasData? snapData.size:0,
          itemExtent: 100,
          itemBuilder:(BuildContext context, int index){
            return listTile(snapData.docs[index], index);
          } );
    });
}

Widget listTile(data, index){

  return     Container(
      margin: EdgeInsets.all(2),
      padding:EdgeInsets.all(1),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),

         child: Column(
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Text("Name:"),
                 Text(data["name"]),
                 Text("Phone:"),
                 Text(data["phone"]),
               ],
              ),

             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Text(selectedRole==2?"Program:":"Qualification:"),
                 Text(data[selectedRole==2?"program":"Qualification"]),
                 Text(selectedRole==2?"Semester:":"Deportment:"),
                 Text(data[selectedRole==2?"value":"Deportment"]),
               ],
             ),

             Row(
               mainAxisAlignment: MainAxisAlignment.center,

               children: [
                 FlatButton(
                   height: 18,
                   minWidth: 40,
                   color: Colors.lightGreen,
                   textColor: Colors.black,
                   padding: EdgeInsets.all(1),
                   splashColor: Colors.white,
                   onPressed: () {
                     btn_confirm( data['uid']);
                   },
                   child: Text(
                     "Confirm",
                     style: TextStyle(fontSize: 8.0,color:Colors.white),
                   ),
                 ),    //confirm btn
                 FlatButton(
                   height: 18,
                   minWidth: 40,
                   color: Colors.red,
                   textColor: Colors.black,
                   padding: EdgeInsets.all(1),
                   splashColor: Colors.white,
                   onPressed: () {
                    btn_reject(data['uid']);
                   },
                   child: Text(
                     "Rejected ",
                     style: TextStyle(fontSize: 8.0,color:Colors.white),
                   ),
                 ),   //Rejected  btn

               ],),    //  row for btn

           ],
         ),

    );

}

  void btn_confirm(String data) {
    FirebaseFirestore.instance.collection('user').doc(data).update({
      "status": 2
    });
}
  void btn_reject(String data)  {
    FirebaseFirestore.instance.collection('user').doc(data).update({
      "status": 3
    });

  }
}

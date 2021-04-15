import 'package:flutter/material.dart';
class Rezult_Creator extends StatefulWidget {
  @override
  _Rezult_CreatorState createState() => _Rezult_CreatorState();
}

class _Rezult_CreatorState extends State<Rezult_Creator> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Student Result'),
      ),
      body: Center(
        child: Container(
      color: Colors.grey,
          child: Text("Your Result is"),
        ),
      ),
    );
  }
}

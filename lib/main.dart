import 'package:flutter/material.dart';
import 'package:projectvu/providers/AttemptProvider.dart';
import 'package:projectvu/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttemptProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Quiz maker",
        home: splashScreenclass(),
      ),
    );
  }
}

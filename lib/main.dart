import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectvu/providers/AttemptProvider.dart';
import 'package:projectvu/splashscreen.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(196, 159, 45, 1), //or set color with: Color(0xFF0000FF)
    ));
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

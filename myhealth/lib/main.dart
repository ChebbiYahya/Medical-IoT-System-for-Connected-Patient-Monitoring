import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myhealth/Home.dart';
import 'package:myhealth/HomePatient.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePatient(),
    );
  }
}

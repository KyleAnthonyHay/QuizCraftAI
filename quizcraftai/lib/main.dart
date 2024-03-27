// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:firebase_core/firebase_core.dart'; //Firebase library
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quizcraftai/pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/LandingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// const firebaseConfig = {
//   "apiKey": "AIzaSyDgLRWHjZeO4KrZm38I8y3DduVeuMPy5ho",
//   "authDomain": "groupproject1-team4.firebaseapp.com",
//   "projectId": "groupproject1-team4",
//   "storageBucket": "groupproject1-team4.appspot.com",
//   "messagingSenderId": "358360390437",
//   "appId": "1:358360390437:web:2aef2bb594ec00901fd8cc",
//   "measurementId": "G-S6QJWGSPGP"
// };

//May need to be Future
void main() async {
  await dotenv.load(fileName: ".env");

  //Firebase

  WidgetsFlutterBinding.ensureInitialized();
if (kIsWeb) {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDgLRWHjZeO4KrZm38I8y3DduVeuMPy5ho",
            appId: "1:358360390437:web:2aef2bb594ec00901fd8cc",
            messagingSenderId: "358360390437",
            projectId: "groupproject1-team4"));
  }
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) =>
            LoginPage(), //Could add another screen to decide if user logged in or not
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => LandingPage(),
      },
    );
  }
}

Future<void> storeUserGrade(String userId, String quizId, String testName, int testScore) async {
  try {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    await userRef.collection('tests').add({
      'quizId': quizId,
      'name': testName,
      'grade': testScore,
    });
  } catch (e) {
    print('Error');
  }
}

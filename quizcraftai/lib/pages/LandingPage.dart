// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizcraftai/pages/TestPage.dart';
import 'package:quizcraftai/pages/login_page.dart';
import 'package:quizcraftai/pages/viewGrades.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
            );
          },
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ViewGradePage()),
                  (route) => false,
                );
              },
            child: const Text('View Quiz Grades'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(),
            InputTextForm(),
            GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/login",
                    (route) => false,
                  );
                },
                child: Container(
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text("Sign out",
                          style: TextStyle(color: Colors.white)),
                    ))),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "QuizCraft AI!",
            style: style,
          ),
        ));
  }
}

class InputTextForm extends StatefulWidget {
  const InputTextForm({super.key});

  @override
  State<InputTextForm> createState() => _InputTextForm();
}

class _InputTextForm extends State<InputTextForm> {
  //this controller will retrieve the user's input
  final formController = TextEditingController();

  @override
  void dispose() {
    //clean up
    formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: formController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a topic for a quiz!'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to TestPage with the quizTopic
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TestPage(quizTopic: formController.text),
                ),
              );
            },
            child: const Text('Lets Go!'),
          ),
        ),
      ],
    );
  }
}

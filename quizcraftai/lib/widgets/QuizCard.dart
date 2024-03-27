// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:quizcraftai/services/database_service.dart';

class QuizCard extends StatefulWidget {
  final List<dynamic>
      quizContent; // JSON converted to a list of maps. Each map represents a lsit of questions
  const QuizCard({super.key, required this.quizContent, required this.quizName});
  final String quizName;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  List<int> _selectedOptions =
      []; // Tracks the index of the selected option for each question
  List<bool> _correctAnswers =
      []; // Tracks whether the selected option is correctt
  double quizAverage = 0.0;
  String? userId;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedOptions and _correctAnswers with -1 and false respectively for each question
    _selectedOptions = List.generate(widget.quizContent.length, (index) => -1);
    _correctAnswers =
    List.generate(widget.quizContent.length, (index) => false);
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  void didUpdateWidget(covariant QuizCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quizContent.length != oldWidget.quizContent.length) {
      // Update _selectedOptions and _correctAnswers based on the new content length
      _selectedOptions =
          List.generate(widget.quizContent.length, (index) => -1);
      _correctAnswers =
          List.generate(widget.quizContent.length, (index) => false);
    }
  }

  void _handleSelection(
      int questionIndex, int optionIndex, String correctAnswer) {
    setState(() {
      // Update the selected option for the question
      _selectedOptions[questionIndex] = optionIndex;
      // Check if the selected option is correct
      _correctAnswers[questionIndex] = widget.quizContent[questionIndex]
              ['options'][optionIndex] ==
          correctAnswer;

      print(_selectedOptions);
      print(_correctAnswers);
    });
  }

//test function to make sure the list contains all the correct tests + their info
Future<void> printTestNames() async {
  DatabaseService databaseService = DatabaseService();
  List<TestGrade> testGrades = await databaseService.getUserTestGrades(userId!);
  for (TestGrade testGrade in testGrades) {
    print(testGrade.testName);
  }
}

  // calculate quiz average
  void calculateQuizAverage(List<bool> correctAnswers) {
    int correctAnswersCount = correctAnswers.where((element) => element).length;
    quizAverage = correctAnswersCount / correctAnswers.length * 100;
  }

  void handleQuizSubmit() {
    calculateQuizAverage(_correctAnswers);
    print(quizAverage);

    // Show a full-screen dialog with the congratulatory message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text(
              'You have completed the quiz with a score of $quizAverage!'),
        );
        
      },
      
    );
  }

  @override
  Widget build(BuildContext context) {
   DatabaseService databaseService = DatabaseService(); // Create an instance of DatabaseService
    return Flexible(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.quizContent.length,
              itemBuilder: (BuildContext context, int questionIndex) {
                var question = widget.quizContent[questionIndex];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['question'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...List.generate(question['options'].length,
                            (optionIndex) {
                          return CheckboxListTile(
                            title: Text(question['options'][optionIndex]),
                            value:
                                _selectedOptions[questionIndex] == optionIndex,
                            onChanged: (bool? value) {
                              _handleSelection(questionIndex, optionIndex,
                                  question['correct_answer']);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20), // Adjusted for better spacing
          ElevatedButton(
            onPressed: () {
              print("Submitting quiz");
              handleQuizSubmit();
            if (userId != null) {
                databaseService.addTestGrades(userId!, "", widget.quizName, quizAverage); // Call addTestGrades method with the user's ID
                printTestNames();
              } else {
                print("User is not logged in");
              }            },
            child: Text('Submit Quiz!'),
          ),
          const SizedBox(height: 20), // Adjusted for better spacing
        ],
      ),
    );
  }
}

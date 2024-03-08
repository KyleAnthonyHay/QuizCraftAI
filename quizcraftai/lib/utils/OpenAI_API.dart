import 'dart:developer';
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:quizcraftai/pages/LandingPage.dart';
import 'package:quizcraftai/pages/viewGrades.dart';
import 'package:quizcraftai/widgets/QuizCard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAI_API extends StatefulWidget {
  final String quizTopic; // Add this line
  const OpenAI_API({super.key, required this.quizTopic});

  @override
  State<OpenAI_API> createState() => _OpenAI_APIState();
}

class _OpenAI_APIState extends State<OpenAI_API> {
  // CLASS VARIABLES
  late OpenAI openAI;
  String? openAIKey = dotenv.env['APIKEY'];
  String quiz = "Press the button to generate a quiz";
  List<Map<String, dynamic>> quizData = [];
  late String quizTopic;

  // CLASS METHODS
  @override
  void initState() {
    openAI = OpenAI.instance.build(token: openAIKey!);
    quizTopic = widget.quizTopic; // Assign the quizTopic from the widget
    super.initState();
  }

  Future<void> sendPrompt() async {
    var text =
        "Create a 5 question multiple choice quiz about $quizTopic in JSON format. The name of the quiz is 'quiz' Organize the questions in question objects called 'question'. Each question object should have a question field, an 'options' field, and a 'correct_answer' field.";

    if (text.trim().isEmpty) {
      return;
    }

    var response = await openAI.onCompletion(
        request: CompleteText(
      prompt: text,
      model: Gpt3TurboInstruct(),
      maxTokens: 1000,
    ));

    if (response != null && response.choices.isNotEmpty) {
      setState(() {
        // convert the response to a JSON
        var decodedResponse = jsonDecode(response.choices.first.text);
        quizData = List<Map<String, dynamic>>.from(decodedResponse['quiz']);

        quiz = response.choices.first.text; //old implementation
        print(quiz); // Debugging line to print the quiz
      });
    } else {
      setState(() {
        quiz = "Failed to generate quiz. Please try again.";
        quizData = [];
      });
    }
  }

  // UI
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
                    MaterialPageRoute(builder: (context) => LandingPage()),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () async {
                  await sendPrompt();
                },
                child: Text('Generate Quiz'),
              ),
            ),
            QuizCard(quizContent: quizData, quizName: quizTopic),
          ],
        )));
  }
}
//
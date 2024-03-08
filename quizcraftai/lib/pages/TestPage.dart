import 'package:flutter/material.dart';
import 'package:quizcraftai/utils/OpenAI_API.dart';

class TestPage extends StatefulWidget {
  final String quizTopic; // Added quizTopic as a final String

  const TestPage({super.key, required this.quizTopic});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OpenAI_API(quizTopic: widget.quizTopic),
      ),
    );
  }
}

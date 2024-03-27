import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizcraftai/services/database_service.dart';
import 'package:quizcraftai/pages/LandingPage.dart'; 

class ViewGradePage extends StatefulWidget {
  const ViewGradePage({super.key});

  @override
  _ViewGradePageState createState() => _ViewGradePageState();
}

class _ViewGradePageState extends State<ViewGradePage> {
  late Future<List<TestGrade>> gradesFuture;
  String? userId;

  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    gradesFuture = _databaseService.getUserTestGrades(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Grades'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LandingPage()), // Navigate to the home component
              );
            },
            icon: const Icon(Icons.home), // Icon for the home button
          ),
        ],
      ),
      body: FutureBuilder<List<TestGrade>>(
        future: gradesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<TestGrade> grades = snapshot.data!;
            return ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                TestGrade grade = grades[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.grade),
                    title: Text(
                      grade.testName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Score: ${grade.testScore}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
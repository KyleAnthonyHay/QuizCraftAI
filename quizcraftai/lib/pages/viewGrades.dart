import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizcraftai/services/database_service.dart';
import 'package:quizcraftai/pages/LandingPage.dart'; 

class ViewGradePage extends StatefulWidget {
  const ViewGradePage({Key? key}) : super(key: key);

  @override
  _ViewGradePageState createState() => _ViewGradePageState();
}

class _ViewGradePageState extends State<ViewGradePage> {
  late Future<List<TestGrade>> gradesFuture;
  String? userId;

  DatabaseService _databaseService = DatabaseService();

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
        title: Text('View Grades'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()), // Navigate to the home component
              );
            },
            icon: Icon(Icons.home), // Icon for the home button
          ),
        ],
      ),
      body: FutureBuilder<List<TestGrade>>(
        future: gradesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.grade),
                    title: Text(
                      grade.testName,
                      style: TextStyle(fontWeight: FontWeight.bold),
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
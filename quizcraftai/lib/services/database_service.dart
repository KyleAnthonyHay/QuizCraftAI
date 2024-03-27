import 'package:cloud_firestore/cloud_firestore.dart';

const String TEST_GRADES_COLLECTION_REF = "testGrades";
const String USERS_COLLECTION_REF = "users";

class DatabaseService{
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;
    DatabaseService() {
    _usersRef = _firestore.collection(USERS_COLLECTION_REF);
  }
Future<List<TestGrade>> getUserTestGrades(String userId) async {
  QuerySnapshot querySnapshot = await _firestore.collection(USERS_COLLECTION_REF).doc(userId).collection(TEST_GRADES_COLLECTION_REF).get();
  List<TestGrade> testGrades = querySnapshot.docs.map((test) {
    return TestGrade(
      quizId: test['quizId'],
      testName: test['testName'],
      testScore: test['testScore'],
    );
  }).toList();

  return testGrades;
}


  void addTestGrades(String userId, String quizId, String testName, double testScore) async{
      // _testGradesRef.add(grade);
          try {
    DocumentReference userDocRef = _usersRef.doc(userId).collection(TEST_GRADES_COLLECTION_REF).doc();
      await userDocRef.set({
        'quizId': quizId,
        'testName': testName,
        'testScore': testScore,
      });
    } catch (e) {
      print('Error: $e');
    }
  }

}

//add test grade to make retrieving the user grades easier
class TestGrade {
  final String quizId;
  final String testName;
  final double testScore;

  TestGrade({
    required this.quizId,
    required this.testName,
    required this.testScore,
  });
}
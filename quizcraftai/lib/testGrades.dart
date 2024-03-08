import "package:cloud_firestore/cloud_firestore.dart";

class testGrades{
  List<Map<String, Object?>> testScores;

  testGrades({
    required this.testScores,
  });
  
  factory testGrades.fromJson(Map<String, Object?> json) {
    return testGrades(
      testScores: (json['testScores'] as List<Object?>).cast<Map<String, Object?>>(),
    );
  }

Map<String, Object?> toJson(){
    return {
      'testScores': testScores,
    };
  }

}

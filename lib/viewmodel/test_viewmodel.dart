import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<Map<String, dynamic>> quizQuestions = [];
  Map<int, String> userAnswers = {};
  int examDuration = 20; // ✅ FIXED: Forced to 20 minutes

  Future<void> loadTest(String setId) async {
    isLoading = true;
    notifyListeners();

    try {
      final db = FirebaseFirestore.instance;

      // 1. Fetch ALL Questions for this Set
      final qSnapshot = await db
          .collection('questions')
          .where('setId', isEqualTo: setId)
          .get();

      // 2. Convert to List
      List<Map<String, dynamic>> allQuestions = qSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          ...data,
          'id': doc.id,
          'options': data['options'] is List ? data['options'] : [],
        };
      }).toList();

      // 3. ✅ SHUFFLE & TAKE 30
      allQuestions.shuffle(); // Randomize order every time
      if (allQuestions.length > 30) {
        quizQuestions = allQuestions.sublist(0, 30); // Take first 30
      } else {
        quizQuestions = allQuestions; // Take all if less than 30
      }
    } catch (e) {
      print("Error loading test: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int questionIndex, String selectedOption) {
    userAnswers[questionIndex] = selectedOption;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/question_service.dart';

class TestViewModel extends ChangeNotifier {
  final QuestionService _service = QuestionService();
  final _db = FirebaseFirestore.instance;

  bool _isLoading = true;
  List<Map<String, dynamic>> _quizQuestions = [];
  final Map<int, String> _userAnswers = {};

  // New State variables for Admin settings
  int _examDuration = 0; // in minutes

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get quizQuestions => _quizQuestions;
  Map<int, String> get userAnswers => _userAnswers;
  int get examDuration => _examDuration;

  Future<void> loadTest(String setId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch Set Details (Duration & Limit)
      final setDoc = await _db.collection('practice_sets').doc(setId).get();
      final setData = setDoc.data();

      _examDuration = setData?['duration'] ?? 30; // Default 30 mins
      int questionsPerExam =
          setData?['questionsPerExam'] ?? 20; // Default 20 Qs

      // 2. Fetch ALL questions from the pool
      List<Map<String, dynamic>> allQuestions = await _service
          .getQuestionsForSet(setId);

      // 3. Shuffle
      allQuestions.shuffle();

      // 4. Slice based on Admin Limit
      // If pool has 100, and limit is 30, takes 30.
      // If pool has 10, and limit is 30, takes 10.
      _quizQuestions = allQuestions.take(questionsPerExam).toList();

      _userAnswers.clear();
    } catch (e) {
      print("Error loading test: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectAnswer(int questionIndex, String answer) {
    _userAnswers[questionIndex] = answer;
    notifyListeners();
  }

  Map<String, dynamic> submitTest() {
    int correct = 0;
    int wrong = 0;
    int skipped = 0;

    for (int i = 0; i < _quizQuestions.length; i++) {
      final String? userAnswer = _userAnswers[i];
      final String correctAnswer = _quizQuestions[i]['correctAnswer'] ?? "";

      if (userAnswer == null || userAnswer.isEmpty) {
        skipped++;
      } else if (userAnswer.trim() == correctAnswer.trim()) {
        correct++;
      } else {
        wrong++;
      }
    }

    double obtainedMarks = (correct * 1.0) - (wrong * 0.25);

    return {
      'totalQuestions': _quizQuestions.length,
      'correct': correct,
      'wrong': wrong,
      'skipped': skipped,
      'score': obtainedMarks,
    };
  }
}

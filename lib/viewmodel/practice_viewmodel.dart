import 'package:flutter/foundation.dart';
import '../services/question_service.dart';

class PracticeViewModel extends ChangeNotifier {
  // Access the service that talks to Firestore
  final QuestionService _service = QuestionService();

  // State variables
  bool _isLoading = true;
  List<Map<String, dynamic>> _sets = [];

  // Getters for the UI to access state
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get sets => _sets;

  /// Fetch practice sets based on difficulty ('easy', 'medium', 'hard')
  Future<void> fetchSets(String difficulty) async {
    _isLoading = true;
    notifyListeners(); // Tell UI to show loading spinner

    try {
      // Call the service we updated earlier
      _sets = await _service.getPracticeSets(difficulty);
    } catch (e) {
      print("Error fetching sets: $e");
      _sets = []; // On error, return empty list so app doesn't crash
    }

    _isLoading = false;
    notifyListeners(); // Tell UI to show the data
  }
}

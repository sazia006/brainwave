import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionService {
  final _db = FirebaseFirestore.instance;

  // 1. Get Practice Sets (for the Sets List view)
  Future<List<Map<String, dynamic>>> getPracticeSets(String difficulty) async {
    try {
      final snap = await _db
          .collection("practice_sets")
          .where("difficulty", isEqualTo: difficulty)
          .orderBy('createdAt', descending: true)
          .get();

      // Return a list of sets with their Document ID included
      return snap.docs.map((d) {
        final data = d.data();
        data['id'] =
            d.id; // Critical: Add the doc ID so we can query questions later
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching sets: $e");
      return [];
    }
  }

  // 2. Get Questions for a specific Set (for the Test View)
  Future<List<Map<String, dynamic>>> getQuestionsForSet(String setId) async {
    try {
      final snap = await _db
          .collection("questions")
          .where("setId", isEqualTo: setId) // Filter by the linked Set ID
          .get();

      return snap.docs.map((d) => d.data()).toList();
    } catch (e) {
      print("Error fetching questions: $e");
      return [];
    }
  }
}

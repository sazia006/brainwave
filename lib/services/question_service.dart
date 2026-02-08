import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Get Practice Sets (for the Sets List view)
  Future<List<Map<String, dynamic>>> getPracticeSets(String difficulty) async {
    try {
      // ✅ This query requires the Composite Index you created:
      // Index: Collection 'practice_sets' -> Fields: 'difficulty' Asc + 'createdAt' Desc
      final snap = await _db
          .collection("practice_sets")
          .where("difficulty", isEqualTo: difficulty)
          .orderBy('createdAt', descending: true)
          .get();

      return snap.docs.map((d) {
        final data = d.data();
        // ✅ CRITICAL: Add the document ID ('id') to the map.
        // The UI needs this ID to pass it to the TestView later.
        data['id'] = d.id;
        return data;
      }).toList();
    } catch (e) {
      // If you see "failed-precondition", it means the Index is still building or missing.
      print("Error fetching sets: $e");
      return [];
    }
  }

  // 2. Get Questions for a specific Set (for the Test View)
  Future<List<Map<String, dynamic>>> getQuestionsForSet(String setId) async {
    try {
      final snap = await _db
          .collection("questions")
          .where(
            "setId",
            isEqualTo: setId,
          ) // Filters questions linked to this set
          .get();

      return snap.docs.map((d) {
        final data = d.data();
        data['id'] =
            d.id; // Helpful if you need to track specific question IDs later
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching questions: $e");
      return [];
    }
  }
}

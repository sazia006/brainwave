import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionService {
  final _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getSets(String level) async {
    final snap = await _db
        .collection("question_sets")
        .where("level", isEqualTo: level)
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }
}

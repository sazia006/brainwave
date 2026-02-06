import 'package:cloud_firestore/cloud_firestore.dart';

class AIRecommendationService {
  Future<Map<String, dynamic>> getRecommendation(String userId) async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("analytics")
        .doc("performance")
        .get();

    final data = snap.data()!["accuracy_by_subject"];

    String weakSubject = data.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;

    int accuracy = data[weakSubject];

    String level;

    if (accuracy < 70) {
      level = "easy";
    } else if (accuracy < 85) {
      level = "medium";
    } else {
      level = "hard";
    }

    return {"subject": weakSubject, "level": level};
  }
}

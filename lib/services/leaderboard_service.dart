import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Fetch top 50 users sorted by points
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    try {
      final snapshot = await _db
          .collection('users')
          .orderBy(
            'points',
            descending: true,
          ) // Ensure you have this field in Firestore
          .limit(50)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  String? get currentUid => _auth.currentUser?.uid;
}

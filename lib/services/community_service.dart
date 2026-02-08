import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch groups from Firestore
  Future<List<Map<String, dynamic>>> getGroups() async {
    try {
      final snapshot = await _db
          .collection('community_groups')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }
}

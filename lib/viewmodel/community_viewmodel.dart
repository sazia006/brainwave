import 'package:flutter/foundation.dart';
import '../services/community_service.dart';

class CommunityViewModel extends ChangeNotifier {
  final CommunityService _service = CommunityService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _groups = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get groups => _groups;

  CommunityViewModel() {
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    _isLoading = true;
    notifyListeners();

    _groups = await _service.getGroups();

    // Fallback Dummy Data if Firestore is empty (so UI doesn't look broken)
    if (_groups.isEmpty) {
      _groups = [
        {
          'name': 'Flutter Devs',
          'description': 'Learn Flutter together',
          'members': 120,
        },
        {
          'name': 'AI Enthusiasts',
          'description': 'Discussing ML & AI trends',
          'members': 85,
        },
        {
          'name': 'Exam Prep',
          'description': 'Daily mock tests discussion',
          'members': 200,
        },
      ];
    }

    _isLoading = false;
    notifyListeners();
  }
}

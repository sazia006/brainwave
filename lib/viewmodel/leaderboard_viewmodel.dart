import 'package:flutter/foundation.dart';
import '../services/leaderboard_service.dart';

class LeaderboardViewModel extends ChangeNotifier {
  final LeaderboardService _service = LeaderboardService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _leaderboard = [];
  int _userRank = 0;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get leaderboard => _leaderboard;
  int get userRank => _userRank;

  LeaderboardViewModel() {
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    _isLoading = true;
    notifyListeners();

    _leaderboard = await _service.getLeaderboard();

    // If empty, add dummy data so UI looks good for demo
    if (_leaderboard.isEmpty) {
      _leaderboard = [
        {'name': 'Fatima Rahman', 'points': 9850},
        {'name': 'Rahim Khan', 'points': 9720},
        {'name': 'Ayesha Sultana', 'points': 9580},
        {'name': 'Karim Ahmed', 'points': 9340},
        {'name': 'Nazia Islam', 'points': 9210},
        {'name': 'Imran Hossain', 'points': 9080},
        {'name': 'Sadia Begum', 'points': 8950},
      ];
    }

    // Find current user's rank (simple client-side logic)
    final uid = _service.currentUid;
    if (uid != null) {
      // In a real app, you'd match UIDs. Here we default to 0 if not found.
      _userRank =
          _leaderboard.indexWhere((element) => element['uid'] == uid) + 1;
    }

    _isLoading = false;
    notifyListeners();
  }
}

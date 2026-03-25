import 'package:flutter/foundation.dart';
import '../models/team.dart';

class GameProvider extends ChangeNotifier {
  final List<Team> _teams = [];

  List<Team> get teams => List.unmodifiable(_teams);

  void addTeam(String name, List<String> playerNames) {
    _teams.add(Team(
      id: '${DateTime.now().millisecondsSinceEpoch}_${_teams.length}',
      name: name,
      players: playerNames
          .where((n) => n.trim().isNotEmpty)
          .map((n) => Player(
                id: '${DateTime.now().microsecondsSinceEpoch}_$n',
                name: n.trim(),
              ))
          .toList(),
    ));
    notifyListeners();
  }

  void removeTeam(String teamId) {
    _teams.removeWhere((t) => t.id == teamId);
    notifyListeners();
  }

  void updateScore(String teamId, int hole, int? score) {
    final idx = _teams.indexWhere((t) => t.id == teamId);
    if (idx == -1) return;
    _teams[idx].scores[hole] = score;
    notifyListeners();
  }

  void toggleDoubleStroke(String teamId, int hole) {
    final idx = _teams.indexWhere((t) => t.id == teamId);
    if (idx == -1) return;
    _teams[idx].doubleStrokes[hole] = !_teams[idx].doubleStrokes[hole];
    notifyListeners();
  }

  List<Team> getRanking() {
    final sorted = List<Team>.from(_teams);
    sorted.sort((a, b) => a.totalScore.compareTo(b.totalScore));
    return sorted;
  }
}

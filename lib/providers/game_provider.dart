import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/team.dart';
import '../data/questions.dart';

class GameProvider extends ChangeNotifier {
  final List<Team> _teams = [];
  final List<bool> _photosTaken = List.filled(18, false);
  static const _key = 'game_state';
  static const _photosKey = 'photos_taken';

  List<Team> get teams => List.unmodifiable(_teams);
  List<bool> get photosTaken => List.unmodifiable(_photosTaken);

  // Call once at startup to restore saved data
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _teams.clear();
      _teams.addAll(list.map((j) => Team.fromJson(j)));
    }
    final photosRaw = prefs.getString(_photosKey);
    if (photosRaw != null) {
      final list = jsonDecode(photosRaw) as List;
      for (int i = 0; i < 18; i++) {
        _photosTaken[i] = list[i] as bool;
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_teams.map((t) => t.toJson()).toList()));
    await prefs.setString(_photosKey, jsonEncode(_photosTaken));
  }

  void markPhotoTaken(int hole) {
    _photosTaken[hole] = true;
    notifyListeners();
    _save();
  }

  Future<void> reset() async {
    _teams.clear();
    for (int i = 0; i < 18; i++) _photosTaken[i] = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_photosKey);
    notifyListeners();
  }

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
    _save();
  }

  void removeTeam(String teamId) {
    _teams.removeWhere((t) => t.id == teamId);
    notifyListeners();
    _save();
  }

  void updateScore(String teamId, int hole, int? score) {
    final idx = _teams.indexWhere((t) => t.id == teamId);
    if (idx == -1) return;
    _teams[idx].scores[hole] = score;
    notifyListeners();
    _save();
  }

  void toggleDoubleStroke(String teamId, int hole) {
    final idx = _teams.indexWhere((t) => t.id == teamId);
    if (idx == -1) return;
    _teams[idx].doubleStrokes[hole] = !_teams[idx].doubleStrokes[hole];
    notifyListeners();
    _save();
  }

  void setQuestionResult(String teamId, int questionIndex, bool? correct) {
    final idx = _teams.indexWhere((t) => t.id == teamId);
    if (idx == -1) return;
    final team = _teams[idx];

    team.questionResults[questionIndex] = correct;
    team.powerups.removeWhere((p) => p.questionIndex == questionIndex);

    if (correct == true) {
      team.powerups.add(PowerupEntry(
        questionIndex: questionIndex,
        name: kQuestions[questionIndex].powerup,
        isPowerDown: kQuestions[questionIndex].isPowerDown,
      ));
    }

    notifyListeners();
    _save();
  }

  void usePowerup(String teamId, int questionIndex) {
    final idx = _teams.indexWhere((t) => t.id == teamId);
    if (idx == -1) return;
    final entry = _teams[idx]
        .powerups
        .where((p) => p.questionIndex == questionIndex && !p.used)
        .firstOrNull;
    if (entry != null) {
      entry.used = true;
      notifyListeners();
      _save();
    }
  }

  List<Team> getRanking() {
    final sorted = List<Team>.from(_teams);
    sorted.sort((a, b) => a.totalScore.compareTo(b.totalScore));
    return sorted;
  }
}

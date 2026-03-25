class Player {
  final String id;
  String name;
  Player({required this.id, required this.name});
}

class Team {
  final String id;
  String name;
  List<Player> players;
  final List<int?> scores;
  final List<bool> doubleStrokes;

  Team({
    required this.id,
    required this.name,
    required this.players,
  })  : scores = List.filled(18, null),
        doubleStrokes = List.filled(18, false);

  int get totalScore {
    int total = 0;
    for (int i = 0; i < 18; i++) {
      final s = scores[i];
      if (s != null) {
        total += doubleStrokes[i] ? s * 2 : s;
      }
    }
    return total;
  }

  int get holesPlayed => scores.where((s) => s != null).length;
}

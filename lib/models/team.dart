class Player {
  final String id;
  String name;

  Player({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory Player.fromJson(Map<String, dynamic> j) =>
      Player(id: j['id'], name: j['name']);
}

class PowerupEntry {
  final int questionIndex;
  final String name;
  final bool isPowerDown;
  bool used;

  PowerupEntry({
    required this.questionIndex,
    required this.name,
    this.isPowerDown = false,
    this.used = false,
  });

  Map<String, dynamic> toJson() => {
        'questionIndex': questionIndex,
        'name': name,
        'isPowerDown': isPowerDown,
        'used': used,
      };

  factory PowerupEntry.fromJson(Map<String, dynamic> j) => PowerupEntry(
        questionIndex: j['questionIndex'],
        name: j['name'],
        isPowerDown: j['isPowerDown'] ?? false,
        used: j['used'] ?? false,
      );
}

class Team {
  final String id;
  String name;
  List<Player> players;
  final List<int?> scores;
  final List<bool> doubleStrokes;
  final List<bool?> questionResults;
  final List<PowerupEntry> powerups;

  Team({
    required this.id,
    required this.name,
    required this.players,
    List<int?>? scores,
    List<bool>? doubleStrokes,
    List<bool?>? questionResults,
    List<PowerupEntry>? powerups,
  })  : scores = scores ?? List.filled(18, null),
        doubleStrokes = doubleStrokes ?? List.filled(18, false),
        questionResults = questionResults ?? List.filled(9, null),
        powerups = powerups ?? [];

  int get totalScore {
    int total = 0;
    for (int i = 0; i < 18; i++) {
      final s = scores[i];
      if (s != null) total += doubleStrokes[i] ? s * 2 : s;
    }
    return total;
  }

  int get holesPlayed => scores.where((s) => s != null).length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'players': players.map((p) => p.toJson()).toList(),
        'scores': scores,
        'doubleStrokes': doubleStrokes,
        'questionResults': questionResults,
        'powerups': powerups.map((p) => p.toJson()).toList(),
      };

  factory Team.fromJson(Map<String, dynamic> j) => Team(
        id: j['id'],
        name: j['name'],
        players: (j['players'] as List)
            .map((p) => Player.fromJson(p))
            .toList(),
        scores: (j['scores'] as List).map((s) => s as int?).toList(),
        doubleStrokes:
            (j['doubleStrokes'] as List).map((d) => d as bool).toList(),
        questionResults:
            (j['questionResults'] as List).map((r) => r as bool?).toList(),
        powerups: (j['powerups'] as List)
            .map((p) => PowerupEntry.fromJson(p))
            .toList(),
      );
}

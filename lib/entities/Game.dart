

class Game {
  String gameNumber = '';

  String numbers = '';

  DateTime createdAt = DateTime.now();

  Game({this.gameNumber = '', required this.numbers});

  Game.fromMap(Map<String, dynamic> map) {
    gameNumber = map['gameNumber'];
    numbers = map['numbers'];
    createdAt = DateTime.fromMicrosecondsSinceEpoch(map['createdAt']);
  }

  Map<String, dynamic> toMap() => {
    'gameNumber': gameNumber,
    'numbers': numbers,
    'createdAt': createdAt.microsecondsSinceEpoch
  };
}

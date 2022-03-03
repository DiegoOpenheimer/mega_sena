
import 'package:mega_sena/entities/Game.dart';
import 'package:rxdart/rxdart.dart';

class Data {
  bool loading = false;
  List<Game> games = [];
  List<Game> filteredGames = [];
  String error = '';
}

mixin GameData {

  BehaviorSubject<Data> _data = BehaviorSubject.seeded(Data());
  Stream<Data> get streamData => _data.stream;
  Data get data => _data.value!;

  void addEvent({ bool loading = false, String error = '', List<Game>? games, List<Game>? filteredGames }) {
    _data.add(
      _data.value!
        ..loading = loading
        ..error = error
        ..games = games ?? _data.value!.games
        ..filteredGames = filteredGames != null ? filteredGames : games ?? _data.value!.games
    );
  }

  void dispose() {
    _data.close();
  }

}
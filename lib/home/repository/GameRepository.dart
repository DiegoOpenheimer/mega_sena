import 'package:mega_sena/entities/Game.dart';

abstract class GameRepository {

  static const String KEY = 'Game';

  Future<Game> save(Game game);
  Future<List<Game>> list();
  Future<void> delete(Game game);
}

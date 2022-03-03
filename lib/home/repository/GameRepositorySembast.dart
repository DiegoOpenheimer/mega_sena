import 'dart:async';

import 'package:mega_sena/entities/Game.dart';
import 'package:mega_sena/home/repository/GameRepository.dart';
import 'package:mega_sena/services/database/MegaSenaDB.dart';
import 'package:sembast/sembast.dart';

class GameRepositorySembast implements GameRepository {
  final MegaSenaDB _megaSenaDB = MegaSenaDB();
  final store = intMapStoreFactory.store(GameRepository.KEY);

  Future<Database> get open => _megaSenaDB.open();

  @override
  Future<Game> save(Game game) async {
    await store.add(await open, game.toMap());
    return game;
  }

  @override
  Future<List<Game>> list() async {
    var records = await store.find(await open, finder: Finder(
    sortOrders: [SortOrder('createdAt', false)]
    ));
    return records.map((snapshot) => Game.fromMap(snapshot.value)).toList();
  }

  @override
  Future<void> delete(Game game) async {
    await store.delete(await open,
        finder: Finder(
            filter: Filter.equals(
                'createdAt', game.createdAt.microsecondsSinceEpoch)));
  }
}

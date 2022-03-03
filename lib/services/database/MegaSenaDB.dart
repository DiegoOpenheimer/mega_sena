import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class MegaSenaDB {
  String dbPath = 'mega_sena.db';
  DatabaseFactory databaseFactory = databaseFactoryIo;
  Database? _database;

  Future<Database> open() async {
    if (_database == null) {
      Directory applicationDirectory = await getApplicationDocumentsDirectory();
      _database = await databaseFactory.openDatabase(join(applicationDirectory.path, dbPath));
    }
    return _database!;
  }
}

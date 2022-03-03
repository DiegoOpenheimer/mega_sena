import 'package:mega_sena/home/repository/GameRepository.dart';
import 'package:mega_sena/home/repository/GameRepositorySembast.dart';

enum TypeGameRepository { SEMBAST }

typedef GameRepository Builder();

class GameRepositoryFactory {

  static Map<TypeGameRepository, Builder> _types = {
    TypeGameRepository.SEMBAST: _buildSembast,
  };

  static GameRepository resolve(TypeGameRepository type) {
    Builder? builder = _types[type];
    if (builder != null) {
      return builder();
    }
    throw Exception("Factory not create with $type");
  }

  static GameRepository _buildSembast() => GameRepositorySembast();
}

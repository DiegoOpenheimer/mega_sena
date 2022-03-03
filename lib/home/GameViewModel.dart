import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_sena/home/DataHelper.dart';
import 'package:mega_sena/home/GameData.dart';
import 'package:mega_sena/home/repository/GameRepository.dart';

import 'package:mega_sena/entities/Game.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';

class GameViewModel with GameData {
  static const int AMOUNT_OF_VALUES_DEFAULT = 6;
  static const int MAX_AMOUNT_OF_VALUES_DEFAULT = 15;
  static const int MAX_NUMBER_GAMES = 60;

  List<DataHelper> dataHelper = [];
  final GameRepository gameRepository;
  ValueNotifier<int> amountValues = ValueNotifier(AMOUNT_OF_VALUES_DEFAULT);
  ValueNotifier<List<Game>> games = ValueNotifier([]);
  ValueNotifier<List<String>> generatedValues = ValueNotifier([]);
  ValueNotifier<bool> isFilled = ValueNotifier(false);
  PublishSubject<String> message$ = PublishSubject();
  PublishSubject<String> searchField$ = PublishSubject();
  StreamSubscription? _streamSearchText;

  GameViewModel({required this.gameRepository}) {
    for (int i = 0; i < AMOUNT_OF_VALUES_DEFAULT; i++) {
      dataHelper.add(
          DataHelper(controller: TextEditingController(), typedValue: false, key: Key('input_game_$i')));
    }
  }

  /// listening for search game.
  void listenSearchGame() {
    _streamSearchText?.cancel();
    _streamSearchText = searchField$.stream
        .debounceTime(const Duration(milliseconds: 300))
        .listen((value) {
      List<Game> newFiltered = data.games.where((game) {
        return game.numbers.contains(value) || game.gameNumber.contains(value);
      }).toList();
      addEvent(filteredGames: newFiltered);
    });
  }

  /// close search
  void closeSearch() {
    addEvent(games: data.games);
  }

  /// load games from repository
  Future<void> loadGames() async {
    addEvent(loading: true);
    try {
      List<Game> games = await gameRepository.list();
      addEvent(games: games);
    } catch (e) {
      addEvent(loading: false, error: 'Falha ao carregar jogos');
    }
  }

  /// clear fields on screen create game
  void clearFields() {
    dataHelper.forEach((helper) {
      helper.controller.clear();
      helper.typedValue = false;
    });
    isFilled.value = false;
  }

  /// create or remove component to insert number
  void setAmountValues(double amountValues) {
    int value = amountValues.toInt() - this.amountValues.value;
    if (amountValues.toInt() < dataHelper.length) {
      while (amountValues.toInt() < dataHelper.length) {
        dataHelper.removeLast();
      }
    } else {
      for (int i = 0; i < value; i++) {
        dataHelper.add(
          DataHelper(
            controller: TextEditingController(),
            typedValue: false,
            key: Key('input_game_${dataHelper.length + i}')
          )
        );
      }
    }
    this.amountValues.value = amountValues.toInt();
  }

  /// listening events change text field.
  void changeText(String text, DataHelper dataHelper) {
    dataHelper.typedValue = text != "";
  }

  /// generated values and put in TextEditingController
  void generated() {
    var random = Random();
    for (var data in dataHelper) {
      if (data.typedValue) {
        continue;
      }
      String? newValue;
      while (newValue == null) {
        String value = (random.nextInt(MAX_NUMBER_GAMES) + 1).toString();
        var indexFound = dataHelper.indexWhere(
            (DataHelper dataHelper) => dataHelper.controller.text == value);
        if (indexFound == -1) {
          newValue = value;
        }
      }
      data.controller.text = newValue;
      newValue = null;
    }
    isFilled.value = true;
  }

  /// operation to save a Game.
  Future<void> save({String? gameNumber}) async {
    try {
      List<String> values = dataHelper
          .where((element) => element.controller.text != "")
          .map((e) => e.controller.text)
          .toList();
      if (values.length < AMOUNT_OF_VALUES_DEFAULT) {
        message$.add('Primeiramente gere os valores.');
        return;
      }
      Game game =
          Game(gameNumber: gameNumber ?? '', numbers: values.join(" - "));
      await gameRepository.save(game);
      addEvent(games: data.games..insert(0, game));
      message$.add("Jogo registrado com sucesso");
    } catch (e) {
      message$.add("Falha ao salvar jogo");
    }
  }

  /// format value to game
  String _extractValue({Game? game}) {
    String valueToCopy = '';
    if (game != null) {
      valueToCopy = game.numbers;
    } else {
      List<String> values = dataHelper
          .where((element) => element.controller.text != "")
          .map((e) => e.controller.text)
          .toList();
      valueToCopy = values.join(' - ');
    }
    return valueToCopy;
  }

  Future<void> copyText({Game? game}) async {
    try {
      String value = _extractValue(game: game);
      await Clipboard.setData(ClipboardData(text: value));
      message$.add("Valores copiados $value");
    } catch (e) {
      message$.add("Falha ao fazer cópia");
    }
  }

  Future<void> shareGame({Game? game}) async {
    try {
      await Share.share(_extractValue(game: game), subject: 'Mega sena');
    } catch (_) {
      message$.add('Falha ao compartilhar jogo');
    }
  }

  Future delete({required Game game}) async {
    try {
      await gameRepository.delete(game);
      addEvent(
          games: data.games
              .where((element) =>
                  element.createdAt.microsecondsSinceEpoch !=
                  game.createdAt.microsecondsSinceEpoch)
              .toList());
      message$.add('Jogo removido com sucesso');
    } catch (e) {
      message$.add('Falha ao remover jogo');
    }
  }

  /// dispose events.
  void dispose() {
    message$.close();
    searchField$.close();
    _streamSearchText?.cancel();
    super.dispose();
  }
}

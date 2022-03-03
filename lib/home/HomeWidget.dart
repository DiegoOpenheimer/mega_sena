import 'dart:async';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:mega_sena/config/ConfigWidget.dart';
import 'package:mega_sena/home/GameViewModel.dart';
import 'package:mega_sena/home/repository/GameRepositoryFactory.dart';
import 'package:mega_sena/shared/components/MegaSenaContainer.dart';

import 'fragments/create_game/CreateGame.dart';
import 'fragments/list_games/ListGame.dart';

class HomeWidget extends StatefulWidget {

  final PageController? _pageController;

  HomeWidget([this._pageController]);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController = widget._pageController ?? PageController();
  final GameViewModel _gameViewModel = GameViewModel(gameRepository: GameRepositoryFactory.resolve(TypeGameRepository.SEMBAST));
  late TabController _tabController = TabController(length: 3, vsync: this);
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = _gameViewModel.message$.stream.listen(handleMessage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _gameViewModel.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void handleMessage(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      action: SnackBarAction(
        onPressed: () {},
        label: "Fechar",
      ),
    ));
  }

  @override
  Widget build(context) {
    return MegaSenaContainer(
      child: Scaffold(
        body: _body(),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.flip,
          controller: _tabController,
          backgroundColor: Theme.of(context).primaryColor,
          items: [
            TabItem(
              icon: Icon(
                Icons.games_outlined,
                color: Colors.white,
              ),
              title: 'Jogos',
            ),
            TabItem(
              icon: Icon(
                Icons.create,
                color: Colors.white,
              ),
              title: 'Registrar',
            ),
            TabItem(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: 'Configuração',
            ),
          ],
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.decelerate);
          },
        ),
      ),
    );
  }

  Widget _body() {
    return PageView(
      onPageChanged: (int page) {
        _tabController.animateTo(page);
      },
      controller: _pageController,
      children: [
        ListGame(
          pageController: _pageController,
          gameViewModel: _gameViewModel,
        ),
        CreateGame(
          gameViewModel: _gameViewModel,
        ),
        ConfigWidget(),
      ],
    );
  }
}

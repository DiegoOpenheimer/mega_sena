import 'dart:io';

import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mega_sena/entities/Game.dart';
import 'package:mega_sena/home/GameData.dart';
import 'package:mega_sena/home/GameViewModel.dart';
import 'package:mega_sena/shared/Utils.dart';

class ListGame extends StatefulWidget {
  final PageController pageController;
  final GameViewModel gameViewModel;

  ListGame({required this.pageController, required this.gameViewModel});

  @override
  _ListGameState createState() => _ListGameState();
}

class _ListGameState extends State<ListGame>
    with AutomaticKeepAliveClientMixin {
  double opacity = 1;

  FocusNode _focusNode = FocusNode();
  bool isEditing = false;
  AnimateIconController _iconController = AnimateIconController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _buildAppBar(),
        Expanded(child: _buildList()),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    widget.gameViewModel.loadGames();
    widget.gameViewModel.listenSearchGame();
    widget.pageController.addListener(() {
      double page = widget.pageController.page ?? 0;
      if (page >= 0 && page <= 1) {
        setState(() {
          opacity = 1 - (page / 0.5);
        });
      }
    });
  }

  Widget _buildList() {
    return StreamBuilder<Data>(
      stream: widget.gameViewModel.streamData,
      builder: (context, snapshot) {
        Data data = widget.gameViewModel.data;
        if (data.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.error.isNotEmpty) {
          return Center(
            child: Text(data.error),
          );
        }
        if (data.games.isEmpty) {
          return Center(
            child: Text('Nenhum jogo registrado'),
          );
        }
        return ListView.builder(
            padding: const EdgeInsets.only(bottom: 32),
            itemCount: data.filteredGames.length,
            itemBuilder: (_, int index) {
              Game game = data.filteredGames[index];
              return TweenAnimationBuilder(
                curve: Curves.elasticInOut,
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 1000),
                builder: (_, double value, Widget? child) {
                  return Transform.scale(
                    scale: value.clamp(0.0, 1.0),
                    child: child,
                  );
                },
                child: _buildListTile(game),
              );
            });
      },
    );
  }

  ListTile _buildListTile(Game game) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16),
      title:
          Text(game.gameNumber.isEmpty ? 'Sem identificação' : game.gameNumber),
      subtitle: Text(game.numbers),
      trailing: AnimatedOpacity(
        duration: Duration.zero,
        opacity: opacity.clamp(0.0, 1.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: Platform.isAndroid || Platform.isIOS,
              child: IconButton(
                icon: Icon(Icons.share),
                onPressed: () => widget.gameViewModel.shareGame(game: game),
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () => widget.gameViewModel.copyText(game: game),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeGame(game),
            ),
          ],
        ),
      ),
    );
  }

  /// show alert to check if game should be removed
  void _removeGame(Game game) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Realmente deseja excluir o jogo com númeração ${game.numbers}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Não',
                  style: TextStyle(color: Colors.red),
                ),
                style: TextButton.styleFrom(primary: Colors.red),
              ),
              TextButton(
                  onPressed: () {
                    widget.gameViewModel.delete(game: game);
                    Navigator.of(context).pop();
                  },
                  child: Text('Sim')),
            ],
          );
        });
  }

  Widget _buildAppBar() {
    return TweenAnimationBuilder(
      tween: Tween(begin: Offset(0, -100), end: Offset(0, 0)),
      curve: Curves.elasticInOut,
      duration: const Duration(milliseconds: 1500),
      builder: (BuildContext context, Offset offset, Widget? child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: AppBar(
        title: _buildTitleAppBar(),
        actions: [
          AnimatedOpacity(
            opacity: opacity.clamp(0.0, 1.0),
            duration: Duration.zero,
            child: AnimateIcons(
              duration: const Duration(milliseconds: 300),
              startIconColor: Utils.getColorAccordingTheme(context),
              endIconColor: Utils.getColorAccordingTheme(context),
              endIcon: Icons.close,
              startIcon: Icons.search,
              controller: _iconController,
              onEndIconPress: () {
                toggleEdit();
                _iconController.animateToStart();
                return true;
              },
              onStartIconPress: () {
                toggleEdit();
                _iconController.animateToEnd();
                Future.delayed(const Duration(milliseconds: 300)).then((_) {
                  FocusScope.of(context).requestFocus(_focusNode);
                });
                return true;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitleAppBar() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isEditing
          ? TextField(
              focusNode: _focusNode,
              onChanged: widget.gameViewModel.searchField$.add,
              decoration: InputDecoration(hintText: 'Buscar'),
            )
          : Container(
              width: double.infinity,
              child: Text(
                'Mega Sena',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
    );
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        widget.gameViewModel.closeSearch();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

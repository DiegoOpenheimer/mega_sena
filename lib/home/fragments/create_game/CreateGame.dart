import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mega_sena/home/GameViewModel.dart';
import 'package:mega_sena/home/fragments/create_game/components/ContainerGameInput.dart';

class CreateGame extends StatefulWidget {
  final GameViewModel gameViewModel;

  CreateGame({required this.gameViewModel});

  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Criar jogo',
              style: Theme.of(context).textTheme.headline5,
            ),
            actions: [_buildActions()],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildFields(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFields(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Se quiser, você pode informar valores para serem inclusos no sorteio',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ContainerInputNumbers(gameViewModel: widget.gameViewModel),
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Widget _buildActions() {
    return ValueListenableBuilder(
        valueListenable: widget.gameViewModel.isFilled,
        builder: (BuildContext _, bool isFilled, Widget? ___) {
          if (isFilled) {
            return TweenAnimationBuilder(
                curve: Curves.elasticInOut,
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 1),
                builder: (context, double value, Widget? _) {
                  return Transform.scale(
                    scale: value.clamp(0.0, 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: widget.gameViewModel.copyText),
                        SizedBox(
                          width: 16,
                        ),
                        Visibility(
                            visible: Platform.isAndroid || Platform.isIOS,
                            child: IconButton(
                                icon: Icon(Icons.share), onPressed: widget.gameViewModel.shareGame))
                      ],
                    ),
                  );
                });
          }
          return Container();
        });
  }
}

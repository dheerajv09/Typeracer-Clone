import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state_provider.dart';
import '../utils/socket_client.dart';
import '../utils/socket_methods.dart';
import 'custom_button.dart';

class GameTextField extends StatefulWidget {
  const GameTextField({Key? key}) : super(key: key);

  @override
  _GameTextFieldState createState() => _GameTextFieldState();
}

class _GameTextFieldState extends State<GameTextField> {
  final SocketMethods _socketMethods = SocketMethods();
  var playerMe = null;
  bool isBtn = true;
  late GameStateProvider? game;

  @override
  void initState() {
    super.initState();
    game = Provider.of<GameStateProvider>(context, listen: false);
    findPlayerMe(game!);
  }

  findPlayerMe(GameStateProvider game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  handleStart(GameStateProvider game) {
    _socketMethods.startTimer(playerMe['_id'], game.gameState['id']);
    setState(() {
      isBtn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateProvider>(context);

    return CustomButton(
      text: 'START',
      onTap: () => handleStart(gameData),
    );
  }
}

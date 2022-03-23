import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state_provider.dart';
import '../utils/socket_client.dart';
import '../utils/socket_methods.dart';
import 'custom_button.dart';

class GameTextField extends StatefulWidget {
  GameTextField({Key? key, required this.clicked}) : super(key: key);

  VoidCallback clicked;

  @override
  _GameTextFieldState createState() => _GameTextFieldState();
}

class _GameTextFieldState extends State<GameTextField> {
  final SocketService _socketMethods = SocketService();
  var playerMe = null;
  bool isBtn = true;
  late GameStateController? game;

  final TextEditingController _wordsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    game = Provider.of<GameStateController>(context, listen: false);
    findPlayerMe(game!);
  }

  handleTextChange(String value, String gameID) {
    var lastChar = value[value.length - 1];

    if (lastChar == " ") {
      _socketMethods.sendUserInput(value, gameID);
      setState(() {
        _wordsController.text = "";
      });
    }
  }

  findPlayerMe(GameStateController game) {
    game.gameState['players'].forEach((player) {
      if (player['socketID'] == SocketClient.instance.socket!.id) {
        playerMe = player;
      }
    });
  }

  handleStart(GameStateController game) {
    _socketMethods.startTimer(playerMe['_id'], game.gameState['id']);
    setState(() {
      isBtn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameData = Provider.of<GameStateController>(context);

    return playerMe['isPartyLeader'] && isBtn
        ? CustomButton(
            text: 'START',
            onTap: () {
              widget.clicked;
              handleStart(gameData);
            },
          )
        : TextFormField(
            readOnly: gameData.gameState['isJoin'],
            controller: _wordsController,
            onChanged: (val) => handleTextChange(val, gameData.gameState['id']),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              fillColor: const Color(
                0xffF5F5FA,
              ),
              hintText: 'Type here',
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
  }
}

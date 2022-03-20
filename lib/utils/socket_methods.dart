import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_state_provider.dart';
import 'socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  bool _isPlaying = false;

  // creating game
  createGame(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('create-game', {
        'nickname': nickname,
      });
    }
  }

  //join game
  joinGame(String gameId, String nickname) {
    if (nickname.isNotEmpty && gameId.isNotEmpty) {
      _socketClient.emit('join-game', {
        'nickname': nickname,
        'gameId': gameId,
      });
    }
  }

  // listeners
  updateGameListener(BuildContext context) {
    _socketClient.on('updateGame', (data) {
      final gameStateProvider =
          Provider.of<GameStateProvider>(context, listen: false)
              .updateGameState(
        id: data['_id'],
        players: data['players'],
        isJoin: data['isJoin'],
        words: data['words'],
        isOver: data['isOver'],
      );

      if (data['_id'].isNotEmpty && !_isPlaying) {
        Navigator.pushNamed(context, '/game-screen');
        _isPlaying = true;
      }
    });
  }

  notCorrectGameListener(BuildContext context) {
    _socketClient.on(
      'notCorrectGame',
      (data) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data),
        ),
      ),
    );
  }
}

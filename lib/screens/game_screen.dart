import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/client_state_provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/socket_methods.dart';
import '../widgets/game_text_field.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateTimer(context);
    _socketMethods.updateGame(context);
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateProvider>(context);
    final clientStateProvider = Provider.of<ClientStateProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Chip(
                label: Text(
                  clientStateProvider.clientState['timer']['msg'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                clientStateProvider.clientState['timer']['countDown']
                    .toString(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: game.gameState['players'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            label: Text(
                              game.gameState['players'][index]['nickname'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Slider(
                            value: (game.gameState['players'][index]
                                    ['currentWordIndex'] /
                                game.gameState['words'].length),
                            onChanged: (val) {},
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        child: const GameTextField(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/client_state_provider.dart';
import '../providers/game_state_provider.dart';
import '../utils/socket_methods.dart';
import '../widgets/game_text_field.dart';
import '../widgets/sentence_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketService _socketMethods = SocketService();
  bool startTimer = false;

  @override
  void initState() {
    super.initState();
    _socketMethods.updateTimer(context);
    _socketMethods.updateGame(context);
    _socketMethods.gameFinishedListener();
  }

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameStateController>(context);
    final clientStateProvider = Provider.of<ClientStateController>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: startTimer
                      ? Chip(
                          label: Text(
                            clientStateProvider.clientState['timer']['msg']
                                .toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )
                      : Container(),
                ),
                Center(
                  child: Text(
                    clientStateProvider.clientState['timer']['countDown']
                        .toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SentenceGame(),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                    maxHeight: 50,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: game.gameState['players'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Chip(
                          label: Text(
                            game.gameState['players'][index]['nickname'],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                game.gameState['isJoin']
                    ? ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 600,
                        ),
                        child: GestureDetector(
                          onTap: () => Clipboard.setData(ClipboardData(
                            text: game.gameState['id'],
                          )).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Game Code copied to clickboard!'),
                              ),
                            );
                          }),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: 40,
                            child: Row(
                              children: const [
                                Text(
                                  "Copy game code",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.copy),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          child: GameTextField(
            clicked: () {
              setState(() {
                startTimer = true;
              });
            },
          ),
        ),
      ),
    );
  }
}

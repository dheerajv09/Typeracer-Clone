import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeracer_clone/providers/client_state_provider.dart';

import 'providers/game_state_provider.dart';
import 'screens/create_room_screen.dart';
import 'screens/game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/join_room_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameStateController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ClientStateController(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/create-room': (context) => const CreateRoomScreen(),
          '/join-room': (context) => const JoinRoomScreen(),
          '/game-screen': (context) => const GameScreen(),
        },
      ),
    );
  }
}

import 'package:bagarre/game/game.dart';
import 'package:bagarre/models/generation.dart';
import 'package:bagarre/res/overlays.dart';
import 'package:bagarre/widgets/fight_overlay.dart';
import 'package:bagarre/widgets/fights_grid.dart';
import 'package:bagarre/widgets/iteration_mode_selector.dart';
import 'package:bagarre/widgets/time_dilatation_selector.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const GenerationsApp());
}

class GenerationsApp extends StatefulWidget {
  const GenerationsApp({super.key});

  @override
  State<GenerationsApp> createState() => _GenerationsAppState();
}

class _GenerationsAppState extends State<GenerationsApp> {
  Generation _generation = Generation.initial();
  IterationMode _iterationMode = IterationMode.classic;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bagarre',
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Generation ${_generation.generationIndex}'),
          actions: [
            IterationModeSelector(
              selected: _iterationMode,
              onSelectionChanged: (mode) => setState(() {
                _iterationMode = mode;
              }),
            ),
            const SizedBox(width: 10),
            const TimeDilatationSelector(),
          ],
        ),
        body: FightsGrid(
          key: ValueKey(_generation),
          fights: _generation.fights,
          onFightEnd: (fight, game) {
            _generation.reportFightEnd(fight, playerA: game.playerA, playerB: game.playerB);

            if (_generation.fights.every((fight) => fight.isDuelOver)) {
              setState(
                () {
                  if (_iterationMode == IterationMode.tournament) {
                    _generation = _generation.tournamentNextFights();
                  } else {
                    _generation = _generation.nextGeneration();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bagarre',
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(title: const Text('Bagarre')),
        body: GameWidget.controlled(
          gameFactory: BagarreGame.new,
          overlayBuilderMap: <String, OverlayWidgetBuilder<BagarreGame>>{
            Overlays.fightOverlay: (context, game) => FightOverlay(game: game),
          },
        ),
      ),
    );
  }
}

import 'package:bagarre/models/generation.dart';
import 'package:bagarre/widgets/fights_grid.dart';
import 'package:bagarre/widgets/iteration_mode_selector.dart';
import 'package:bagarre/widgets/time_dilatation_selector.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

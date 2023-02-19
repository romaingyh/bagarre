import 'package:bagarre/game/game.dart';
import 'package:flutter/material.dart';

class FightOverlay extends StatelessWidget {
  final BagarreGame game;

  const FightOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder(
            valueListenable: game.playerA.health,
            builder: (context, value, child) => Text(
              value.toString(),
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: game.playerB.health,
            builder: (context, value, child) => Text(
              value.toString(),
              style: theme.textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

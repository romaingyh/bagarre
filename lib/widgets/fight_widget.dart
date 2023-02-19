import 'package:bagarre/game/game.dart';
import 'package:bagarre/models/fight.dart';
import 'package:bagarre/res/overlays.dart';
import 'package:bagarre/widgets/fight_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class FightWidget extends StatelessWidget {
  final Fight fight;
  final void Function(BagarreGame game) onFightEnd;

  const FightWidget({super.key, required this.fight, required this.onFightEnd});

  @override
  Widget build(BuildContext context) {
    return GameWidget.controlled(
      gameFactory: () => BagarreGame(
        fightDurationS: 30,
        dnas: fight.dnas,
        onFightEnd: onFightEnd,
      ),
      overlayBuilderMap: <String, OverlayWidgetBuilder<BagarreGame>>{
        Overlays.fightOverlay: (context, game) => FightOverlay(game: game),
      },
    );
  }
}
